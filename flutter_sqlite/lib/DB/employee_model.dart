class employee {
  final int id;
  final String name;
  final String employeeID;
  final String mac;
  employee({this.id, this.name, this.employeeID, this.mac});
  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'employeeID': employeeID, 'mac': mac};
  }

  @override
  String toString() {
    // TODO: implement toString
    return 'employee{id: $id, name: $name, employeeID: $employeeID,mac: $mac}';
  }
}
