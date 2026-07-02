<template>
  <div class="app-container" @keydown="realKeyDown" tabindex="0" ref="appRef">
    <Toolbar
      :scale="scale"
      @open="triggerFileInput"
      @add="addBox"
      @export="handleExport"
      @zoom-in="zoomIn"
      @zoom-out="zoomOut"
      @zoom-fit="handleZoomFit"
      @zoom-100="zoomTo100"
      @duplicate="duplicateSelected"
      @delete="deleteSelected"
    />
    <div class="main">
      <Workspace ref="workspaceRef" />
      <PropertiesPanel
        :box="selectedBox"
        @update="onPanelUpdate"
        @delete="deleteSelected"
        @bold="toggleBold"
        @italic="toggleItalic"
        @align="setAlign"
      />
    </div>
    <input
      type="file"
      id="file-input"
      accept="image/*"
      style="display:none"
      @change="onFileChange"
    />
  </div>
</template>

<script setup>
import { ref, provide, onMounted } from 'vue'
import { useComicLettering } from './composables/useComicLettering.js'
import Toolbar from './components/Toolbar.vue'
import Workspace from './components/Workspace.vue'
import PropertiesPanel from './components/PropertiesPanel.vue'

const composable = useComicLettering()
provide('comic', composable)

const {
  textBoxes, selectedId, selectedBox, imageSrc, imgNaturalW, imgNaturalH,
  scale, showInstructions,
  loadImage, addBox, deleteSelected, duplicateSelected,
  selectBox, deselectAll,
  onKeyDown,
  zoomIn, zoomOut, zoomToFit, zoomTo100, doExport,
} = composable

const workspaceRef = ref(null)
const appRef = ref(null)

function triggerFileInput() {
  document.getElementById('file-input').click()
}

function onFileChange(e) {
  if (e.target.files[0]) loadImage(e.target.files[0])
  e.target.value = ''
}

function handleExport() {
  const canvasEl = workspaceRef.value?.canvasEl
  if (canvasEl) doExport(canvasEl)
}

function handleZoomFit() {
  const wrap = workspaceRef.value?.wrapEl
  if (wrap) zoomToFit(wrap.clientWidth, wrap.clientHeight)
}

function onPanelUpdate(prop, value) {
  if (!selectedBox.value) return
  selectedBox.value[prop] = value
}

function toggleBold() {
  if (selectedBox.value) selectedBox.value.bold = !selectedBox.value.bold
}

function toggleItalic() {
  if (selectedBox.value) selectedBox.value.italic = !selectedBox.value.italic
}

function setAlign(align) {
  if (selectedBox.value) selectedBox.value.textAlign = align
}

const origKeyDown = onKeyDown
const realKeyDown = (e) => {
  const mod = e.ctrlKey || e.metaKey
  if (mod) {
    if (e.key === 's') { e.preventDefault(); handleExport(); return }
    if (e.key === '0') { e.preventDefault(); handleZoomFit(); return }
    if (e.key === 'o') { e.preventDefault(); triggerFileInput(); return }
  }
  origKeyDown(e)
}

onMounted(() => {
  appRef.value?.focus()
})
</script>

<style>
:root {
  --bg: #1e1e2e;
  --surface: #282840;
  --surface2: #333355;
  --border: #444466;
  --text: #e0e0f0;
  --text2: #a0a0c0;
  --accent: #5b9cf5;
  --accent-hover: #7ab4f8;
  --danger: #e0556a;
  --danger-hover: #f07080;
}

.app-container {
  display: flex;
  flex-direction: column;
  height: 100%;
  outline: none;
}

.main {
  display: flex;
  flex: 1;
  overflow: hidden;
}

@media (max-width: 800px) {
  .main {
    flex-direction: column;
  }
}
</style>
