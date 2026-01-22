import 'package:flutter/material.dart';
import 'package:idn_pos/utils/currency_format.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrResultModal extends StatefulWidget {
  final String qrData;
  final int total;
  final bool isPrinting;
  final VoidCallback onClose;

  const QrResultModal({super.key, required this.qrData, required this.total, required this.isPrinting, required this.onClose});

  @override
  State<QrResultModal> createState() => _QrResultModalState();
}

class _QrResultModalState extends State<QrResultModal> {
  // variable untuk menyimpan status cetak
  late bool _printFinished;

  @override
  void initState() {
    super.initState();
    // awalnya, anggap proses print belum selesai
    _printFinished = false;

    // jika mode mencetak (printer nyala), kita buat simulasi loading
    if (widget.isPrinting) {
      Future.delayed(Duration(seconds: 2), () {
        // cek jika proses delay sesuai dengan waktu yang dibutuhkan printer ketika mencetak
        if (mounted) {
          setState(() {
            _printFinished = true; //ubah status jadi selesai
          });
        }
      });
    }
 }

  @override
  Widget build(BuildContext context) {
    // tentukan warna dan teks berdasarkan status
    Color statusColor;
    Color statusBgColor;
    IconData statusIcon;
    String statusText;

    if (!widget.isPrinting) {
      // Kondisi 1: printer mati atau mode tanpa printer
      statusColor = Colors.orange;
      statusBgColor = Colors.orange.shade50;
      statusIcon = Icons.print_disabled;
      statusText = "Mode Tanpa Printer";
    } else if(!_printFinished) {
      // Kondisi 2: ketika sedang proses mencetak struk
      statusColor = Colors.blue;
      statusBgColor = Colors.blue.shade50;
      statusIcon = Icons.print;
      statusText = "Mencetak Struk Fisik...";
    } else {
      // Kondisi 3: ketika sudah selesai mencetak struk
      statusColor = Colors.green;
      statusBgColor = Colors.green.shade50;
      statusIcon = Icons.check_circle;
      statusText = "Cetak Selesai";
    }

    return Container(
      // buat ukuran layar si cetak
      height: MediaQuery.of(context).size.height * 0.65,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30))
      ),
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          // untuk handle bar
          Container(
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10)
            ),
          ),
          SizedBox(height: 20),
          // buat status mode lg cetak apa ngga apa ga mode cetak gitu
          AnimatedContainer(
            duration: Duration(milliseconds: 300), // efek animasi halus
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: statusBgColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: statusColor)
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(statusIcon, size: 20, color: statusColor),
                SizedBox(width: 10),
                Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor, 
                    fontWeight: FontWeight.bold
                  ),
                )
              ],
            ),
          ),

          SizedBox(height: 20),
          Text(
            'SCAN UNTUK MEMBAYAR',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color(0xFF2E3192)
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Total: ${formatRupiah(widget.total)}',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(height: 20),

          // QR Code container
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withValues(alpha: 0.1),
                  blurRadius: 15
                )
              ]
            ),
              child: QrImageView(
              data: widget.qrData,
              version: QrVersions.auto,
              size: 220.0,
            ),
          ),

          Spacer(),
          // close button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[200],
                foregroundColor: Colors.black
              ),
              onPressed: widget.onClose,
              child: Text('Tutup'),
            ),
          )
        ],
      ),
    );
  }
}