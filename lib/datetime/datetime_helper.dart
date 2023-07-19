String convertDateTimeToString(DateTime dateTime) {
  String year = dateTime.toLocal().year.toString();
  String month = dateTime.toLocal().month.toString();
  if (month.length == 1) {
    month = '0$month';
  }
  String day = dateTime.toLocal().day.toString();
  if (day.length == 1) {
    day = '0$day';
  }
  String yyyymmdd = year + month + day;
  return yyyymmdd;
}
