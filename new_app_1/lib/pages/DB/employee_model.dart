import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:imei_plugin/imei_plugin.dart';

class employee {
  final int id;
  final String name;
  final String employeeID;
  final String mac;
  employee({this.id, this.name, this.employeeID, this.mac});
  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'employeeID': employeeID, 'mac': mac};
  }

  Future<Map<String, dynamic>> toJson() async {
    String id = "";
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
      id = imei + "_" + devicename + "_";
      id += this.id.toString();
    } catch (e) {
      print(e);
    }

    //{\"_id\":\"2\",\"employeeID\":\"1\",\"mac\":\"F8:34:41:27:79:A1\",\"name\":\"username\"}
    return {"_id": id, "name": name, "employeeID": employeeID, "mac": mac};
  }

  @override
  String toString() {
    // TODO: implement toString
    return 'employee{id: $id, name: $name, employeeID: $employeeID,mac: $mac}';
  }
}
