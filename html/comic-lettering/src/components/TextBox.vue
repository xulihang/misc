<template>
  <div
    class="text-box"
    :class="{ selected }"
    :style="boxStyle"
    @mousedown="onMouseDown"
  >
    <div class="inner" :style="innerStyle">
      {{ box.text }}
    </div>
    <div
      v-if="selected"
      v-for="h in handles"
      :key="h"
      :class="['handle', h]"
      :data-handle="h"
    />
  </div>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  box: Object,
  selected: Boolean,
})

const emit = defineEmits(['mousedown'])

const handles = ['nw','n','ne','e','se','s','sw','w']

const boxStyle = computed(() => ({
  left: props.box.x + 'px',
  top: props.box.y + 'px',
  width: props.box.w + 'px',
  height: props.box.h + 'px',
}))

const textShadow = computed(() => {
  const b = props.box
  if (b.strokeWidth <= 0) return 'none'
  const sw = b.strokeWidth
  const sc = b.strokeColor
  const shadows = []
  for (let dx = -1; dx <= 1; dx++) {
    for (let dy = -1; dy <= 1; dy++) {
      if (dx === 0 && dy === 0) continue
      shadows.push(`${dx * sw}px ${dy * sw}px 0 ${sc}`)
    }
  }
  return shadows.join(',')
})

const innerStyle = computed(() => {
  const b = props.box
  return {
    fontFamily: `"${b.fontFamily}", sans-serif`,
    fontSize: b.fontSize + 'px',
    color: b.color,
    fontWeight: b.bold ? 'bold' : 'normal',
    fontStyle: b.italic ? 'italic' : 'normal',
    lineHeight: b.lineHeight,
    textAlign: b.textAlign,
    background: b.bgOpacity > 0
      ? b.bgColor + Math.round(b.bgOpacity * 2.55).toString(16).padStart(2, '0')
      : 'transparent',
    writingMode: b.vertical ? 'vertical-rl' : 'horizontal-tb',
    textShadow: textShadow.value,
  }
})

function onMouseDown(e) {
  emit('mousedown', e, props.box)
}
</script>

<style scoped>
.text-box {
  position: absolute;
  border: 1.5px dashed transparent;
  cursor: move;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
  word-break: break-all;
  line-height: 1.4;
  transition: border-color .15s;
  min-width: 20px;
  min-height: 20px;
}
.text-box:hover {
  border-color: rgba(255,255,255,0.3);
}
.text-box.selected {
  border-color: var(--accent);
  border-style: solid;
  z-index: 10;
}
.inner {
  width: 100%;
  height: 100%;
  padding: 4px;
  outline: none;
  overflow: hidden;
}
.handle {
  position: absolute;
  width: 10px;
  height: 10px;
  background: #fff;
  border: 2px solid var(--accent);
  border-radius: 2px;
  z-index: 20;
}
.handle.nw { top: -5px; left: -5px; cursor: nw-resize; }
.handle.n  { top: -5px; left: 50%; margin-left: -5px; cursor: n-resize; }
.handle.ne { top: -5px; right: -5px; cursor: ne-resize; }
.handle.e  { top: 50%; right: -5px; margin-top: -5px; cursor: e-resize; }
.handle.se { bottom: -5px; right: -5px; cursor: se-resize; }
.handle.s  { bottom: -5px; left: 50%; margin-left: -5px; cursor: s-resize; }
.handle.sw { bottom: -5px; left: -5px; cursor: sw-resize; }
.handle.w  { top: 50%; left: -5px; margin-top: -5px; cursor: w-resize; }
</style>
