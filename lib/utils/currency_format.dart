import 'package:intl/intl.dart';

String formatRupiah(int number) {
  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID', 
    symbol: 'Rp. ', 
    decimalDigits: 0
   );

  return currencyFormatter.format(number);
}