<template>
  <div class="panel">
    <div v-if="!box" class="empty">
      选择文本框以编辑属性<br><br>拖拽图片创建新文本框
    </div>
    <div v-else class="content">
      <h3>文本框属性</h3>

      <label>文本内容</label>
      <textarea
        :value="box.text"
        @input="e => $emit('update', 'text', e.target.value)"
        placeholder="输入文本..."
      ></textarea>

      <label>字体</label>
      <select
        :value="box.fontFamily"
        @change="e => $emit('update', 'fontFamily', e.target.value)"
      >
        <option value="Microsoft YaHei">微软雅黑</option>
        <option value="SimHei">黑体</option>
        <option value="SimSun">宋体</option>
        <option value="KaiTi">楷体</option>
        <option value="FangSong">仿宋</option>
        <option value="Arial">Arial</option>
        <option value="Times New Roman">Times New Roman</option>
        <option value="Comic Sans MS">Comic Sans MS</option>
        <option value="Impact">Impact</option>
        <option value="sans-serif">无衬线体</option>
        <option value="serif">衬线体</option>
      </select>

      <div class="row">
        <div>
          <label>字号</label>
          <input type="number"
            :value="box.fontSize"
            @input="e => $emit('update', 'fontSize', parseInt(e.target.value) || 24)"
            min="4" max="500" step="1"
          />
        </div>
        <div>
          <label>行高</label>
          <input type="number"
            :value="box.lineHeight"
            @input="e => $emit('update', 'lineHeight', parseFloat(e.target.value) || 1.4)"
            min="0.5" max="3" step="0.1"
          />
        </div>
      </div>

      <div class="row">
        <div>
          <label>文字颜色</label>
          <input type="color"
            :value="box.color"
            @input="e => $emit('update', 'color', e.target.value)"
          />
        </div>
        <div>
          <label>背景颜色</label>
          <input type="color"
            :value="box.bgColor"
            @input="e => $emit('update', 'bgColor', e.target.value)"
          />
        </div>
      </div>

      <div class="row">
        <div>
          <label>描边颜色</label>
          <input type="color"
            :value="box.strokeColor"
            @input="e => $emit('update', 'strokeColor', e.target.value)"
          />
        </div>
        <div>
          <label>描边宽度</label>
          <input type="number"
            :value="box.strokeWidth"
            @input="e => $emit('update', 'strokeWidth', parseFloat(e.target.value) || 0)"
            min="0" max="20" step="0.5"
          />
        </div>
      </div>

      <label>背景不透明度</label>
      <input type="range"
        :value="box.bgOpacity"
        @input="e => $emit('update', 'bgOpacity', parseInt(e.target.value))"
        min="0" max="100" step="1"
      />

      <div class="style-buttons">
        <button :class="{ active: box.bold }" @click="$emit('bold')"><b>B</b></button>
        <button :class="{ active: box.italic }" @click="$emit('italic')"><i>I</i></button>
        <button :class="{ active: box.textAlign === 'left' }" @click="$emit('align', 'left')">⫷</button>
        <button :class="{ active: box.textAlign === 'center' }" @click="$emit('align', 'center')">≣</button>
        <button :class="{ active: box.textAlign === 'right' }" @click="$emit('align', 'right')">⫸</button>
      </div>

      <label>
        <input type="checkbox"
          :checked="box.vertical"
          @change="e => $emit('update', 'vertical', e.target.checked)"
        />
        垂直文字
      </label>

      <div class="row">
        <div>
          <label>X</label>
          <input type="number"
            :value="Math.round(box.x)"
            @input="e => $emit('update', 'x', parseFloat(e.target.value) || 0)"
            step="1"
          />
        </div>
        <div>
          <label>Y</label>
          <input type="number"
            :value="Math.round(box.y)"
            @input="e => $emit('update', 'y', parseFloat(e.target.value) || 0)"
            step="1"
          />
        </div>
      </div>

      <div class="row">
        <div>
          <label>宽</label>
          <input type="number"
            :value="Math.round(box.w)"
            @input="e => $emit('update', 'w', parseFloat(e.target.value) || 100)"
            min="10" step="1"
          />
        </div>
        <div>
          <label>高</label>
          <input type="number"
            :value="Math.round(box.h)"
            @input="e => $emit('update', 'h', parseFloat(e.target.value) || 50)"
            min="10" step="1"
          />
        </div>
      </div>

      <button class="wide danger" @click="$emit('delete')">✕ 删除此文本框</button>
    </div>
  </div>
</template>

<script setup>
defineProps({
  box: Object,
})
defineEmits(['update', 'delete', 'bold', 'italic', 'align'])
</script>

<style scoped>
.panel {
  width: 300px;
  background: var(--surface);
  border-left: 1px solid var(--border);
  overflow-y: auto;
  flex-shrink: 0;
  padding: 16px;
}
.panel h3 {
  font-size: 15px;
  margin-bottom: 12px;
  color: var(--text);
}
.panel .empty {
  color: var(--text2);
  font-size: 13px;
  text-align: center;
  padding: 40px 0;
}
.panel .content {
  display: flex;
  flex-direction: column;
  gap: 0;
}
.panel label {
  display: block;
  font-size: 12px;
  color: var(--text2);
  margin-bottom: 4px;
  margin-top: 12px;
}
.panel label:first-child { margin-top: 0; }
.panel textarea {
  width: 100%;
  height: 100px;
  resize: vertical;
  padding: 8px;
  background: var(--bg);
  border: 1px solid var(--border);
  border-radius: 6px;
  color: var(--text);
  font-size: 13px;
  font-family: inherit;
}
.panel select, .panel input[type="number"], .panel input[type="text"] {
  width: 100%;
  padding: 6px 8px;
  background: var(--bg);
  border: 1px solid var(--border);
  border-radius: 6px;
  color: var(--text);
  font-size: 13px;
}
.panel input[type="color"] {
  width: 32px;
  height: 32px;
  padding: 2px;
  border: 1px solid var(--border);
  border-radius: 6px;
  cursor: pointer;
  background: var(--bg);
}
.panel input[type="range"] {
  width: 100%;
  accent-color: var(--accent);
}
.panel .row {
  display: flex;
  gap: 8px;
  align-items: center;
  margin-top: 12px;
}
.panel .row > * {
  flex: 1;
}
.panel button.wide {
  width: 100%;
  padding: 8px;
  margin-top: 12px;
  border: 1px solid var(--border);
  border-radius: 6px;
  background: var(--surface2);
  color: var(--text);
  cursor: pointer;
  font-size: 13px;
}
.panel button.wide:hover {
  background: var(--border);
}
.panel button.wide.danger {
  border-color: var(--danger);
  color: var(--danger);
}
.panel button.wide.danger:hover {
  background: var(--danger);
  color: #fff;
}
.style-buttons {
  display: flex;
  gap: 8px;
  margin-top: 12px;
}
.style-buttons button {
  flex: 1;
  padding: 6px 8px;
  border: 1px solid var(--border);
  border-radius: 6px;
  background: var(--surface2);
  color: var(--text);
  cursor: pointer;
  font-size: 13px;
}
.style-buttons button:hover {
  background: var(--border);
}
.style-buttons button.active {
  background: var(--accent);
  color: #fff;
  border-color: var(--accent);
}

@media (max-width: 800px) {
  .panel {
    width: 100%;
    max-height: 40vh;
    border-left: none;
    border-top: 1px solid var(--border);
  }
}
</style>
