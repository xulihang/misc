# -*- coding: utf-8 -*-
"""
演示 ArabicReshaper 处理阿拉伯语文本的完整流水线，把每个中间阶段画成图片。

阶段（与 README-ArabicReshaper.md 对应）：
  ① 原始(逻辑序)          直接按 LTR 逐字画，字母是“断开 + 倒序”的（naive 渲染）
  ② 连写（shape 前半）    仅把字母换成 孤立/词首/词中/词尾 呈现形式，未反转
  ③ 反转（= shape() 输出）连写 + 整串倒序，数字也被倒序（如 ٢٠٢٦ → ٦٢٠٢）
  ④ 还原（= Reshape 输出）ReverseNonArabicOnly：英文组还原 LTR、阿拉伯词内数字段
                             倒回、括号镜像，得到正确的视觉 LTR 文本

输出图片到 ./arabic_demo_output/
依赖：Pillow(带 libraqm)。字体自动搜索。
"""
import os
import unicodedata

from PIL import Image, ImageDraw, ImageFont

OUT_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "arabic_demo_output")

# ---------------------------------------------------------------- 字体查找
def find_font(candidates):
    for p in candidates:
        if os.path.exists(p):
            return p
    raise RuntimeError("找不到合适的阿拉伯字体，请修改 find_font() 的候选列表")

AR_FONT_CANDIDATES = [
    r"C:\Windows\Fonts\trado.ttf",          # Traditional Arabic
    r"C:\Windows\Fonts\simpo.ttf",          # Simplified Arabic
    r"C:\Windows\Fonts\segoeui.ttf",
    "/usr/share/fonts/truetype/amiri/Amiri-Regular.ttf",
    "/usr/share/fonts/truetype/noto/NotoNaskhArabic-Regular.ttf",
]
LABEL_FONT_CANDIDATES = [
    r"C:\Windows\Fonts\msyh.ttc",           # Microsoft YaHei (中文标签)
    r"C:\Windows\Fonts\arial.ttf",
    "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf",
]

AR_FONT_PATH = find_font(AR_FONT_CANDIDATES)
LABEL_FONT_PATH = find_font(LABEL_FONT_CANDIDATES)
print("arabic font :", AR_FONT_PATH)
print("label  font :", LABEL_FONT_PATH)

# ---------------------------------------------------------------- 复刻 Java 连字表
# base -> (isolated, final, initial, medial)  —— 与 ArabicShaperFull.java 一致
FORM_CODES = {
    0x0627: (0xFE8D, 0xFE8E, 0xFE8D, 0xFE8E),
    0x0628: (0xFE8F, 0xFE90, 0xFE91, 0xFE92),
    0x062A: (0xFE95, 0xFE96, 0xFE97, 0xFE98),
    0x062B: (0xFE99, 0xFE9A, 0xFE9B, 0xFE9C),
    0x062C: (0xFE9D, 0xFE9E, 0xFE9F, 0xFEA0),
    0x062D: (0xFEA1, 0xFEA2, 0xFEA3, 0xFEA4),
    0x062E: (0xFEA5, 0xFEA6, 0xFEA7, 0xFEA8),
    0x062F: (0xFEA9, 0xFEAA, 0xFEA9, 0xFEAA),
    0x0630: (0xFEAB, 0xFEAC, 0xFEAB, 0xFEAC),
    0x0631: (0xFEAD, 0xFEAE, 0xFEAD, 0xFEAE),
    0x0632: (0xFEAF, 0xFEB0, 0xFEAF, 0xFEB0),
    0x0633: (0xFEB1, 0xFEB2, 0xFEB3, 0xFEB4),
    0x0634: (0xFEB5, 0xFEB6, 0xFEB7, 0xFEB8),
    0x0635: (0xFEB9, 0xFEBA, 0xFEBB, 0xFEBC),
    0x0636: (0xFEBD, 0xFEBE, 0xFEBF, 0xFEC0),
    0x0637: (0xFEC1, 0xFEC2, 0xFEC3, 0xFEC4),
    0x0638: (0xFEC5, 0xFEC6, 0xFEC7, 0xFEC8),
    0x0639: (0xFEC9, 0xFECA, 0xFECB, 0xFECC),
    0x063A: (0xFECD, 0xFECE, 0xFECF, 0xFED0),
    0x0641: (0xFED1, 0xFED2, 0xFED3, 0xFED4),
    0x0642: (0xFED5, 0xFED6, 0xFED7, 0xFED8),
    0x0643: (0xFED9, 0xFEDA, 0xFEDB, 0xFEDC),
    0x0644: (0xFEDD, 0xFEDE, 0xFEDF, 0xFEE0),
    0x0645: (0xFEE1, 0xFEE2, 0xFEE3, 0xFEE4),
    0x0646: (0xFEE5, 0xFEE6, 0xFEE7, 0xFEE8),
    0x0647: (0xFEE9, 0xFEEA, 0xFEEB, 0xFEEC),
    0x0648: (0xFEED, 0xFEEE, 0xFEED, 0xFEEE),
    0x064A: (0xFEF1, 0xFEF2, 0xFEF3, 0xFEF4),
    0x0621: (0xFE80, 0xFE80, 0xFE80, 0xFE80),  # hamza
    0x0629: (0xFE93, 0xFE94, 0xFE93, 0xFE94),  # teh marbuta
    0x0623: (0xFE83, 0xFE84, 0xFE83, 0xFE84),  # alef hamza above
    0x0625: (0xFE87, 0xFE88, 0xFE87, 0xFE88),  # alef hamza below
    0x0622: (0xFE81, 0xFE82, 0xFE81, 0xFE82),  # alef madda
}
FORMS = {chr(k): tuple(chr(v) for v in vals) for k, vals in FORM_CODES.items()}
NON_CONNECTABLE_AFTER = set("ادذرزوأإآة")

# lam-alef 连字：ل(0644) + ا/أ/إ/آ -> 单个连字呈现形式 (isolated, final)
LAM_ALEF_MAP = {
    0x0627: (0xFEFB, 0xFEFC),  # ل + ا
    0x0622: (0xFEF5, 0xFEF6),  # ل + آ
    0x0623: (0xFEF7, 0xFEF8),  # ل + أ
    0x0625: (0xFEF9, 0xFEFA),  # ل + إ
}
LIGATURE_CODES = set().union(*[v for v in LAM_ALEF_MAP.values()])


def _can_connect_after(base):
    return base not in NON_CONNECTABLE_AFTER


def _is_letter(ch):
    """是否算可参与连写的字母（含 lam-alef 连字字形）。"""
    return ch in FORMS or ord(ch) in LIGATURE_CODES


def _nb(chars, i, step):
    """从 i 出发沿 step 方向找最近一个『非组合变音符』字符下标（找不到返回越界）。"""
    j = i + step
    while 0 <= j < len(chars) and unicodedata.combining(chars[j]) != 0:
        j += step
    return j


def _ligate_lamalef(chars):
    """把逻辑序相邻的 ل+ا/أ/إ/آ 合并为单个 lam-alef 连字字形。

    连字本身只分两种形态：
      - isolated FEFB/FEF5/FEF7/FEF9：lam 左侧无连接（词首或前面是不连字母）
      - final    FEFC/FEF6/FEF8/FEFA：lam 左侧连到前一个字母
    """
    out = []
    i = 0
    while i < len(chars):
        c = chars[i]
        if (c == "ل" and i + 1 < len(chars)
                and ord(chars[i + 1]) in LAM_ALEF_MAP):
            lig = LAM_ALEF_MAP[ord(chars[i + 1])]
            prev = chars[i - 1] if i > 0 else None
            connected_left = (prev is not None and _is_letter(prev)
                              and _can_connect_after(prev))
            out.append(chr(lig[1] if connected_left else lig[0]))
            i += 2
        else:
            out.append(c)
            i += 1
    return out


def shape_letters(text, use_lamalef=True):
    """shape() 前半：按逻辑顺序把字母换成呈现形式（不反转）。
    use_lamalef=True 时额外合并 lam-alef 连字（ل+ا/أ/إ/آ）。"""
    chars = list(text)
    if use_lamalef:
        chars = _ligate_lamalef(chars)
    out = []
    for i, c in enumerate(chars):
        forms = FORMS.get(c)
        if forms is None:
            out.append(c)          # lam-alef 连字等已成型字形原样透传
            continue
        # 找有效邻居时跳过中间的组合变音符（如 بِسْم 的 ِ），避免断连
        p = _nb(chars, i, -1)
        q = _nb(chars, i, +1)
        connect_prev = p >= 0 and _can_connect_after(chars[p]) and _is_letter(chars[p])
        connect_next = q < len(chars) and _can_connect_after(c) and _is_letter(chars[q])
        if connect_prev and connect_next:
            out.append(forms[3])   # medial
        elif connect_prev:
            out.append(forms[1])   # final
        elif connect_next:
            out.append(forms[2])   # initial
        else:
            out.append(forms[0])   # isolated
    return "".join(out)


def shape_full(text, use_lamalef=True):
    """= pdfbox.ArabicShaperFull.shape：连写 + 整串倒序（数字被误倒）。"""
    return shape_letters(text, use_lamalef=use_lamalef)[::-1]


# ---------------------------------------------------------------- B4J 还原逻辑
def is_digit(c):
    return c.isdigit()  # ASCII 0-9 与 阿拉伯-印度数字 ٠-٩


def is_arabic_char(c):
    code = ord(c)
    if (0x0600 <= code <= 0x06FF) or (0xFE70 <= code <= 0xFEFF):
        return not (0x0660 <= code <= 0x0669)
    return False


def is_arabic_word(word, ignore_digits=True):
    if not word:
        return False
    arabic = other = 0
    for ch in word:
        if is_digit(ch):
            if ignore_digits:
                continue
            arabic += (0x0660 <= ord(ch) <= 0x0669)   # Arabic-Indic 视作阿
            other += not (0x0660 <= ord(ch) <= 0x0669)
            continue
        if is_arabic_char(ch):
            arabic += 1
        else:
            other += 1
    return arabic > other


def reverse_digit_runs(s):
    """把字符串中每段连续数字再倒序一次。"""
    out, i = [], 0
    while i < len(s):
        if is_digit(s[i]):
            j = i
            while j < len(s) and is_digit(s[j]):
                j += 1
            out.append(s[i:j][::-1])
            i = j
        else:
            out.append(s[i])
            i += 1
    return "".join(out)


MIRROR = str.maketrans("()[]{}<>", ")(][}{><")


def reverse_non_arabic_only(text):
    """对 shape() 输出做还原：阿拉伯词保持，英文组还原，词内数字段倒回，括号镜像。"""
    words = text.split(" ")
    sb = []
    english_group = []
    for i, word in enumerate(words):
        if is_arabic_word(word, True):
            if english_group:
                sb.append(reverse_english_group(english_group))
                english_group = []
                sb.append(" ")
            sb.append(reverse_digit_runs(word))
            if i < len(words) - 1:
                sb.append(" ")
        else:
            english_group.append(word)
    if english_group:
        sb.append(reverse_english_group(english_group))
    return "".join(sb).translate(MIRROR)


def reverse_english_group(words):
    return " ".join(w[::-1] for w in reversed(words))


def reverse_keeping_digits(s):
    """OCR 视觉序→逻辑序：整串反转但保持数字段顺序（RapidOCR 路径用）。"""
    return reverse_digit_runs(s[::-1])


# ---------------------------------------------------------------- 字形绘制（模拟 PDFBox LTR 逐字画）
def _is_combining(ch):
    return unicodedata.combining(ch) != 0


def layout_ltr(font, text):
    """返回每字符的绘制 x 偏移与总宽（combining 标号不占位）。"""
    xs, x = [], 0
    for ch in text:
        xs.append(x)
        if not _is_combining(ch):
            x += font.getlength(ch)
    return xs, x


def render_row(draw, x0, y_asc, font, text, highlight_digits=True):
    """在 ascender 线 y_asc 处以 anchor='la' 画一串；返回占用的宽。"""
    asc, desc = font.getmetrics()
    xs, total = layout_ltr(font, text)
    # 先画数字高亮（浅橙底）
    if highlight_digits:
        for idx, ch in enumerate(text):
            if is_digit(ch):
                w = font.getlength(ch)
                draw.rectangle([x0 + xs[idx], y_asc + asc - font.size * 0.15,
                                x0 + xs[idx] + w, y_asc + asc + font.size * 0.15],
                               fill=(255, 220, 120, 90))
    for idx, ch in enumerate(text):
        draw.text((x0 + xs[idx], y_asc), ch, font=font, fill=(0, 0, 0, 255), anchor="la")
    return total


# ---------------------------------------------------------------- 输出
def draw_sample(name, title, rows, ref=None):
    """rows: list of (阶段说明, 文本)。ref: 供 raqm 正确渲染的原始逻辑文本。"""
    os.makedirs(OUT_DIR, exist_ok=True)
    fsize = 46
    afont = ImageFont.truetype(AR_FONT_PATH, fsize)
    asc, desc = afont.getmetrics()
    slot = asc + desc
    lfont = ImageFont.truetype(LABEL_FONT_PATH, 22)

    margin, label_w = 24, 330
    col_gap = 28
    n = len(rows) + (1 if ref else 0)
    title_h = 52
    # 测量最宽一行
    text_w = 0
    for _, t in rows:
        _, w = layout_ltr(afont, t)
        text_w = max(text_w, w)
    if ref:
        _, w = layout_ltr(afont, ref)
        text_w = max(text_w, w)
    W = margin * 2 + label_w + col_gap + int(text_w) + 30
    H = title_h + margin * 2 + n * (slot + 22)

    img = Image.new("RGBA", (W, H), (255, 255, 255, 255))
    draw = ImageDraw.Draw(img)
    draw.text((margin, 14), title, font=lfont, fill=(20, 20, 20, 255))

    y = title_h + margin
    cur = 0
    if ref is not None:
        draw.text((margin, y + 8), "参考 · raqm(RTL) 正确渲染原始逻辑文本", font=lfont,
                  fill=(80, 80, 200, 255))
        # raqm RTL 正确整形渲染（作为正确参照）
        draw.text((margin + label_w + col_gap, y + asc),
                  ref, font=afont, fill=(40, 60, 160, 255),
                  direction="rtl", language="ar")
        y += slot + 22
        cur = 1
    for label, text in rows:
        color = (0, 0, 0, 255)
        draw.text((margin, y + 8), label, font=lfont, fill=color)
        render_row(draw, margin + label_w + col_gap, y + asc, afont, text)
        y += slot + 22
        cur += 1
    img.convert("RGB").save(os.path.join(OUT_DIR, name))
    print("saved:", name)


# ---------------------------------------------------------------- 样本
SAMPLES = [
    ("阿拉伯-印度数字 + 变音符（报告场景）", "التقريرُ السنويُّ للعامٍ ٢٠٢٦م"),
    ("混排英文与数字", "السلام عليكم ورحمة الله ABC 2026 وبركاته"),
    ("多种数字", "النسخة ٢٠٢٦ في عام 2026"),
    ("全标音文本（连写跳过变音符）", "بِسْمِ اللهِ الرَّحْمَنِ الرَّحِيمِ"),
]


def stages_of(text, use_lamalef=True):
    s0 = text                                   # 原始(逻辑序)
    s1 = shape_letters(text, use_lamalef)       # 连写（未反转）
    s2 = shape_full(text, use_lamalef)          # 连写+整串反转
    s3 = reverse_non_arabic_only(s2)            # 还原英文/数字 + 括号镜像
    return s0, s1, s2, s3


for si, (title, text) in enumerate(SAMPLES):
    s0, s1, s2, s3 = stages_of(text)
    print("=" * 78)
    print("样本", si, "：", title)
    print(" ①原始        :", s0)
    print(" ②连写(未反转) :", s1)
    print(" ③连写+反转    :", s2, "  <-- shape() 输出")
    print(" ④还原后(=输出) :", s3, "  <-- Reshape 输出")
    rows = [
        ("① 原始 · 逻辑序（LTR 逐字画，断开且字母倒）", s0),
        ("② 连写 · shape 前半（字母→连写形式，未反转）", s1),
        ("③ 反转 · = shape() 输出（数字被倒序 ⚠）", s2),
        ("④ 还原英文/数字段 + 括号镜像 · = Reshape 输出", s3),
    ]
    draw_sample(f"sample_{si}_stages.png", title, rows, ref=text)

# OCR 视觉序→逻辑序（ReverseKeepingDigits）单独展示
ocr_in = "م٢٠٢٦"
ocr_out = reverse_keeping_digits(ocr_in)
print("=" * 78)
print("OCR 演示：PP-OCR 视觉序输出 → 逻辑序")
print("  OCR 输出(视觉序):", ocr_in)
print("  转回逻辑序       :", ocr_out)
draw_sample(
    "sample_ocr_visual_to_logical.png",
    "OCR 视觉序 → 逻辑序（ReverseKeepingDigits）",
    [
        ("OCR 识别(视觉序，字母已倒、数字顺序正确)", ocr_in),
        ("ReverseKeepingDigits 转回逻辑序（数字不动）", ocr_out),
    ],
)

# ---------------------------------------------------------------- lam-alef 效果对照
LA_TEXT = "لا إله إلا الله"


def canvas_for(text, font, raqm):
    """把一段文字渲染成紧裁切的灰度图，供相似度对比。
    raqm=True 走 harfbuzz(RTL) 正确整形；否则走本演示的 LTR 逐字画法。"""
    asc, desc = font.getmetrics()
    H = asc + desc + 8
    probe = Image.new("L", (20, 20))
    pd = ImageDraw.Draw(probe)
    if raqm:
        W = int(pd.textlength(text, font=font, direction="rtl", language="ar")) + 20
    else:
        _, tw = layout_ltr(font, text)
        W = int(tw) + 20
    img = Image.new("L", (max(W, 10), H), 255)
    d = ImageDraw.Draw(img)
    y0 = asc  # anchor='la'：y 在 ascender 线
    if raqm:
        d.text((10, y0), text, font=font, fill=0, direction="rtl", language="ar")
    else:
        xs, _ = layout_ltr(font, text)
        for idx, ch in enumerate(text):
            d.text((10 + xs[idx], y0), ch, font=font, fill=0, anchor="la")
    return img.crop(img.getbbox())


def similarity(a, b):
    """两图暗像素(墨迹)的交并比 Jaccard，越高越像。"""
    w = max(a.width, b.width)
    h = max(a.height, b.height)
    aa = a.resize((w, h)).point(lambda p: 0 if p < 128 else 1)
    bb = b.resize((w, h)).point(lambda p: 0 if p < 128 else 1)
    pa, pb = aa.load(), bb.load()
    inter = union = 0
    for yy in range(h):
        for xx in range(w):
            x = pa[xx, yy]
            y = pb[xx, yy]
            if x == 0 or y == 0:
                union += 1
                if x == 0 and y == 0:
                    inter += 1
    return inter / union if union else 1.0


# 组装三行对照图
f46 = ImageFont.truetype(AR_FONT_PATH, 46)
l24 = ImageFont.truetype(LABEL_FONT_PATH, 24)
ascF, descF = f46.getmetrics()
Hrow = ascF + descF + 20
label_w2 = 300
ref_w = int(ImageDraw.Draw(Image.new("L", (8, 8))).textlength(
    LA_TEXT, font=f46, direction="rtl", language="ar"))
_, without_w = layout_ltr(f46, reverse_non_arabic_only(shape_full(LA_TEXT, use_lamalef=False)))
_, with_w = layout_ltr(f46, reverse_non_arabic_only(shape_full(LA_TEXT, use_lamalef=True)))
W2 = 40 + label_w2 + 24 + int(max(ref_w, without_w, with_w)) + 40
H2 = 20 + 3 * Hrow + 40
img2 = Image.new("RGB", (W2, H2), (255, 255, 255))
d2 = ImageDraw.Draw(img2)

ref_img = canvas_for(LA_TEXT, f46, raqm=True)
no_img = canvas_for(reverse_non_arabic_only(shape_full(LA_TEXT, use_lamalef=False)), f46, raqm=False)
yes_img = canvas_for(reverse_non_arabic_only(shape_full(LA_TEXT, use_lamalef=True)), f46, raqm=False)
print("=" * 78)
print("lam-alef 对照文本：", LA_TEXT)
print("  参考(harfbuzz) 与 无lam-alef 相似度:", round(similarity(ref_img, no_img), 3))
print("  参考(harfbuzz) 与 有lam-alef 相似度:", round(similarity(ref_img, yes_img), 3))

rows_la = [
    ("参考 · raqm(RTL) 正确渲染", ref_img),
    ("当前流水线（未做 lam-alef）", no_img),
    ("补 lam-alef 后（ل+ا → ﻼ/ﻻ）", yes_img),
]
y = 20
for label, im in rows_la:
    d2.text((24, y + 8), label, font=l24, fill=(40, 40, 40))
    img2.paste(im, (40 + label_w2 + 24, y + 4))
    y += Hrow
img2.save(os.path.join(OUT_DIR, "sample_lamalef_compare.png"))
print("saved: sample_lamalef_compare.png")

# ------------------------------------------------- 全标音断连修复对照
VOW = "بِسْمِ اللهِ الرَّحْمَنِ الرَّحِيمِ"
vref = canvas_for(VOW, f46, raqm=True)
vfin = canvas_for(reverse_non_arabic_only(shape_full(VOW)), f46, raqm=False)
print("=" * 78)
print("全标音对照文本：", VOW)
print("  参考(harfbuzz) 与 修复后 final 墨迹重叠:", round(similarity(vref, vfin), 3))

vrows = [("参考 · raqm(RTL) 正确渲染", vref),
         ("最终（连写跳过变音符后）", vfin)]
Hv = 20 + len(vrows) * Hrow + 30
imgv = Image.new("RGB", (W2, Hv), (255, 255, 255))
dv = ImageDraw.Draw(imgv)
yv = 20
for label, im in vrows:
    dv.text((24, yv + 8), label, font=l24, fill=(40, 40, 40))
    imgv.paste(im, (40 + label_w2 + 24, yv + 4))
    yv += Hrow
imgv.save(os.path.join(OUT_DIR, "sample_vowel_compare.png"))
print("saved: sample_vowel_compare.png")
print("done. 图片输出目录:", os.path.abspath(OUT_DIR))
