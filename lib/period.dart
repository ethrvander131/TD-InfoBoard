class Period {
  String name;
  String startTime;
  String endTime;
  String customName;

  Period(String _name, String _startTime, String _endTime) {
    this.name = _name;
    this.startTime = _startTime;
    this.endTime = _endTime;
    this.customName = "";
  }

  printPeriod() {
    print('$name: $startTime - $endTime');
  }

  void setCustomName(String newName) {
    customName = newName;
  }

  String getCustomName() {
    return customName;
  }
}

List<Period> getPeriods(List<List<String>> periodsList) {
  List<Period> periods = [];

  if (periodsList.length > 0) {
    for (var p in periodsList) {
      periods.add(new Period(p[0], p[1], p[2]));
    }
  }

  return periods;
}
