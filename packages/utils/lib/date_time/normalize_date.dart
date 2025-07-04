import 'package:intl/intl.dart';

DateFormat inputFormat = DateFormat('yyyy-MM-dd hh:mm a');

DateTime normalizeDate(DateTime date) =>
    inputFormat.parse(inputFormat.format(date));
