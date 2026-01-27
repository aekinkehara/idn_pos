import 'package:flutter/material.dart';
import 'package:idn_pos/utils/currency_format.dart';

class PaymentModal extends StatelessWidget {
  final String id;
  final int total;
  final VoidCallback onPay;
  final VoidCallback onCancel;

  const PaymentModal({super.key, required this.id, required this.total, required this.onPay, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30))
      ),
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10)
            ),
          ),
          SizedBox(height: 20),

          // checklist icon
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(color: Colors.green[50], shape: BoxShape.circle),
            child: Icon(
              Icons.verified_rounded,
              size: 50,
              color: Colors.green,
            ),
          ),
          SizedBox(height: 15),

          // detail tagihan
          Text(
            "Tagihan Ditemukan!",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E3192)
            ),
          ),
          SizedBox(height: 5),
          Text(
            "ID: $id",
            style: TextStyle(color: Colors.grey),
          ),
          Divider(height: 30),

          // detail harga
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total Tagihan", style: TextStyle(fontSize: 16)),
              Text("Status", style: TextStyle(fontSize: 16, color: Colors.grey))
            ],
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formatRupiah(total),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: Colors.orange.shade100,borderRadius: BorderRadius.circular(5)),
                child: Text(
                  "UNPAID",
                  style: TextStyle(
                    color: Colors.deepOrange,
                    fontWeight: FontWeight.bold,
                    fontSize: 12
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 30),

          // button bayar sekarang
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
              ),
              onPressed: onPay,
              child: Ink(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0xFF11998e), Color(0xFF38ef7d)]),
                  borderRadius: BorderRadius.circular(15)
                ),
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    "BAYAR SEKARANG",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          TextButton(
            onPressed: onCancel,
            child: Text(
              "Batalkan",
              style: TextStyle(color: Colors.grey),
            ),
          )

        ],
      ),
    );
  }
}