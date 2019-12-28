import 'package:intl/intl.dart';

String dateFromLong(DateTime now, String format) {
  var formatter = DateFormat(format);
  String formatted = formatter.format(now);
  return formatted;
}

String getDate(String date, String format) {
  return '${date.isEmpty ? ' --' : ' ' + '${DateFormat(format,"zh").format(DateTime.parse(date).toLocal())}'}';
}
