class BluetoothJoinTemp {
  final String id;
  final String mac;
  final String temp;
  final int time;
  BluetoothJoinTemp({this.id, this.mac, this.temp, this.time});
  Map<String, dynamic> toMap() {
    return {'id': id, 'mac': mac, 'temp': temp, 'time': time};
  }

  @override
  String toString() {
    // TODO: implement toString
    return 'BluetoothJoinTemp{id: $id,  mac: $mac, temp:$temp , time:$time}';
  }
}
