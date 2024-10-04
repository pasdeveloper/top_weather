import 'package:intl/intl.dart';

class LocaleDateFormatting {
  final String localeName;

  LocaleDateFormatting(this.localeName)
      : _timeFormatter = DateFormat('HH:mm', localeName),
        _fullTimeFormatter = DateFormat('HH:mm:ss', localeName),
        _dateFormatter = DateFormat('EEEE, dd MMMM', localeName),
        _dayNameFormatter = DateFormat('EEEE', localeName),
        _shortDayNameFormatter = DateFormat('EEE', localeName);

  final DateFormat _timeFormatter;
  final DateFormat _fullTimeFormatter;
  final DateFormat _dateFormatter;
  final DateFormat _dayNameFormatter;
  final DateFormat _shortDayNameFormatter;

  DateFormat get timeFormatter => _timeFormatter;
  DateFormat get fullTimeFormatter => _fullTimeFormatter;
  DateFormat get dateFormatter => _dateFormatter;
  DateFormat get dayNameFormatter => _dayNameFormatter;
  DateFormat get shortDayNameFormatter => _shortDayNameFormatter;
}
