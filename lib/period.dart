
class Period {
  String name;
  String startTime;
  String endTime;

  Period(String _name, String _startTime, String _endTime) {
    this.name = _name;
    this.startTime = _startTime;
    this.endTime = _endTime;
  }

  printPeriod() {
    print('$name: $startTime - $endTime');
  }
}