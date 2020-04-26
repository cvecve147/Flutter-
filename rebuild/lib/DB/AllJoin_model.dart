class AllJoinTable {
  final int id;
  final String name;
  final String employeeID;
  final String mac;
  final String temp;
  final String time;
  final String symptom;
  AllJoinTable(
      {this.id,
      this.name,
      this.employeeID,
      this.mac,
      this.temp,
      this.time,
      this.symptom});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'employeeID': employeeID,
      'mac': mac,
      'temp': temp,
      'time': time,
      'symptom': symptom
    };
  }

  @override
  String toString() {
    // TODO: implement toString
    return 'AllJoinTable{id: $id, name: $name, employeeID: $employeeID, mac: $mac, temp:$temp , time:$time, symptom:$symptom}';
  }
}
