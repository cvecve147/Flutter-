class AllJoinTable {
  final int id;
  final String name;
  final String employeeID;
  final String mac;
  final String temp;
  final int time;
  AllJoinTable(
      {this.id, this.name, this.employeeID, this.mac, this.temp, this.time});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'employeeID': employeeID,
      'mac': mac,
      'temp': temp,
      'time': time
    };
  }

  @override
  String toString() {
    // TODO: implement toString
    return 'AllJoinTable{id: $id, name: $name, employeeID: $employeeID, mac: $mac, temp:$temp , time:$time}';
  }
}
