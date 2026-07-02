<template>
  <div class="toolbar">
    <button class="accent" @click="$emit('open')" title="打开漫画图片 (Ctrl+O)">📂 打开图片</button>
    <button @click="$emit('add')" title="添加文本框">＋ 添加文本框</button>
    <button class="accent" @click="$emit('export')" title="导出为PNG (Ctrl+S)">⬇ 导出</button>
    <span class="sep"></span>
    <button @click="$emit('zoom-out')" title="缩小">－</button>
    <span class="zoom-label">{{ Math.round(scale * 100) }}%</span>
    <button @click="$emit('zoom-in')" title="放大">＋</button>
    <button @click="$emit('zoom-fit')" title="适应窗口 (Ctrl+0)">⊡</button>
    <button @click="$emit('zoom-100')" title="100% (Ctrl+1)">1:1</button>
    <span class="sep"></span>
    <button @click="$emit('duplicate')" title="复制选中文本框 (Ctrl+D)">📋 复制</button>
    <button class="danger" @click="$emit('delete')" title="删除选中文本框 (Delete)">✕ 删除</button>
  </div>
</template>

<script setup>
defineProps({
  scale: { type: Number, default: 1 },
  hasImage: { type: Boolean, default: false },
})
defineEmits([
  'open', 'add', 'export',
  'zoom-in', 'zoom-out', 'zoom-fit', 'zoom-100',
  'duplicate', 'delete',
])
</script>

<style scoped>
.toolbar {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 8px 12px;
  background: var(--surface);
  border-bottom: 1px solid var(--border);
  flex-shrink: 0;
  flex-wrap: wrap;
  z-index: 100;
}
.toolbar button {
  padding: 6px 14px;
  border: 1px solid var(--border);
  border-radius: 6px;
  background: var(--surface2);
  color: var(--text);
  cursor: pointer;
  font-size: 13px;
  white-space: nowrap;
  transition: background .15s;
}
.toolbar button:hover {
  background: var(--border);
}
.toolbar button.accent {
  background: var(--accent);
  border-color: var(--accent);
  color: #fff;
}
.toolbar button.accent:hover {
  background: var(--accent-hover);
}
.toolbar button.danger {
  background: transparent;
  border-color: var(--danger);
  color: var(--danger);
}
.toolbar button.danger:hover {
  background: var(--danger);
  color: #fff;
}
.toolbar .sep {
  width: 1px;
  height: 22px;
  background: var(--border);
  margin: 0 4px;
}
.toolbar .zoom-label {
  font-size: 13px;
  color: var(--text2);
  min-width: 42px;
  text-align: center;
}
</style>
