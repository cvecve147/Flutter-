import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:imei_plugin/imei_plugin.dart';

class temperature {
  final int id;
  final String temp;
  final String roomTemp;
  final String time;
  final String symptom;
  temperature({this.id, this.temp, this.roomTemp, this.time, this.symptom});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'temp': temp,
      'roomTemp': roomTemp,
      'time': time,
      'symptom': symptom,
    };
  }

  Future<Map<String, dynamic>> toJson() async {
    String uploadid = "";
    String imei =
        await ImeiPlugin.getImei(shouldShowRequestPermissionRationale: false);
    String devicename = "";
    DeviceInfoPlugin deviceInfo = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        devicename = androidInfo.device;
      } else if (Platform.isAndroid) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        devicename = iosInfo.name;
      }
      uploadid = imei + "_" + devicename + "_";
      uploadid += this.id.toString();
    } catch (e) {
      print(e);
    }
    return {
      "id": uploadid,
      "temp": temp,
      "roomTemp": roomTemp,
      "time": time,
      "symptom": symptom,
    };
  }

  String toString() {
    return 'temperature{id: $id, temp: $temp,roomTemp: $roomTemp,time: $time,symptom:$symptom}';
  }
}
