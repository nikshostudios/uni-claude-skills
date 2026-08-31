---
name: assignment-creator
description: Build a polished, presentation-grade university assignment from a brief/checklist — numbered sections, a dot-leader Table of Contents, a cover page, Mermaid.js diagrams (WBS, Gantt, AON/network, pie, S-curve, risk quadrant) and shaded tables — then render it to a pixel-perfect PDF and a faithful image-per-page Microsoft Word (.docx). Use when the user says "/assignment-creator", "build my assignment", "create an assignment from this brief/checklist", "make my uni assignment with diagrams and a table of contents", "turn this rubric into an assignment", or hands over an assignment brief (PDF/screenshots/text) and wants a presentable graded document.
---

# Assignment Creator

Produce a **university-grade, highly presentable** assignment as two faithful deliverables: a `*.pdf` and a matching `*.docx`. Accuracy, full checklist coverage, and clean layout are the priorities — treat every run as a high-stakes graded submission.

---

## 1. Gather inputs (ask only for what's missing)
Read any attached brief/checklist/rubric/example FIRST. Then confirm:
- Course / module code, assignment title & number.
- Chosen topic or case/project (if the brief says "pick one of N", pick and state which; if a later assignment must reuse an earlier project, keep it identical).
- Constraints: word count (e.g. 1500–2000), similarity ceiling (e.g. < 25%), min references, referencing style (APA/Harvard/IEEE).
- Output folder (default: alongside the brief).
- **Deliverable format — ALWAYS ASK (use AskUserQuestion):** don't assume `.docx`. Offer:
  1. **PDF only** (recommended default — shares perfectly everywhere; pick this unless a Word file is explicitly required).
  2. **PDF + image-per-page DOCX** — Word that looks pixel-identical to the PDF, but text isn't selectable/editable.
  3. **PDF + editable DOCX** — selectable/text-readable Word (native python-docx build); not pixel-identical to the PDF.
  Build only the formats chosen. Honour the choice in §5 and §7.

**Restate the checklist as a section map and confirm topic + ambiguous constraints BEFORE writing.** Every listed brief line is a required, graded item — map one→one, miss nothing.

## 2. Content rules
- Cover every checklist item in depth; explain the *why*, not just the *what*.
- Hit the word count in body prose (exclude tables/captions/refs); print the count on the cover.
- Original prose only — paraphrase + cite, target the similarity ceiling. Never copy sources.
- Real, credible references (standards bodies, textbooks, official policy) in the required style.
- Professional academic tone; define key terms; justify every decision.

## 3. Layout & presentation (non-negotiable)
- **Cover page (i):** course-code badge, title, subtitle, one clean illustrative figure (inline SVG ok), meta block (author/company, key constraints, word count, references, similarity target).
- **Table of Contents (ii):** every section + subsection, **dot leaders**, right-aligned page numbers. Front matter i/ii; body from 1. Verify numbers against the rendered PDF (see §6).
- Numbered sections (1, 1.1, 1.2…), ONE accent color per document, justified body ~1.5 spacing, A4.
- **Tables** for structured data: shaded header row, zebra rows, bordered.
- Figure caption under every diagram ("Figure X.Y — …"). Footer page numbers.

## 4. Diagrams — Mermaid.js (render real SVG, never ASCII)
Pick the right type:
- Flow / hierarchy / **WBS** → `graph TD` (code packages, 3–4 levels).
- **Schedules / Gantt** → `gantt`. Use REAL dates: map week 0 to a Monday, durations `1w/2w/3w`, `dateFormat YYYY-MM-DD`, `axisFormat %d %b`, `tickInterval 1month`. **NEVER** `dateFormat X` + `axisFormat W%L` (renders garbage `W000` axes).
- **AON / network / PERT** → `graph LR`; shade the critical-path nodes (`classDef crit`).
- Distribution → `pie showData`. Trend / **S-curve** → `xychart-beta`. **Risk / 2×2** → `quadrantChart`.
- Escape `&` as `&amp;` inside Mermaid labels in HTML. Color critical items distinctly.

## 5. Build pipeline
Author each document as ONE self-contained **HTML file** (embedded CSS + Mermaid via CDN), then render. Use a `pgbreak` class (`page-break-before:always`) to force the cover and TOC onto their own pages. HTML skeleton:

```html
<!DOCTYPE html><html><head><meta charset="UTF-8">
<script src="https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.min.js"></script>
<style>
 @page{size:A4;margin:18mm 16mm}
 body{font-family:"Segoe UI",Calibri,Arial,sans-serif;font-size:11.2pt;line-height:1.5}
 h1{color:#0b4f6c;border-bottom:2px solid #0b4f6c}h2{color:#11698e}
 table{border-collapse:collapse;width:100%;font-size:10pt}
 th,td{border:1px solid #b9c6cf;padding:5px 7px}th{background:#0b4f6c;color:#fff}
 tr:nth-child(even) td{background:#eef4f7}
 p{text-align:justify}.mermaid,.fig{text-align:center;page-break-inside:avoid}
 .cap{font-size:9pt;color:#555;font-style:italic}.pgbreak{page-break-before:always}
</style></head><body>
 <!-- cover (.cover, page-break-after:always) -->
 <!-- TOC table with dot leaders / right-aligned page numbers -->
 <!-- numbered sections, <pre class="mermaid">…</pre>, tables, figures -->
 <script>mermaid.initialize({startOnLoad:true,theme:"base"});</script>
</body></html>
```

### 5a. HTML → PDF (headless Chromium via Playwright, Node)
Find Playwright: `require('<repo>/node_modules/playwright')` or the user's global `~/node_modules/playwright`. Run via the analysis sandbox (binary output is fine):

```javascript
const { chromium } = require('/Users/<you>/node_modules/playwright');
const dir = "<FOLDER>";
(async()=>{ const b=await chromium.launch(); const p=await b.newPage();
 for(const name of ["assignment2","assignment3"]){
  await p.goto("file://"+dir+"/"+name+".html",{waitUntil:"networkidle",timeout:60000});
  await p.waitForFunction(()=>{const x=document.querySelectorAll('.mermaid');
    return x.length>0 && [...x].every(e=>e.querySelector('svg'));},{timeout:45000});
  await p.waitForTimeout(1500);
  await p.pdf({path:dir+"/"+name+".pdf",format:"A4",printBackground:true,
    margin:{top:"0",bottom:"0",left:"0",right:"0"}});
 } await b.close(); console.log("pdf done"); })();
```
Verify: 0 mermaid `.error-text` nodes, every `.mermaid` has an `<svg>`, expected page count, TOC on page 2 (PyMuPDF `page[1].get_text()` contains "TABLE OF CONTENTS").

### 5b. PDF → faithful Word (image-per-page DOCX, Python) — ONLY if user chose option 2
Skip this entirely for PDF-only. This guarantees the .docx looks **exactly** like the PDF and never reflows. **Do NOT use `pdf2docx`/auto-converters for chart-heavy docs — they detach chart labels and break layout.**

```python
import fitz
from docx import Document
from docx.shared import Inches, Pt
from docx.enum.text import WD_ALIGN_PARAGRAPH
base="<FOLDER>"
for name in ["assignment2","assignment3"]:
    pdf=fitz.open(f"{base}/{name}.pdf"); doc=Document(); s=doc.sections[0]
    s.page_width=Inches(8.27); s.page_height=Inches(11.69)
    s.top_margin=s.bottom_margin=s.left_margin=s.right_margin=Inches(0)
    for i in range(pdf.page_count):
        ip=f"/tmp/{name}_p{i}.png"; pdf[i].get_pixmap(dpi=200).save(ip)
        p=doc.add_paragraph(); p.alignment=WD_ALIGN_PARAGRAPH.CENTER
        p.paragraph_format.space_before=Pt(0); p.paragraph_format.space_after=Pt(0)
        p.add_run().add_picture(ip, width=Inches(8.2))   # 8.2 < 8.27 avoids 1px overflow → blank pages
        if i!=pdf.page_count-1: doc.add_page_break()
    doc.save(f"{base}/{name}.docx"); pdf.close()
```
Deps: `pip install --user pymupdf python-docx pillow`.

### 5c. Editable DOCX (native python-docx) — ONLY if user chose option 3
For selectable/text-readable Word (e.g. text-based similarity check on the .docx), build natively with python-docx: real Heading styles, Word tables, a dot-leader TOC (`tab_stops.add_tab_stop(Inches(6.3), RIGHT, WD_TAB_LEADER.DOTS)`), charts embedded as high-res PNGs (screenshot each `.mermaid svg` at deviceScaleFactor 2). Accept it won't be pixel-identical to the PDF.

## 6. Verify before declaring done
Screenshot key pages (cover, TOC, each diagram) — Playwright element screenshots or macOS `qlmanage -t -s 1400 -o <dir> file.docx` (true Word/QuickLook render). Confirm: charts render, Gantt axis is real dates, TOC page numbers correct, no overflow/blank pages, image-DOCX has N images + 0 text paragraphs.

## 7. Deliver & report
Report the chosen format(s) only: file paths, page count, word count, reference count, and a **coverage table** (every brief item → section → done). Then:
- **Send the PDF** for sharing (identical on WhatsApp/email/phone; attach as **Document**, not photo).
- If an image-DOCX was built: previews poorly in mobile/WhatsApp viewers (it's ~2 MB) — open in **desktop Word**.
- If an editable-DOCX was built: open in desktop Word; mobile previewers may reflow it.
- Optionally produce `<Name>_FINAL.<ext>` copies (only for the formats built) so the user never grabs a stale file.

## Academic integrity (always honor)
Write genuinely original, well-cited work the user can read and explain. **Refuse to engineer AI-detector evasion / "humanizing" to deceive a grader.** Keep similarity low by real paraphrasing + citation. Advise disclosing AI assistance where the institution requires it.
