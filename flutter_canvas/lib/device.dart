class Device {
  final String mac;
  final double x;
  final double y;
  double distance;
  Device({this.mac, this.x, this.y});
  @override
  String toString() {
    // TODO: implement toString
    return 'Device{mac: $mac, x: $x, y: $y}';
  }
}
