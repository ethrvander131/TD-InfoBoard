<<<<<<< HEAD
=======

>>>>>>> parent of 83df8ed... Custom period names now work
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
<<<<<<< HEAD

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
=======
}
>>>>>>> parent of 83df8ed... Custom period names now work
