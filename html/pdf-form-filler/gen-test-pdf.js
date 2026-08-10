/**
 * 生成测试 PDF：覆盖各种表单控件类型，用于测试 pdf-form-filler。
 * 运行：node gen-test-pdf.js
 * 输出：test_form_all_controls.pdf
 * 依赖：同目录下需有 pdf-lib.min.js（可从 CDN 下载：
 *   curl -sL https://cdnjs.cloudflare.com/ajax/libs/pdf-lib/1.17.1/pdf-lib.min.js -o pdf-lib.min.js
 * ）
 */
const PDFLib = require('./pdf-lib.min.js');
const fs = require('fs');

const { PDFDocument, StandardFonts } = PDFLib;

async function main() {
  const doc = await PDFDocument.create();
  const page = doc.addPage([595, 842]); // A4 portrait
  const font = await doc.embedFont(StandardFonts.Helvetica);
  const bold = await doc.embedFont(StandardFonts.HelveticaBold);
  const form = doc.getForm();

  let y = 800;
  const section = (label) => {
    page.drawText(label, { x: 50, y, size: 13, font: bold, color: PDFLib.rgb(0.25, 0.25, 0.25) });
    y -= 26;
  };
  const label = (text) => {
    page.drawText(text, { x: 50, y, size: 11, font, color: PDFLib.rgb(0.1, 0.1, 0.1) });
    y -= 20;
  };

  // 1. Single-line text field
  section('1. Text Field');
  label('Full Name:');
  const name = form.createTextField('Full Name');
  name.setText('John Doe');
  name.addToPage(page, { x: 160, y: y - 14, width: 200, height: 22 });
  y -= 30;

  // 2. Multiline text field
  section('2. Text Area (multiline)');
  label('Comments:');
  const comments = form.createTextField('Comments');
  comments.setText('First line\nSecond line');
  comments.enableMultiline();
  comments.addToPage(page, { x: 160, y: y - 40, width: 280, height: 70 });
  y -= 100;

  // 3. CheckBox
  section('3. CheckBox');
  label('Subscribe:');
  const sub = form.createCheckBox('Subscribe');
  sub.check();
  sub.addToPage(page, { x: 160, y: y - 12, width: 18, height: 18 });
  label('Accept Terms:');
  const terms = form.createCheckBox('Accept Terms');
  terms.addToPage(page, { x: 160, y: y - 12, width: 18, height: 18 });
  y -= 30;

  // 4. Radio Group
  section('4. Radio Group');
  label('Gender:');
  const gender = form.createRadioGroup('Gender');
  gender.addOptionToPage('Male', page, { x: 160, y: y - 12, width: 18, height: 18 });
  gender.addOptionToPage('Female', page, { x: 250, y: y - 12, width: 18, height: 18 });
  gender.addOptionToPage('Other', page, { x: 350, y: y - 12, width: 18, height: 18 });
  page.drawText('Male', { x: 182, y, size: 10, font });
  page.drawText('Female', { x: 272, y, size: 10, font });
  page.drawText('Other', { x: 372, y, size: 10, font });
  y -= 40;

  // 5. Dropdown
  section('5. Dropdown');
  label('Country:');
  const country = form.createDropdown('Country');
  country.addOptions(['USA', 'Canada', 'Mexico', 'China', 'Japan']);
  country.select('China');
  country.addToPage(page, { x: 160, y: y - 14, width: 200, height: 22 });
  y -= 40;

  // 6. OptionList / ListBox (multi-select)
  section('6. OptionList / ListBox');
  label('Interests (multi-select):');
  const interests = form.createOptionList('Interests');
  interests.addOptions(['Reading', 'Music', 'Sports', 'Travel', 'Cooking']);
  interests.select(['Music', 'Travel']);
  interests.addToPage(page, { x: 160, y: y - 55, width: 200, height: 80 });
  y -= 110;

  // Footer
  page.drawText('Test PDF for pdf-form-filler - covers all control types', {
    x: 50, y: 30, size: 9, font, color: PDFLib.rgb(0.5, 0.5, 0.5),
  });

  const bytes = await doc.save();
  fs.writeFileSync('test_form_all_controls.pdf', bytes);
  console.log('written test_form_all_controls.pdf', bytes.length, 'bytes');
}

main().catch((e) => { console.error(e); process.exit(1); });
