class EmployeeJoinTemp {
  final int id;
  final String name;
  final String employeeID;
  final String temp;
  final int time;
  EmployeeJoinTemp({this.id, this.name, this.employeeID, this.temp, this.time});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'employeeID': employeeID,
      'temp': temp,
      'time': time
    };
  }

  @override
  String toString() {
    // TODO: implement toString
    return 'EmployeeJoinTemp{id: $id, name: $name, employeeID: $employeeID, temp:$temp , time:$time}';
  }
}
