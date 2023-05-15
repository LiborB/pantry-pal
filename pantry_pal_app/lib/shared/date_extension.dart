import 'package:intl/intl.dart' show DateFormat;

extension CustomFormat on DateTime {
  String toDisplay() {
    return DateFormat('dd/MM/yyyy').format(this);
  }
}
