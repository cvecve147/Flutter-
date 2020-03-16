class EmployeeJoinBluetooth {
  final int id;
  final String name;
  final String employeeID;
  final String mac;
  EmployeeJoinBluetooth({this.id, this.name, this.employeeID, this.mac});
  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'employeeID': employeeID, 'mac': mac};
  }

  @override
  String toString() {
    // TODO: implement toString
    return 'EmployeeJoinBluetooth{id: $id, name: $name, employeeID: $employeeID,mac:$mac }';
  }
}
