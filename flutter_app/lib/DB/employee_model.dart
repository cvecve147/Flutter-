class employee {
  final int id;
  final String name;
  final String employeeID;
  employee({this.id, this.name, this.employeeID});
  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'employeeID': employeeID};
  }

  @override
  String toString() {
    // TODO: implement toString
    return 'employee{id: $id, name: $name, employeeID: $employeeID}';
  }
}
