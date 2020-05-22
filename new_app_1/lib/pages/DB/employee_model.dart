class employee {
  final int id;
  final String name;
  final String employeeID;
  final String mac;
  employee({this.id, this.name, this.employeeID, this.mac});
  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'employeeID': employeeID, 'mac': mac};
  }

  Map<String, dynamic> toJson() {
    //{\"_id\":\"2\",\"employeeID\":\"1\",\"mac\":\"F8:34:41:27:79:A1\",\"name\":\"username\"}
    return {
      "_id": this.id.toString(),
      "name": name,
      "employeeID": employeeID,
      "mac": mac
    };
  }

  @override
  String toString() {
    // TODO: implement toString
    return 'employee{id: $id, name: $name, employeeID: $employeeID,mac: $mac}';
  }
}
