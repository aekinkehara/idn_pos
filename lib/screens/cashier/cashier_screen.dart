import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:idn_pos/models/products.dart';
import 'package:idn_pos/screens/cashier/components/checkout_panel.dart';
import 'package:idn_pos/screens/cashier/components/printer_selector.dart';
import 'package:idn_pos/screens/cashier/components/product_cart.dart';
import 'package:idn_pos/screens/cashier/components/qr_result_modal.dart';
import 'package:idn_pos/utils/currency_format.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class CashierScreen extends StatefulWidget {
  const CashierScreen({super.key});

  @override
  State<CashierScreen> createState() => _CashierScreenState();
}

class _CashierScreenState extends State<CashierScreen> {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  List<BluetoothDevice> _devices = [];
  BluetoothDevice? _selectedDevice;
  bool _connected = false; //setelan awal blm connect sm bluetoothnya
  final Map<Product, int> _cart = {};

  @override  
  void initState() {
    super.initState();
    _initBluetooth();
  }

  // LOGIKA BLUETOOTH
  // untuk logika bluetooth
  Future<void> _initBluetooth() async {
    // meminta izin lokasi dan bluetooth (wajib)
    await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location
    ].request();

    List<BluetoothDevice> devices = [
      // list ini akan otomatis terisi, jika BT di hp menyala dan sudah ada device yg siap dikoneksikan
    ];
    try {
      devices = await bluetooth.getBondedDevices();
    } catch (e) {
      debugPrint("Bluetooth Error: $e");
    }

    if (mounted) {
      setState(() {
        _devices = devices;
      });
    }

    bluetooth.onStateChanged().listen((state) {
      if (mounted) {
        setState(() {
          _connected = state == BlueThermalPrinter.CONNECTED;
        });
      }
    });
  }

  // kalo bluetooth udh connect mau ngapain
  void _connectToDevice(BluetoothDevice? device) {
    // nested if

    // kalo device ada
    if (device != null) {
      // ini nyala apa kagak
      bluetooth.isConnected.then((isConnected) {
        // ga connect tp device ada, jawaban dari if pertama
        if (isConnected == false) {
          // ini nampilin error kalo beneran false
          bluetooth.connect(device).catchError((error) {
            if (mounted) setState(() => _connected = false);
          });

        // if yg ini setara sm if (isConnected == false)
        // if yg ini connect sm device
        if (mounted) setState(() => _selectedDevice = device);
       }
    });
  }
}

  // LOGIKA CART
  void _addToCart(Product product) {
    setState(() {
      _cart.update(
        // untuk mendefinisikan produk yg ada di menu
        product, 
        // logika matematis, yang dijalankan ketika satu product sudah ada di keranjang,
        // user klik +, yg nanti jumlahnya akan ditambah 1
        (value) => value + 1, 
        // jika user tidak menambahkan jumlah product (jumlah hanya 1) di keranjang, 
        //maka default jumlah dari tersebut adalah 1
        ifAbsent: () => 1);
    });
  }

  void _removeFromCart(Product product) {
    setState(() {
      // bang operator posisinya di akhir, not itu di awal
      if (_cart.containsKey(product) && _cart[product]! > 1) {
        _cart[product] = _cart[product]! - 1;
      } else {
        _cart.remove(product);
      }
    });
  }

  int _calculateTotal() {
    int total = 0;
    _cart.forEach((key, value) => total += (key.price * value));
    return total;
  }

  // LOGIKA PRINTING
  void _handlePrint() async {
    int total = _calculateTotal();
    if (total == 0) {
      ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text("Keranjang masih kosong!")));
    }

    // buat kode struk biar setiap struk beda kodenya
    String trxId = "TRX-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}";
    String qrData = "PAY:$trxId:$total";
    bool isPrinting = false;

    // menyiapkan tanggal saat ini (current date)
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd-MM-yyyy HH:mm').format(now);

    // LAYOUTING STRUK
    if (_selectedDevice != null && await bluetooth.isConnected == true) {
      // header struk
      bluetooth.printNewLine();
      bluetooth.printCustom("LOCAL DINER", 3, 1); // judul besar (center)
      bluetooth.printNewLine();
      bluetooth.printCustom("Jl. Laperan", 1, 1); // alamat (center)

      // tanggal & ID
      bluetooth.printNewLine();
      bluetooth.printLeftRight("Waktu:", formattedDate, 1);

      // untuk daftar items
      bluetooth.printCustom("--------------------------------", 1, 1);
      _cart.forEach((Product, qty) {
        String priceTotal = formatRupiah(Product.price * qty);
        // cetak nama barang x qty
        bluetooth.printLeftRight("${Product.name} x${qty}", priceTotal, 1);
      });
      bluetooth.printCustom("--------------------------------", 1, 1);

      // total & QR
      bluetooth.printLeftRight("TOTAL", formatRupiah(total), 3);
      bluetooth.printNewLine();
      bluetooth.printCustom("Scan QR Di Bawah:", 1, 1);
      bluetooth.printQRcode(qrData, 200, 200, 1);
      bluetooth.printNewLine();
      bluetooth.printCustom("Makasih Ya!", 1, 1);
      bluetooth.printNewLine();
      bluetooth.printNewLine();

      isPrinting= true;
    }

    // untuk menampilkan modal hasil QR Code (PopUp)
    _showQRModal(qrData, total, isPrinting);
  }

  void _showQRModal(String qrData, int total, bool isPrinting) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => QrResultModal(
        qrData: qrData,
        total: total,
        isPrinting: isPrinting,
        onClose: () => Navigator.pop(context),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(
          "Menu",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black87),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // dropdown select printer'=
          PrinterSelector(
            devices: _devices,
            selectedDevice: _selectedDevice,
            isConnected: _connected,
            onSelected: _connectToDevice,
          ),

          // grid for product list
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 15,
                mainAxisExtent: 15
              ),
              itemCount: menus.length,
              itemBuilder: (context, index) {
                final product = menus[index];
                final qty = _cart[product] ?? 0;

                // pemanggilan product list pada product card
                return ProductCart(
                  product: product,
                  qty: qty,
                  onAdd: () => _addToCart(product),
                  onRemove: () => _removeFromCart(product),
                );
              },
            ),
          ),

          // bottom sheet panel
          CheckoutPanel(
            total: _calculateTotal(),
            onPressed: _handlePrint,
          )
        ],
      ),
    );
  }
}