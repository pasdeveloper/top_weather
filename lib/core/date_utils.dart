import 'package:intl/intl.dart';

final _timeFormatter = DateFormat('HH:mm');
final _dateFormatter = DateFormat('EEEE, dd MMM');

String toTime(int seconds) {
  final date = DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
  return _timeFormatter.format(date);
}

String toDate(int seconds) {
  final date = DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
  return _dateFormatter.format(date);
}