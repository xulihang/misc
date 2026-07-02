import { ref, computed, nextTick } from 'vue'
import { toCanvas } from 'html-to-image'

let nextId = 1

function makeDefaultBox(x, y) {
  const id = nextId++
  return {
    id,
    x: x ?? 0,
    y: y ?? 0,
    w: 200,
    h: 60,
    text: '输入文本',
    fontFamily: 'Microsoft YaHei',
    fontSize: 24,
    lineHeight: 1.4,
    color: '#000000',
    bold: false,
    italic: false,
    textAlign: 'center',
    bgColor: '#ffffff',
    bgOpacity: 100,
    strokeColor: '#000000',
    strokeWidth: 0,
    vertical: false,
  }
}

export function useComicLettering() {
  // ── State ──
  const textBoxes = ref([])
  const selectedId = ref(null)
  const imageSrc = ref(null)
  const imgNaturalW = ref(0)
  const imgNaturalH = ref(0)
  const scale = ref(1)
  const showInstructions = ref(true)

  // Drag state
  let dragging = null
  let dragStartX = 0
  let dragStartY = 0
  let dragOrig = {}

  const selectedBox = computed(() => {
    return textBoxes.value.find(b => b.id === selectedId.value) || null
  })

  // ── Zoom ──
  function zoomIn() {
    scale.value = Math.min(scale.value + 0.2, 5)
  }

  function zoomOut() {
    scale.value = Math.max(scale.value - 0.2, 0.1)
  }

  function zoomToFit(viewportW, viewportH) {
    if (!imgNaturalW.value) return
    scale.value = Math.min(
      (viewportW - 40) / imgNaturalW.value,
      (viewportH - 40) / imgNaturalH.value,
      1
    )
  }

  function zoomTo100() {
    scale.value = 1
  }

  // ── Image ──
  function loadImage(file) {
    const reader = new FileReader()
    reader.onload = function(e) {
      const img = new Image()
      img.onload = function() {
        imageSrc.value = e.target.result
        imgNaturalW.value = img.naturalWidth
        imgNaturalH.value = img.naturalHeight
        textBoxes.value = []
        selectedId.value = null
        showInstructions.value = true
      }
      img.src = e.target.result
    }
    reader.readAsDataURL(file)
  }

  // ── Selection ──
  function selectBox(id) {
    selectedId.value = id
    if (id != null) showInstructions.value = false
  }

  function deselectAll() {
    selectedId.value = null
  }

  // ── Box CRUD ──
  function addBox() {
    if (!imageSrc.value) return
    const box = makeDefaultBox(
      (imgNaturalW.value / 2 - 100),
      (imgNaturalH.value / 2 - 30)
    )
    textBoxes.value.push(box)
    selectBox(box.id)
  }

  function deleteSelected() {
    if (selectedId.value == null) return
    textBoxes.value = textBoxes.value.filter(b => b.id !== selectedId.value)
    selectedId.value = null
  }

  function duplicateSelected() {
    if (selectedId.value == null) return
    const box = textBoxes.value.find(b => b.id === selectedId.value)
    if (!box) return
    const newBox = makeDefaultBox()
    Object.assign(newBox, { ...box, id: newBox.id, x: box.x + 20, y: box.y + 20 })
    textBoxes.value.push(newBox)
    selectBox(newBox.id)
  }

  // ── Workspace drag to create ──
  function onWorkspaceMouseDown(e, canvasEl) {
    if (e.button === 1 || !imageSrc.value) return
    if (e.target.closest('.text-box')) return
    deselectAll()

    const pos = getWorkspacePos(e, canvasEl)
    dragging = 'create'
    dragStartX = pos.x
    dragStartY = pos.y
    const box = makeDefaultBox(pos.x, pos.y)
    box.w = 1
    box.h = 1
    textBoxes.value.push(box)
    selectBox(box.id)
    dragOrig = { boxId: box.id }
    e.preventDefault()
  }

  function onWorkspaceMouseMove(e, canvasEl) {
    if (!dragging) return
    const pos = getWorkspacePos(e, canvasEl)

    const box = textBoxes.value.find(b => b.id === dragOrig.boxId)
    if (!box) return

    if (dragging === 'create') {
      box.x = Math.min(pos.x, dragStartX)
      box.y = Math.min(pos.y, dragStartY)
      box.w = Math.abs(pos.x - dragStartX)
      box.h = Math.abs(pos.y - dragStartY)
    } else if (dragging === 'move') {
      box.x = dragOrig.x + (pos.x - dragStartX)
      box.y = dragOrig.y + (pos.y - dragStartY)
    } else if (typeof dragging === 'string' && dragging.length === 2) {
      const dx = pos.x - dragStartX
      const dy = pos.y - dragStartY
      if (dragging.includes('e')) box.w = Math.max(dragOrig.w + dx, 20)
      if (dragging.includes('w')) { box.w = Math.max(dragOrig.w - dx, 20); box.x = dragOrig.x + dx }
      if (dragging.includes('s')) box.h = Math.max(dragOrig.h + dy, 20)
      if (dragging.includes('n')) { box.h = Math.max(dragOrig.h - dy, 20); box.y = dragOrig.y + dy }
    }
  }

  function onMouseUp() {
    if (dragging === 'create') {
      const box = textBoxes.value.find(b => b.id === dragOrig.boxId)
      if (box && (box.w < 10 || box.h < 10)) {
        textBoxes.value = textBoxes.value.filter(b => b.id !== box.id)
        deselectAll()
      }
    }
    dragging = null
  }

  // ── Box mouse down (move + resize) ──
  function onBoxMouseDown(e, box, canvasEl) {
    if (e.button === 1) return
    e.stopPropagation()
    selectBox(box.id)

    const handleEl = e.target.closest('.handle')
    if (handleEl) {
      dragging = handleEl.dataset.handle
      const pos = getWorkspacePos(e, canvasEl)
      dragStartX = pos.x
      dragStartY = pos.y
      dragOrig = { boxId: box.id, x: box.x, y: box.y, w: box.w, h: box.h }
      e.preventDefault()
      return
    }

    dragging = 'move'
    const pos = getWorkspacePos(e, canvasEl)
    dragStartX = pos.x
    dragStartY = pos.y
    dragOrig = { boxId: box.id, x: box.x, y: box.y }
    e.preventDefault()
  }

  // ── Helpers ──
  function getWorkspacePos(e, canvasEl) {
    const rect = canvasEl.getBoundingClientRect()
    return {
      x: (e.clientX - rect.left) / scale.value,
      y: (e.clientY - rect.top) / scale.value
    }
  }

  function clamp(v, min, max) {
    return Math.max(min, Math.min(max, v))
  }

  // ── Export ──
  async function doExport(canvasEl) {
    if (!imageSrc.value) {
      alert('请先打开一张图片')
      return
    }

    const prevScale = scale.value
    if (prevScale !== 1) {
      scale.value = 1
      await nextTick()
      await new Promise(r => requestAnimationFrame(r))
      await new Promise(r => requestAnimationFrame(r))
    }

    try {
      const result = await toCanvas(canvasEl, {
        pixelRatio: 1,
        skipAutoScale: true,
      })

      result.toBlob(blob => {
        const url = URL.createObjectURL(blob)
        const a = document.createElement('a')
        a.href = url
        a.download = 'comic_edited.png'
        a.click()
        URL.revokeObjectURL(url)
      })
    } finally {
      if (prevScale !== 1) {
        scale.value = prevScale
      }
    }
  }

  // ── Keyboard shortcuts ──
  function onKeyDown(e) {
    const mod = e.ctrlKey || e.metaKey
    const tag = document.activeElement?.tagName
    const isInput = tag === 'TEXTAREA' || tag === 'INPUT'

    if ((e.key === 'Delete' || e.key === 'Backspace') && !isInput) {
      deleteSelected()
    }
    if (mod && e.key === 'd') { e.preventDefault(); duplicateSelected() }
    if (mod && e.key === 'o') { e.preventDefault(); document.getElementById('file-input')?.click() }
    if (mod && e.key === '0') { e.preventDefault(); /* handled in component */ }
    if (mod && e.key === '1') { e.preventDefault(); zoomTo100() }
    if (mod && e.key === 's') { e.preventDefault(); /* handled in component */ }

    // Nudge selected box
    if (selectedId.value != null && ['ArrowUp','ArrowDown','ArrowLeft','ArrowRight'].includes(e.key)) {
      if (isInput) return
      e.preventDefault()
      const box = textBoxes.value.find(b => b.id === selectedId.value)
      if (!box) return
      const step = e.shiftKey ? 10 : 1
      if (e.key === 'ArrowLeft') box.x -= step
      if (e.key === 'ArrowRight') box.x += step
      if (e.key === 'ArrowUp') box.y -= step
      if (e.key === 'ArrowDown') box.y += step
    }
    if (e.key === 'Escape') deselectAll()
  }

  // ── Wheel zoom ──
  function onWheel(e) {
    if (!imageSrc.value) return
    e.preventDefault()
    const delta = e.deltaY > 0 ? -0.1 : 0.1
    scale.value = clamp(scale.value + delta, 0.1, 5)
  }

  return {
    textBoxes,
    selectedId,
    selectedBox,
    imageSrc,
    imgNaturalW,
    imgNaturalH,
    scale,
    showInstructions,
    // methods
    loadImage,
    addBox,
    deleteSelected,
    duplicateSelected,
    selectBox,
    deselectAll,
    onWorkspaceMouseDown,
    onWorkspaceMouseMove,
    onMouseUp,
    onBoxMouseDown,
    onKeyDown,
    onWheel,
    zoomIn,
    zoomOut,
    zoomToFit,
    zoomTo100,
    doExport,
  }
}
