from pathlib import Path
from reportlab.lib import colors
from reportlab.lib.pagesizes import A4
from reportlab.lib.utils import ImageReader
from reportlab.pdfgen import canvas
import qrcode

ROOT = Path(__file__).resolve().parents[1]
APK_URL = 'https://github.com/enmanuel0112/tarea-6/releases/download/v1.0.0/MultiTool-ITLA.apk'
CODE_URL = 'https://github.com/enmanuel0112/tarea-6'
PHOTO = ROOT / 'assets' / 'images' / 'cesar.png'
OUTPUT = ROOT / 'docs' / 'Entrega-Tarea-6-Cesar-Ogando.pdf'


def main():
    if not APK_URL.startswith('https://') or not CODE_URL.startswith('https://'):
        raise ValueError('Los códigos QR requieren URLs públicas HTTPS.')
    if not PHOTO.is_file():
        raise FileNotFoundError(PHOTO)

    qr_dir = ROOT / 'build' / 'delivery-qrs'
    qr_dir.mkdir(parents=True, exist_ok=True)
    apk_qr = qr_dir / 'apk.png'
    code_qr = qr_dir / 'code.png'
    qrcode.make(APK_URL).save(apk_qr)
    qrcode.make(CODE_URL).save(code_qr)

    width, height = A4
    pdf = canvas.Canvas(str(OUTPUT), pagesize=A4)
    navy = colors.HexColor('#123B70')
    blue = colors.HexColor('#526B91')

    # Página 1: portada académica, inspirada en la referencia entregada.
    pdf.setFillColor(navy)
    pdf.setFont('Helvetica-Bold', 20)
    pdf.drawCentredString(width / 2, height - 130,
                          'Instituto Tecnológico de las Américas ITLA')
    pdf.setFillColor(colors.black)
    pdf.setFont('Helvetica', 12)
    cover_lines = [
        ('Asignatura:', 'Introducción al desarrollo de aplicaciones móviles'),
        ('Tema:', 'MultiTool ITLA - Tarea 6'),
        ('Nombre:', 'Cesar Ogando'),
        ('Matrícula:', '2024-2485'),
    ]
    y = height - 195
    for label, value in cover_lines:
        pdf.setFont('Helvetica-Bold', 11)
        label_width = pdf.stringWidth(label + ' ', 'Helvetica-Bold', 11)
        value_width = pdf.stringWidth(value, 'Helvetica', 11)
        x = (width - label_width - value_width) / 2
        pdf.drawString(x, y, label)
        pdf.setFont('Helvetica', 11)
        pdf.drawString(x + label_width, y, value)
        y -= 33
    pdf.setFillColor(blue)
    pdf.setFont('Helvetica-Bold', 16)
    pdf.drawCentredString(width / 2, 185, 'MULTITOOL ITLA')
    pdf.showPage()

    # Página 2: foto y QR, siguiendo la distribución de la segunda página de referencia.
    pdf.setFillColor(blue)
    pdf.setFont('Helvetica-Bold', 11)
    pdf.drawString(62, height - 48, 'Tarea 6 - Desarrollo Móvil | MultiTool ITLA')
    pdf.drawImage(ImageReader(str(PHOTO)), width / 2 - 85, height - 270, 170, 170,
                  preserveAspectRatio=True, mask='auto', anchor='c')
    pdf.setFillColor(colors.black)
    pdf.setFont('Helvetica-Bold', 13)
    pdf.drawCentredString(width / 2, height - 294, 'Cesar Ogando | 2024-2485')

    left_x = 105
    right_x = width - 105 - 130
    qr_y = height - 505
    pdf.setFont('Helvetica', 12)
    pdf.drawCentredString(left_x + 65, qr_y + 145, 'Código fuente')
    pdf.drawCentredString(right_x + 65, qr_y + 145, 'Descargar APK')
    pdf.drawImage(str(code_qr), left_x, qr_y, 130, 130, mask='auto')
    pdf.drawImage(str(apk_qr), right_x, qr_y, 130, 130, mask='auto')

    pdf.setFont('Helvetica-Bold', 11)
    pdf.drawString(70, 120, 'Enlaces:')
    pdf.setFont('Helvetica-Bold', 10)
    pdf.drawString(70, 98, 'Código:')
    pdf.setFillColor(colors.HexColor('#0645AD'))
    pdf.drawString(125, 98, CODE_URL)
    pdf.linkURL(CODE_URL, (125, 95, width - 60, 112), relative=0)
    pdf.setFillColor(colors.black)
    pdf.setFont('Helvetica-Bold', 10)
    pdf.drawString(70, 78, 'APK:')
    pdf.setFillColor(colors.HexColor('#0645AD'))
    pdf.drawString(125, 78, 'Escanear el QR para descargar')
    pdf.linkURL(APK_URL, (125, 75, width - 60, 92), relative=0)
    pdf.setFillColor(colors.black)
    pdf.setFont('Helvetica', 9)
    pdf.drawCentredString(right_x + 65, qr_y - 16, 'Escanear para descargar el APK')
    pdf.showPage()
    pdf.save()
    print(OUTPUT)


if __name__ == '__main__':
    main()
