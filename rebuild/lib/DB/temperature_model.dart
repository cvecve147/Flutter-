class temperature {
  final int id;
  final String temp;
  final String time;
  final String symptom;
  temperature({this.id, this.temp, this.time, this.symptom});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'temp': temp,
      'time': time,
      'symptom': symptom,
    };
  }

  String toString() {
    return 'temperature{id: $id, temp: $temp,time: $time,symptom:$symptom}';
  }
}
