# 漫画嵌字工具 — Vue 项目架构说明

## 1. 入口：`index.html` → `main.js`

```
index.html  →  src/main.js  →  App.vue  →  子组件
```

[index.html](index.html) 是一个普通的 HTML 文件，里面有一个 `<div id="app">`，Vue 会接管这个 div。最后一行 `<script type="module" src="/src/main.js">` 加载入口 JS。

[main.js](src/main.js) 只有 3 行：

```js
import { createApp } from 'vue'
import App from './App.vue'
createApp(App).mount('#app')
```

`createApp(App)` 创建一个 Vue 应用实例，`.mount('#app')` 把它挂载到 HTML 中的 `<div id="app">` 上。`App` 就是根组件。

## 2. 核心概念：组件树

整个页面被拆成**组件**，每个组件是一个 `.vue` 文件，负责一块 UI：

```
App.vue                          ← 根组件，总管一切
├── Toolbar.vue                   ← 顶部工具栏（按钮）
├── Workspace.vue                 ← 左侧图片工作区
│   └── TextBox.vue × N           ← 每个文本框（v-for 循环渲染）
└── PropertiesPanel.vue           ← 右侧属性面板
```

每个 `.vue` 文件包含三部分：`<template>`（HTML）、`<script setup>`（JS 逻辑）、`<style scoped>`（CSS，只作用于当前组件）。

## 3. 核心：状态管理 (`useComicLettering.js`)

这是整个应用的大脑。在 Vue 中，可复用的逻辑放在 **composable**（组合式函数）里，文件名以 `use` 开头是约定。

[useComicLettering.js](src/composables/useComicLettering.js) 做的事情：

### a) 响应式状态 — 用 `ref()` 包装数据，数据变了，界面自动更新：

```js
const textBoxes = ref([])      // 所有文本框的数组
const selectedId = ref(null)   // 当前选中的文本框 ID
const scale = ref(1)           // 缩放比例
const imageSrc = ref(null)     // 当前加载的图片
```

`ref()` 是 Vue 的核心机制——它创建一个"响应式箱子"，里面的值变了，所有用到这个值的地方会自动刷新。比如 `textBoxes.value.push(newBox)` 后，画布上就会自动多一个文本框。

### b) 操作方法 — 修改状态的函数：

| 方法 | 作用 |
|------|------|
| `loadImage(file)` | 读取图片文件，显示到画布 |
| `addBox()` | 在画布中央新建文本框 |
| `deleteSelected()` | 删除选中的文本框 |
| `duplicateSelected()` | 复制选中的文本框 |
| `onWorkspaceMouseDown/Move` | 在空白区域拖拽创建新文本框 |
| `onBoxMouseDown` | 拖拽移动文本框 / 拖拽手柄改变大小 |
| `onWheel` | 滚轮缩放 |
| `doExport(canvasEl)` | 导出为 PNG |

### c) 返回值 — 把状态和方法暴露出去，给组件用：

```js
return { textBoxes, selectedId, scale, addBox, deleteSelected, ... }
```

## 4. 组件间如何通信

App.vue 调用 `useComicLettering()` 拿到所有状态和方法，然后通过两种方式分发给子组件：

### 方式一：provide/inject（状态下发）

```js
// App.vue
const composable = useComicLettering()
provide('comic', composable)   // "提供"出去
```

```js
// Workspace.vue
const comic = inject('comic')  // "注入"进来，直接用
```

Workspace 拿到 `comic` 后，可以直接调用 `comic.onWorkspaceMouseDown(e, canvasEl)`，不需要通过 App.vue 中转。

### 方式二：props/emits（父子传值）

对于简单组件如 Toolbar、PropertiesPanel，用传统的 props 传数据，用 emit 传事件：

```html
<!-- App.vue 把 scale 传给 Toolbar，监听 Toolbar 发出的 zoom-in 事件 -->
<Toolbar :scale="scale" @zoom-in="zoomIn" />
```

```
props 是父→子（数据下传）
emit  是子→父（事件上传）
```

## 5. 关键：文本框如何渲染和编辑

### 渲染：[TextBox.vue](src/components/TextBox.vue)

接收一个 `box` 对象作为 prop，用 `computed` 把对象属性转成 CSS 样式：

```js
const innerStyle = computed(() => ({
  fontSize: props.box.fontSize + 'px',   // box.fontSize 变了 → 样式自动更新
  color: props.box.color,
  // ...
}))
```

`computed` 是"计算属性"——依赖的数据变了，它就重新算，模板就自动刷新。

### 编辑：[PropertiesPanel.vue](src/components/PropertiesPanel.vue)

展示选中文本框的属性。用户改字号、改颜色时，通过 `$emit('update', 'fontSize', 24)` 告诉 App.vue，App.vue 直接修改 box 对象：

```js
function onPanelUpdate(prop, value) {
  selectedBox.value[prop] = value  // 直接改，因为 box 是响应式的，画布自动刷新
}
```

## 6. 事件流示意

### 创建文本框

```
用户点击空白区域 → Workspace 捕获 mousedown
  → comic.onWorkspaceMouseDown(e, canvasEl)
  → 创建新 box 加入 textBoxes.value
  → Vue 自动重渲染，Workspace 里出现新 TextBox
  → PropertiesPanel 自动显示新 box 的属性
```

### 移动文本框

```
用户拖拽文本框 → TextBox 发出 mousedown 事件
  → Workspace 调用 comic.onBoxMouseDown(e, box, canvasEl)
  → 持续更新 box.x, box.y
  → Vue 自动更新 TextBox 的位置
```

## 一句话总结

`useComicLettering.js` 管数据和逻辑，`App.vue` 把它分发给各个组件，组件只管展示和捕获用户操作。数据是"响应式"的——改了数据，界面自动更新，不需要手动操作 DOM。
