import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static final DateFormat _defaultFormatter = DateFormat('dd/MM/yyyy HH:mm');

  static String formatDateTime(String isoString) {
    try {
      return _defaultFormatter.format(DateTime.parse(isoString).toLocal());
    } catch (_) {
      return isoString;
    }
  }
}
