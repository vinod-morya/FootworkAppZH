import 'package:intl/intl.dart';

String dateFromLong(DateTime now, String format) {
  var formatter = DateFormat(format);
  String formatted = formatter.format(now);
  return formatted;
}

String getDate(String date, String format) {
  return '${date.isEmpty ? ' --' : ' ' + '${DateFormat(format).format(DateFormat("yyyy-MM-dd HH:mm:ss").parse(date, true).toLocal())}'}';
}

int getDateTimeStamp(String date, String format) {
  return date.isEmpty ? 0 : DateTime.parse(date).millisecondsSinceEpoch;
}
