import 'package:intl/intl.dart';

String formatCurrency(double amount) {
  // Hàm định dạng tiền tệ
  final format = NumberFormat.simpleCurrency(locale: 'vi');
  return format.format(amount);
}
