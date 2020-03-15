class bluetooth {
  final String id;
  final String mac;

  bluetooth({this.id, this.mac});

  Map<String, dynamic> toMap() {
    return {'id': id, 'mac': mac,};
  }

  String toString() {
    // TODO: implement toString
    return 'bluetooth{id: $id, mac: $mac}';
  }
}
