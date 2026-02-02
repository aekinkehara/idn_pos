import 'package:flutter/material.dart';
import 'package:idn_pos/models/products.dart';
import 'package:idn_pos/utils/currency_format.dart';

class ProductCart extends StatelessWidget {
  final Product product;
  final int qty;
  final VoidCallback onAdd;
  final VoidCallback onRemove;


  const ProductCart({super.key, required this.product, required this.qty, required this.onAdd, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
        border: qty > 0 ? Border.all(color: Colors.blueAccent, width: 2) : null
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // icon
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(color: Colors.orange.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(Icons.fastfood_rounded, size: 35, color: Colors.orange),
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              product.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)
            ),
          ),
          SizedBox(height: 5),
          Text(
            formatRupiah(product.price),
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
          SizedBox(height: 10),
          // button penambahan item
          if (qty == 0 )
            InkWell(
              onTap: onAdd,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(color: Color(0xFFF5F7FA), borderRadius: BorderRadius.circular(20)),
                child: Text(
                  'Tambah',
                  style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                ),
              ),
            )
          else
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _counterBtn(Icons.remove, onRemove),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "$qty",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                  ),
                ),
              ),
              _counterBtn(Icons.add, onAdd)
            ],
          )
        ],
      ),
    );
  }

  Widget _counterBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, size: 16, color: Colors.white),
      ),
    );
  }
}