import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    // mengambil 35% dari keseluruhan tinggi layar
    final height = MediaQuery.of(context).size.height * 35 / 100;

    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2E3192), Color(0xFF1BFFFF)]
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40)
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5)
          )
        ]
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle
            ),
            child: Icon(
              Icons.restaurant_menu_rounded,
              size: 60,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 15),
          Text(
            'IDN Cafe QR System',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Kelola & bayar dengan mudah',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70
            ),
          )
        ],
      ),
    );
  }
}