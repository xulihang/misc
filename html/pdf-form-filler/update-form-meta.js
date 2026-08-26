/**
 * 修改已有 PDF 里表单字段的元数据 —— 演示版。
 *
 * gen-signature-pdf.js 生成的 PDF 里，每个字段的 dict 上挂了两段信息：
 *   - /Meta  一段 JSON 元数据（签名字段带 role/name/userId/email/signedAt 等，
 *             患者 initials 字段带 type/name/userId 等）
 *   - /TU    人类可读的字段描述（阅读器里显示为 tooltip / 字段下方提示）
 *
 * 本 demo 演示如何打开一份已有的 PDF，读取并就地修改这些元数据：
 *   - 把签名字段的 role 按映射改写（patient → guardian、attorney → notary），
 *     并同步换掉签署人姓名/ID，模拟一次“重新指派签署人”；
 *   - 演示如何追加自定义键（给所有带 /Meta 的字段打上 updatedBy 标记）；
 *   - 演示如何删除某个键（出于隐私考虑移除 email）；
 *   - 每次改写后同步更新 /TU 描述，让阅读器里的 tooltip 保持一致。
 *
 * 改完写出一份新 PDF，控制台按字段打印修改前后的 /Meta 与 /TU 对比。
 *
 * 运行：
 *   node update-form-meta.js [input.pdf] [output.pdf]
 *   默认 input=signature_form.pdf，output=signature_form_meta_updated.pdf
 * 依赖：同目录下需有 pdf-lib.min.js（与 gen-signature-pdf.js 一致）
 */
const PDFLib = require('./pdf-lib.min.js');
const fs = require('fs');

const { PDFDocument, PDFName, PDFString, PDFHexString } = PDFLib;

// 读取字段 dict 上的 /Meta（JSON 字符串）。没有 /Meta 或解析失败时返回 null。
function readFieldMeta(field) {
  const value = field.acroField.dict.get(PDFName.of('Meta'));
  if (!value) return null;
  try {
    return JSON.parse(value.decodeText());
  } catch (e) {
    console.warn(`  ⚠ ${field.getName()}: /Meta 不是合法 JSON，跳过 (${e.message})`);
    return null;
  }
}

// 读取字段 dict 上的 /TU（人类可读描述）。可能不存在。
function readFieldTu(field) {
  const value = field.acroField.dict.get(PDFName.of('TU'));
  return value ? value.decodeText() : '(无)';
}

// 往字段 dict 写字符串：纯 ASCII 用字面量 PDFString（与既有文件兼容）；
// 含非 ASCII（中文等）时用 PDFHexString.fromText（UTF-16BE + BOM），否则
// PDFString 会把 charCodeAt >255 的字符截断成乱码（pdf-lib 1.17.1 的已知行为）。
function setDictString(dict, key, value) {
  // 仅对 charCode > 0xFF 的字符（中文等）升级为 UTF-16；拉丁增补（如 · = 0xB7）
  // pdfDocEncoding 可表示，仍用字面量，避免无谓改变既有文件的字节表示。
  if (/[^\x00-\xff]/.test(value)) {
    dict.set(key, PDFHexString.fromText(value));
  } else {
    dict.set(key, PDFString.of(value));
  }
}

// 把 meta 写回字段 dict，并同步更新 /TU 描述。
// type 优先：initials 字段即使 meta 里被加了 role（例如之前用网页版旧逻辑加过，
// 或手动填了 role），也按 type（"patient initials"）命名，不会误标成
// "<role> signature"。只有 meta 里只有 role、没有 type 的签名字段才命名为
// "<role> signature"。规则与 meta-editor.html 一致。
function writeFieldMeta(field, meta) {
  const dict = field.acroField.dict;
  setDictString(dict, PDFName.of('Meta'), JSON.stringify(meta));

  const kind = meta.type
    ? meta.type
    : (meta.role ? `${meta.role} signature` : 'field');
  const label = meta.name ? `${kind} · ${meta.name} (${meta.userId})` : kind;
  setDictString(dict, PDFName.of('TU'), label);
}

// ===== 元数据改写规则（演示用，按需修改这里即可）=====
// 把签名字段的 role 换成新角色，并顺带更换签署人信息，模拟“重新指派签署人”。
const ROLE_AND_SIGNER = {
  patient:  { role: 'guardian', name: 'Diana Prince',  userId: 'G-3001' },
  attorney: { role: 'notary',   name: 'John Hancock',  userId: 'N-4001' },
};

// 对单个字段的 meta 做就地修改。返回修改后的 meta。
function transformMeta(field, meta) {
  // 1) 签名字段：改写 role，并同步更换签署人姓名/ID（Object.assign 只覆盖映射里出现的键，
  //    email、signedAt 等未列出的键会原样保留）。
  const swap = ROLE_AND_SIGNER[meta.role];
  if (swap) Object.assign(meta, swap);

  // 2) 追加自定义键：给所有带 /Meta 的字段打一个“来源”标记。
  meta.updatedBy = 'update-form-meta.js demo';

  // 3) 删除某个键：这里演示把 email 从元数据里移除（真实场景可能是出于隐私要求）。
  delete meta.email;

  return meta;
}

async function main() {
  const inputPath = process.argv[2] || 'signature_form.pdf';
  const outputPath = process.argv[3] || 'signature_form_meta_updated.pdf';

  const doc = await PDFDocument.load(fs.readFileSync(inputPath));
  const form = doc.getForm();
  const fields = form.getFields();

  console.log(`loaded ${inputPath}: ${fields.length} form fields`);
  console.log('');

  let withMeta = 0;
  for (const field of fields) {
    const meta = readFieldMeta(field);
    if (!meta) continue; // 无 /Meta 的普通字段（checkbox/radio/dropdown 等）不改动
    withMeta++;

    const name = field.getName();
    console.log(`◆ ${name}`);
    console.log(`  /Meta before: ${JSON.stringify(meta)}`);
    console.log(`  /TU   before: ${readFieldTu(field)}`);

    transformMeta(field, meta);
    writeFieldMeta(field, meta);

    console.log(`  /Meta after : ${JSON.stringify(meta)}`);
    console.log(`  /TU   after : ${readFieldTu(field)}`);
    console.log('');
  }

  const bytes = await doc.save();
  fs.writeFileSync(outputPath, bytes);

  console.log(`written ${outputPath} (${bytes.length} bytes)`);
  console.log(`fields with /Meta: ${withMeta}（其余 ${fields.length - withMeta} 个字段无 /Meta，保持原样）`);
}

main().catch((e) => { console.error(e); process.exit(1); });
