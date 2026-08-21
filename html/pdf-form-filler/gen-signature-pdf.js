/**
 * 生成一个两页 PDF，用于测试 pdf-form-filler 的签名场景。
 *
 * 特点：
 *  - 每页有两个签名区域（普通的 acroform TextField，不是专门的签名类型）：
 *      - Patient Signature   （患者签名）
 *      - Attorney Signature  （律师签名）
 *  - 每个签名 TextField 都通过字段字典里的自定义键 /Meta 挂载一段 JSON 元数据
 *    （签名者姓名、角色、userId、email、签名时间等），不同用户的签名元数据不同。
 *  - 每页会随机生成一些 checkbox / radio / dropdown / multiline 等其它表单控件。
 *  - 最后一页的签名区域额外带一个 "Date of signature" 的 TextField。
 *
 * 运行：node gen-signature-pdf.js [seed]
 * 输出：signature_form.pdf
 * 依赖：同目录下需有 pdf-lib.min.js（与 gen-test-pdf.js 一致）
 */
const PDFLib = require('./pdf-lib.min.js');
const fs = require('fs');

const { PDFDocument, StandardFonts } = PDFLib;

// 可复现的伪随机数生成器（mulberry32）。传入 seed 即可固定随机内容。
function mulberry32(a) {
  return function () {
    let t = (a += 0x6d2b79f5);
    t = Math.imul(t ^ (t >>> 15), t | 1);
    t ^= t + Math.imul(t ^ (t >>> 7), t | 61);
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  };
}

// 各页签名对应的用户元数据。每页一个患者 + 一个律师，元数据各不相同。
const SIGNERS_PER_PAGE = [
  {
    patient:   { userId: 'P-1001', name: 'Alice Johnson', email: 'alice.johnson@example.com' },
    attorney:  { userId: 'A-2001', name: 'Bob Smith',     email: 'bob.smith@lawfirm.example.com' },
  },
  {
    patient:   { userId: 'P-1002', name: 'Carol Lee',     email: 'carol.lee@example.com' },
    attorney:  { userId: 'A-2002', name: 'David Chen',    email: 'david.chen@lawfirm.example.com' },
  },
];

// 随机控件池。每页从中随机抽取几个（带页号后缀保证字段名全局唯一）。
const CONTROL_POOL = [
  { kind: 'checkbox',  label: 'Insurance Accepted' },
  { kind: 'checkbox',  label: 'HIPAA Consent' },
  { kind: 'checkbox',  label: 'Treatment Consent' },
  { kind: 'radio',     label: 'Gender',          options: ['Male', 'Female', 'Other'] },
  { kind: 'radio',     label: 'Payment Method',  options: ['Credit Card', 'Cash', 'Insurance'] },
  { kind: 'dropdown',  label: 'State',           options: ['CA', 'NY', 'TX', 'WA', 'IL'] },
  { kind: 'dropdown',  label: 'Preferred Contact', options: ['Email', 'Phone', 'Mail'] },
  { kind: 'multiline', label: 'Reason for Visit' },
  { kind: 'listbox',   label: 'Symptoms',        options: ['Fever', 'Cough', 'Headache', 'Fatigue', 'Nausea'] },
  { kind: 'text',      label: 'Phone Number' },
  { kind: 'text',      label: 'Insurance ID' },
];

// 生成一段带时间戳的签名元数据（同一签名者的两次签名字段 ID 也不同）。
function buildSignatureMeta(role, signer, signatureId, seed) {
  return {
    signatureId,          // 本次签名字段唯一 ID
    role,                 // 'patient' | 'attorney'
    userId: signer.userId,
    name: signer.name,
    email: signer.email,
    signedAt: '2026-08-21T10:30:00Z', // 示例时间；真实场景由签名时生成
    docSeed: seed,        // 生成 PDF 的 seed，方便溯源
  };
}

// 把元数据挂到 acroform 字段的字典上：/Meta 放 JSON，/TU 放人类可读描述。
function attachMetadata(textField, meta) {
  textField.acroField.dict.set(
    PDFLib.PDFName.of('Meta'),
    PDFLib.PDFString.of(JSON.stringify(meta))
  );
  textField.acroField.dict.set(
    PDFLib.PDFName.of('TU'),
    PDFLib.PDFString.of(`${meta.role} signature · ${meta.name} (${meta.userId})`)
  );
}

// 字段名带页号后缀，保证整个表单里不重名。
function fieldName(base, pageIndex) {
  return pageIndex === 0 ? base : `${base} ${pageIndex + 1}`;
}

// 在一个页面上绘制标题和随机控件，返回用掉的底部 y 位置。
function addRandomControls(page, form, font, rand, pageIndex) {
  const controls = CONTROL_POOL
    .map((c) => ({ c, r: rand() }))
    .sort((a, b) => a.r - b.r)        // 洗牌
    .slice(0, 3 + Math.floor(rand() * 4)); // 每页随机 3~6 个

  let y = 690;
  const label = (text) => {
    page.drawText(text, { x: 50, y, size: 11, font, color: PDFLib.rgb(0.1, 0.1, 0.1) });
  };

  for (const { c } of controls) {
    const name = fieldName(c.label, pageIndex);
    const x = 50, fw = 200;

    if (c.kind === 'checkbox') {
      label(c.label + ':');
      const cb = form.createCheckBox(name);
      if (rand() < 0.3) cb.check();
      cb.addToPage(page, { x: x + 120, y: y - 12, width: 16, height: 16 });
      y -= 34;
    } else if (c.kind === 'radio') {
      label(c.label + ':');
      const rg = form.createRadioGroup(name);
      let ox = x + 120;
      for (const opt of c.options) {
        rg.addOptionToPage(opt, page, { x: ox, y: y - 12, width: 16, height: 16 });
        page.drawText(opt, { x: ox + 18, y: y - 14, size: 9, font });
        ox += 70;
      }
      rg.select(c.options[0]); // 默认选中第一项，便于查看
      y -= 34;
    } else if (c.kind === 'dropdown') {
      label(c.label + ':');
      const dd = form.createDropdown(name);
      dd.addOptions(c.options);
      dd.select(c.options[1 % c.options.length]);
      dd.addToPage(page, { x: x + 120, y: y - 14, width: fw, height: 22 });
      y -= 36;
    } else if (c.kind === 'multiline') {
      label(c.label + ':');
      const ml = form.createTextField(name);
      ml.enableMultiline();
      ml.addToPage(page, { x: x + 120, y: y - 36, width: 220, height: 56 });
      y -= 64;
    } else if (c.kind === 'listbox') {
      label(c.label + ':');
      const lb = form.createOptionList(name);
      lb.addOptions(c.options);
      lb.select(c.options.slice(0, 2));
      lb.addToPage(page, { x: x + 120, y: y - 40, width: 200, height: 64 });
      y -= 72;
    } else {
      // text
      label(c.label + ':');
      const tf = form.createTextField(name);
      tf.addToPage(page, { x: x + 120, y: y - 14, width: fw, height: 22 });
      y -= 36;
    }
  }
  return y;
}

// 绘制一段同意声明，段内嵌一个行内 TextField 用于填 patient initials。
function addInitialsParagraph(page, form, font, pageIndex, seed) {
  const signer = SIGNERS_PER_PAGE[pageIndex].patient;
  const size = 10, x = 50, color = PDFLib.rgb(0.15, 0.15, 0.15);

  const line1 = 'I, the undersigned patient, acknowledge that I have received and understood';
  const line2 = 'the information provided above, and that I consent to the proposed';
  const line3a = 'course of treatment.  Patient initials: ';

  let y = 215;
  page.drawText(line1, { x, y, size, font, color }); y -= 14;
  page.drawText(line2, { x, y, size, font, color }); y -= 14;

  // 行内 textfield：紧跟 "Patient initials: " 之后，元数据标识为 patient initials
  const tf = form.createTextField(fieldName('Patient Initials', pageIndex));
  const fx = x + font.widthOfTextAtSize(line3a, size) + 4;
  tf.addToPage(page, { x: fx, y: y - 3, width: 120, height: 16 });
  attachMetadata(tf, {
    type: 'patient initials',
    userId: signer.userId,
    name: signer.name,
    email: signer.email,
    docSeed: seed,
  });

  page.drawText(line3a, { x, y, size, font, color });
}

// 绘制一页的两个签名区域。
function addSignatureArea(doc, page, form, font, bold, pageIndex, isLastPage, seed) {
  const x1 = 50, x2 = 310, w = 235, h = 60, top = 150;

  page.drawText('SIGNATURES', { x: 50, y: top + 22, size: 13, font: bold, color: PDFLib.rgb(0.25, 0.25, 0.25) });

  const place = (x, baseName, role, signer) => {
    const name = fieldName(baseName, pageIndex);
    const meta = buildSignatureMeta(role, signer, `${role}-${pageIndex + 1}-${signer.userId}`, seed);
    const tf = form.createTextField(name); // 默认不填任何文字
    tf.addToPage(page, { x, y: top - h, width: w, height: h });
    attachMetadata(tf, meta);

    page.drawText(`${baseName} — ${signer.name} (${signer.userId})`, { x, y: top + 6, size: 9, font, color: PDFLib.rgb(0.4, 0.4, 0.4) });
    return tf;
  };

  place(x1, 'Patient Signature', 'patient', SIGNERS_PER_PAGE[pageIndex].patient);
  place(x2, 'Attorney Signature', 'attorney', SIGNERS_PER_PAGE[pageIndex].attorney);

  // 最后一页的签名位置额外加一个 "Date of signature" 文本框。
  if (isLastPage) {
    page.drawText('Date of signature:', { x: x2, y: top - h - 26, size: 11, font });
    const date = form.createTextField('Date of signature');
    date.setText('YYYY-MM-DD');
    date.addToPage(page, { x: x2 + 130, y: top - h - 40, width: w - 130, height: 22 });
  }

  page.drawText(`Page ${pageIndex + 1}`, { x: 540, y: 30, size: 9, font, color: PDFLib.rgb(0.5, 0.5, 0.5) });
}

async function main() {
  const seed = parseInt(process.argv[2] || '42', 10);
  const rand = mulberry32(seed);
  const pageCount = 2;

  const doc = await PDFDocument.create();
  const font = await doc.embedFont(StandardFonts.Helvetica);
  const bold = await doc.embedFont(StandardFonts.HelveticaBold);
  const form = doc.getForm();

  for (let i = 0; i < pageCount; i++) {
    const page = doc.addPage([595, 842]); // A4 纵向
    page.drawText('Consent & Authorization Form', { x: 50, y: 800, size: 16, font: bold, color: PDFLib.rgb(0.1, 0.1, 0.1) });
    page.drawText(`generated by gen-signature-pdf.js · seed ${seed}`, { x: 50, y: 782, size: 9, font, color: PDFLib.rgb(0.5, 0.5, 0.5) });

    const usedY = addRandomControls(page, form, font, rand, i);
    if (usedY < 200) console.warn(`page ${i + 1}: random controls reached y=${usedY}, close to signature area`);

    addInitialsParagraph(page, form, font, i, seed);
    addSignatureArea(doc, page, form, font, bold, i, i === pageCount - 1, seed);
  }

  const bytes = await doc.save();
  fs.writeFileSync('signature_form.pdf', bytes);

  // 控制台摘要：列出所有字段 + 签名字段的元数据
  console.log(`written signature_form.pdf (${bytes.length} bytes), seed=${seed}`);
  const fields = form.getFields();
  console.log(`total fields: ${fields.length}`);
  for (const f of fields) {
    if (f instanceof PDFLib.PDFTextField && (f.getName().includes('Signature') || f.getName().includes('Initials'))) {
      const metaJson = f.acroField.dict.get(PDFLib.PDFName.of('Meta'));
      console.log(`  - ${f.getName()}  Meta=${metaJson}`);
    }
  }
}

main().catch((e) => { console.error(e); process.exit(1); });
