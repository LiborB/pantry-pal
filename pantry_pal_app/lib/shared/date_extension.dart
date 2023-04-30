import 'package:intl/intl.dart' show DateFormat;

extension CustomFormat on DateTime {
  String toDisplay() {
    return DateFormat('yyyy/MM/dd').format(this);
  }
}
