from pathlib import Path
from reportlab.lib import colors
from reportlab.lib.pagesizes import A4
from reportlab.lib.utils import ImageReader
from reportlab.pdfgen import canvas
import qrcode

ROOT = Path(__file__).resolve().parents[1]
APK_URL = 'https://github.com/enmanuel0112/tarea-6/releases/download/v1.0.0/MultiTool-ITLA.apk'
PHOTO = ROOT / 'assets' / 'images' / 'cesar.png'
OUTPUT = ROOT / 'docs' / 'Entrega-Tarea-6-Cesar-Ogando.pdf'


def main():
    if not APK_URL.startswith('https://'):
        raise ValueError('APK_URL debe ser una URL pública HTTPS real.')
    if not PHOTO.is_file():
        raise FileNotFoundError(PHOTO)
    qr_path = ROOT / 'build' / 'delivery-apk-qr.png'
    qr_path.parent.mkdir(parents=True, exist_ok=True)
    qrcode.make(APK_URL).save(qr_path)
    width, height = A4
    pdf = canvas.Canvas(str(OUTPUT), pagesize=A4)
    navy = colors.HexColor('#202B5B')
    blue = colors.HexColor('#4256B5')
    pale = colors.HexColor('#F1F3FC')
    pdf.setFillColor(pale)
    pdf.roundRect(38, 38, width - 76, height - 76, 22, fill=1, stroke=0)
    pdf.setFillColor(navy)
    pdf.roundRect(38, height - 250, width - 76, 212, 22, fill=1, stroke=0)
    pdf.setFillColor(colors.white)
    pdf.setFont('Helvetica-Bold', 25)
    pdf.drawCentredString(width / 2, height - 100, 'MULTITOOL ITLA')
    pdf.setFont('Helvetica', 14)
    pdf.drawCentredString(width / 2, height - 128, 'Tarea 6 - Desarrollo Móvil')
    pdf.drawImage(ImageReader(str(PHOTO)), width / 2 - 55, height - 390, 110, 110,
                  preserveAspectRatio=True, mask='auto', anchor='c')
    pdf.setFillColor(navy)
    pdf.setFont('Helvetica-Bold', 17)
    pdf.drawCentredString(width / 2, height - 420, 'Cesar Ogando')
    pdf.setFont('Helvetica', 12)
    pdf.drawCentredString(width / 2, height - 442, 'Matrícula: 2024-2485')
    pdf.setFillColor(blue)
    pdf.setFont('Helvetica-Bold', 11)
    pdf.drawCentredString(width / 2, height - 490, 'CÓDIGO FUENTE')
    pdf.setFillColor(navy)
    pdf.setFont('Helvetica', 10)
    pdf.drawCentredString(width / 2, height - 508, 'github.com/enmanuel0112/tarea-6')
    pdf.setFillColor(blue)
    pdf.setFont('Helvetica-Bold', 11)
    pdf.drawCentredString(width / 2, height - 540, 'DESCARGA DEL APK')
    pdf.drawImage(str(qr_path), width / 2 - 60, height - 700, 120, 120,
                  preserveAspectRatio=True, mask='auto')
    pdf.setFillColor(navy)
    pdf.setFont('Helvetica', 11)
    pdf.drawCentredString(width / 2, height - 720, 'Escanear para descargar el APK')
    pdf.setFillColor(colors.HexColor('#657099'))
    pdf.setFont('Helvetica', 8)
    pdf.drawCentredString(width / 2, 55, 'MultiTool ITLA | Entrega académica')
    pdf.save()
    print(OUTPUT)


if __name__ == '__main__':
    main()
