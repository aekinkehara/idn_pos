import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';

class PrinterSelector extends StatelessWidget {
  final List<BluetoothDevice> devices;
  final BluetoothDevice? selectedDevice;
  final bool isConnected;
  final Function(BluetoothDevice?) onSelected;

  const PrinterSelector({super.key, required this.devices, this.selectedDevice, required this.isConnected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, 4)
          )
        ]
      ),
      child: Row(
        children: [
          Icon(Icons.print_rounded, color: isConnected ? Colors.green : Colors.grey),
          SizedBox(width: 15),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<BluetoothDevice>(
                hint: Text("Pilih Printer Bluetooth", style: TextStyle(fontSize: 14)),
                value: selectedDevice,
                icon: Icon(Icons.keyboard_arrow_down_rounded),
                items: devices.map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e.name ?? "Unknown Device", style: TextStyle(fontSize: 14)),
                )).toList(),
                onChanged: onSelected,
              ),
            ),
          ),
          if (isConnected)
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle
              ),
            )
        ],
      ),
    );
  }
}