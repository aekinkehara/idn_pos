import 'package:flutter/material.dart';
import 'package:idn_pos/utils/currency_format.dart';

class CheckoutPanel extends StatelessWidget {
  final int total;
  final VoidCallback onPressed;

  const CheckoutPanel({super.key, required this.total, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [BoxShadow(
          color: Colors.black12,
          blurRadius: 20,
          offset: Offset(0, -5)
        )]
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total Tagihan",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey
                ),
              ),
              Text(
                formatRupiah(total),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E3192)
                ),
              )
            ],
          ),
          SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
              ),
              onPressed: onPressed,
              child: Ink( //ink buat dekorasi
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0xFF2E3192), Color(0xFF1BFFFF)]),
                  borderRadius: BorderRadius.circular(15)
                ),
                child: Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.receipt_long, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        'PROSES & PRINT',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}