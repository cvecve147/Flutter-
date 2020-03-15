class temperature {
  final String id;
  final String temp;
  final String time;
  temperature({this.id, this.temp, this.time});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'temp': temp,
      'time': time,
    };
  }

  String toString() {
    // TODO: implement toString
    return 'temperature{id: $id, temp: $temp,time: $time,}';
  }
}
