import 'package:intl/intl.dart';

extension CustomFormat on DateTime {
  String toDisplay() {
    return DateFormat('yyyy/MM/dd').format(this);
  }
}
