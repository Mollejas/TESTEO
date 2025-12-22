#!/usr/bin/env python3
import sys
import fitz  # PyMuPDF
import os
import shutil
from PIL import Image, ImageOps, ImageEnhance
import pytesseract

# Ruta de instalación de tesseract
pytesseract.pytesseract.tesseract_cmd = r'C:\Program Files\Tesseract-OCR\tesseract.exe'

def preprocess_image(image):
    gray = image.convert('L')  # escala de grises
    bw = gray.point(lambda x: 0 if x < 160 else 255, '1')  # binarización
    contrast = ImageEnhance.Contrast(bw).enhance(2.0)  # mejora contraste
    return contrast

def extract_x_checkboxes(pdf_path, out_dir):
    if not os.path.isfile(pdf_path):
        print(f"PDF no encontrado: {pdf_path}", file=sys.stderr)
        sys.exit(1)

    temp_img_dir = os.path.join(out_dir, "temp_imgs")
    if os.path.exists(temp_img_dir):
        shutil.rmtree(temp_img_dir)
    os.makedirs(temp_img_dir, exist_ok=True)

    doc = fitz.open(pdf_path)
    zoom = 4.0  # mayor resolución
    mat = fitz.Matrix(zoom, zoom)

    checkbox_labels = [
        "Daños del asegurado",
        "O tercero",
        "Robo",
        "Propiedad de la compañía"
    ]

    checkbox_coords = [
        (370, 870, 410, 910),
        (480, 870, 520, 910),
        (590, 870, 630, 910),
        (700, 870, 740, 910)
    ]

    page = doc.load_page(0)
    pix = page.get_pixmap(matrix=mat, alpha=False)
    page_img_path = os.path.join(temp_img_dir, "page1.png")
    pix.save(page_img_path)
    img = Image.open(page_img_path)

    for idx, coords in enumerate(checkbox_coords):
        cropped_img = img.crop(coords)
        processed = preprocess_image(cropped_img)

        img_path = os.path.join(temp_img_dir, f"checkbox_{idx+1}.png")
        processed.save(img_path)

        ocr_result = pytesseract.image_to_string(processed, config='--psm 10').strip()
        print(f"{checkbox_labels[idx]} OCR: [{ocr_result}]")

        marcado = 'X' in ocr_result.upper() or '✓' in ocr_result or '✔' in ocr_result
        print(f"{checkbox_labels[idx]}: {'CHECK' if marcado else 'UNCHECKED'}")

    # shutil.rmtree(temp_img_dir)

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Uso: extract_images.py <ruta_pdf> <carpeta_salida>", file=sys.stderr)
        sys.exit(1)

    pdf_path = sys.argv[1]
    out_dir = sys.argv[2]

    extract_x_checkboxes(pdf_path, out_dir)
