class temperature {
  final int id;
  final String temp;
  final int time;
  temperature({this.id, this.temp, this.time});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'temp': temp,
      'time': time,
    };
  }

  String toString() {
    return 'temperature{id: $id, temp: $temp,time: $time,}';
  }
}
