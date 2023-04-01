/// Get millisecondsSinceEpoch and round down to days.
///
/// {@category Universal_helpers}
extension DateTimeExtensions on DateTime {
  DateTime dateOnly() {
    return DateTime(year, month, day);
  }

  int get daysSinceEpoch {
    return (millisecondsSinceEpoch + timeZoneOffset.inMilliseconds) ~/
        (Duration.secondsPerDay * 1000);
  }

  // DateTime dateFromDays(int days) {
  //   return DateTime.fromMillisecondsSinceEpoch(
  //     days * (Duration.secondsPerDay * 1000) - timeZoneOffset.inMilliseconds,
  //   );
  // }

  static DateTime today() {
    return DateTime.now().dateOnly();
  }
}
