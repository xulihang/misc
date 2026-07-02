<template>
  <div
    class="workspace-wrap"
    ref="wrapEl"
    @mousedown="onWsMouseDown"
    @mousemove="onWsMouseMove"
    @mouseup="comic.onMouseUp()"
    @wheel.stop.prevent="comic.onWheel"
    @dragover.prevent
    @drop="onDrop"
  >
    <div
      class="workspace-scroll"
      :style="{
        transform: `scale(${comic.scale.value})`,
        transformOrigin: '0 0',
        width: comic.imgNaturalW.value ? comic.imgNaturalW.value + 'px' : 'auto',
        height: comic.imgNaturalH.value ? comic.imgNaturalH.value + 'px' : 'auto',
      }"
    >
      <div
        class="image-canvas"
        ref="canvasEl"
        :style="comic.imgNaturalW.value ? { width: comic.imgNaturalW.value + 'px', height: comic.imgNaturalH.value + 'px' } : {}"
      >
        <img
          v-if="comic.imageSrc.value"
          :src="comic.imageSrc.value"
          :width="comic.imgNaturalW.value"
          :height="comic.imgNaturalH.value"
        />
        <TextBox
          v-for="box in comic.textBoxes.value"
          :key="box.id"
          :box="box"
          :selected="box.id === comic.selectedId.value"
          @mousedown="(e, b) => onBoxDown(e, b)"
        />
      </div>
    </div>
    <div v-if="comic.showInstructions.value" class="instructions">
      拖拽鼠标创建文本框 | 点击选中文本框进行编辑 | 滚轮缩放
    </div>
  </div>
</template>

<script setup>
import { ref, inject } from 'vue'
import TextBox from './TextBox.vue'

const comic = inject('comic')
const wrapEl = ref(null)
const canvasEl = ref(null)

function onWsMouseDown(e) {
  if (canvasEl.value) comic.onWorkspaceMouseDown(e, canvasEl.value)
}

function onWsMouseMove(e) {
  if (canvasEl.value) comic.onWorkspaceMouseMove(e, canvasEl.value)
}

function onBoxDown(e, box) {
  if (canvasEl.value) comic.onBoxMouseDown(e, box, canvasEl.value)
}

function onDrop(e) {
  const file = e.dataTransfer.files[0]
  if (file && file.type.startsWith('image/')) {
    comic.loadImage(file)
  }
}

defineExpose({ canvasEl, wrapEl })
</script>

<style scoped>
.workspace-wrap {
  flex: 1;
  overflow: auto;
  position: relative;
  background: #1a1a24;
  background-image:
    linear-gradient(45deg, #222 25%, transparent 25%),
    linear-gradient(-45deg, #222 25%, transparent 25%),
    linear-gradient(45deg, transparent 75%, #222 75%),
    linear-gradient(-45deg, transparent 75%, #222 75%);
  background-size: 20px 20px;
  background-position: 0 0, 0 10px, 10px -10px, -10px 0px;
}

.workspace-scroll {
  position: relative;
  transform-origin: 0 0;
}

.image-canvas {
  position: relative;
  display: inline-block;
}

.image-canvas img {
  display: block;
  max-width: none;
}

.instructions {
  position: absolute;
  bottom: 16px;
  left: 50%;
  transform: translateX(-50%);
  background: rgba(0,0,0,0.75);
  color: #ccc;
  font-size: 12px;
  padding: 8px 14px;
  border-radius: 20px;
  pointer-events: none;
  z-index: 50;
  transition: opacity .3s;
  white-space: nowrap;
}
</style>
