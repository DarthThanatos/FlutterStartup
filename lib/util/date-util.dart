
class DateUtils{

  static String getPrettyTimeDifferenceFromStringDate(String dateStr){
    final date = DateTime.parse(dateStr);
    return getPrettyTimeDifferenceFrom(date);
  }

  static String getPrettyTimeDifferenceFrom(DateTime dateTime){
    final diff = DateTime.now().difference(dateTime);
    if(diff.inDays > 0) return '${diff.inDays} day(s)';
    if(diff.inHours > 0) return '${diff.inHours} hour(s)';
    if(diff.inMinutes > 0) return '${diff.inMinutes} minute(s)';
    return '${diff.inSeconds} second(s)';
  }
}