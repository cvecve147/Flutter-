// Copyright 2017, Paul DeMarco.
// All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import './widgets.dart';
import './device.dart';
import './canvas.dart';

List<Device> device = new List<Device>();
void main() {
  runApp(FlutterBlueApp());

  // 9704-1	MAC: D4:6C:51:7D:F8:DB	(12,14.4)
  // 9704-2	MAC: FE:42:E1:2F:42:77   (24,12)
  // 9704-3	MAC: EB:A7:C6:6A:7C:CD	(36,12)
  // 9704-4	MAC: DC:F6:28:8B:95:8E	(45,14.4)
  // 9704-5	MAC: CC:E1:BF:9D:6B:9C  (31.95,21)
  // 9704-6	MAC: CA:8F:29:16:7F:4A	(37.2,31.8)
  // 9704-7	MAC: F8:94:1E:4E:31:D3	(34.65,42)
  //初始化
  Device temp = Device(mac: "D4:6C:51:7D:F8:DB", x: 12, y: 14.4);
  device.add(temp);
  temp = Device(mac: "FE:42:E1:2F:42:77", x: 24, y: 12);
  device.add(temp);
  temp = Device(mac: "EB:A7:C6:6A:7C:CD", x: 36, y: 12);
  device.add(temp);
  temp = Device(mac: "DC:F6:28:8B:95:8E", x: 45, y: 14.4);
  device.add(temp);
  temp = Device(mac: "CC:E1:BF:9D:6B:9C", x: 31.95, y: 21);
  device.add(temp);
  temp = Device(mac: "CA:8F:29:16:7F:4A", x: 37.2, y: 31.8);
  device.add(temp);
  // temp = Device(mac: "F8:94:1E:4E:31:D3", x: 34.65, y: 42);
  // device.add(temp);
}

bool switchOn = false;

class FlutterBlueApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.lightBlue,
      home: StreamBuilder<BluetoothState>(
          stream: FlutterBlue.instance.state,
          initialData: BluetoothState.unknown,
          builder: (c, snapshot) {
            final state = snapshot.data;
            if (state == BluetoothState.on) {
              return FindDevicesScreen();
            }
            return BluetoothOffScreen(state: state);
          }),
    );
  }
}

class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key key, this.state}) : super(key: key);

  final BluetoothState state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.bluetooth_disabled,
              size: 200.0,
              color: Colors.white54,
            ),
            Text(
              'Bluetooth Adapter is ${state != null ? state.toString().substring(15) : 'not available'}.',
              style: Theme.of(context)
                  .primaryTextTheme
                  .subhead
                  .copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class FindDevicesScreen extends StatefulWidget {
  FindDevicesScreen({Key key}) : super(key: key);

  @override
  _FindDevicesScreenState createState() => _FindDevicesScreenState();
}

class _FindDevicesScreenState extends State<FindDevicesScreen> {
  void _onSwitchChanged(bool value) {
    setState(() {
      switchOn = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool show_map = false;
    List<Device> preDevice = List();
    return Scaffold(
      appBar: AppBar(title: Text('Find Devices'), actions: [
        Switch(
          activeColor: Colors.lightGreenAccent,
          onChanged: _onSwitchChanged,
          value: switchOn,
        ),
        IconButton(
          icon: const Icon(Icons.add_location),
          tooltip: "顯示地圖",
          onPressed: () => {show_map = !show_map},
        )
      ]),
      body: RefreshIndicator(
        onRefresh: () =>
            FlutterBlue.instance.startScan(timeout: Duration(seconds: 4)),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StreamBuilder<List<ScanResult>>(
                  stream: FlutterBlue.instance.scanResults,
                  initialData: [],
                  builder: (c, snapshot) {
                    List getmac = List(); //只抓取掃描到的id 利用此id 來判斷是否為7樓Tag
                    List selectDevice = List(); //抓到的所有在Device列表中的Tag
                    List haobear = List(); //Tag name= Haobear
                    List<Device> point = List(); //抓取到的點
                    snapshot.data.map((r) {
                      getmac.add(r.device.id.toString());
                      if (r.device.name == "HaoBear") {
                        haobear.add(r);
                      }
                    }).toList();
                    for (var item in device) {
                      if (getmac.indexOf(item.mac) != -1) {
                        var snapshotData =
                            snapshot.data[getmac.indexOf(item.mac)];
                        selectDevice.add(snapshotData);
                        int rssi = snapshotData.rssi.abs();
                        double power = (rssi - 60) / (10.0 * 3.3);
                        item.distance = pow(10, power);
                        point.add(item);
                      }
                    }

                    /// 調整距離
                    if (preDevice == null) {
                      preDevice = point;
                    } else {
                      for (var device in preDevice) {
                        for (var one_Point in point) {
                          if (device.mac == one_Point.mac &&
                              device.distance - one_Point.distance > 2) {
                            one_Point = device;
                          }
                        }
                      }
                    }
                    preDevice = point;
                    if (!switchOn) {
                      haobear.sort((a, b) {
                        return a.rssi > b.rssi ? -1 : 1;
                      });
                      return Column(
                        children: haobear
                            .map(
                              (r) => ScanResultTile(
                                result: r,
                                open: true,
                              ),
                            )
                            .toList(),
                      );
                    }

                    //排列抓取到的點
                    point.sort((a, b) {
                      return a.distance > b.distance ? -1 : 1;
                    });
                    //排列抓取到的Tag
                    selectDevice.sort((a, b) {
                      return a.rssi > b.rssi ? -1 : 1;
                    });
                    double X = 0, Y = 0;
                    String showText = "";
                    if (switchOn && selectDevice.length >= 3) {
                      //  0 0 1
                      //  1 2 2
                      for (int i = 0; i < 2; i++) {
                        for (int j = i + 1; j < 3; j++) {
                          if (point[i].distance < 0) {
                            return Container(child: Text("系統錯誤"));
                          }
                          double p2p = sqrt(pow(point[i].x - point[j].x, 2) +
                              pow(point[i].y - point[j].y, 2)); //圓心公式
                          //判斷两圆是否相交
                          if (point[i].distance + point[j].distance <= p2p) {
                            var overDisance =
                                point[i].distance + point[j].distance;
                            //不相交，按比例求
                            showText +=
                                "超過範圍${i} , ${j} Distance:${overDisance} \n";
                            X += point[i].x +
                                (point[j].x - point[i].x) *
                                    point[i].distance /
                                    (point[i].distance + point[j].distance);
                            //x = x0+ (x1 - x0)*r0/(r0 + r1);
                            Y += point[i].y +
                                (point[j].y - point[i].y) *
                                    point[i].distance /
                                    (point[i].distance + point[j].distance);
                            //y = y0+ (y1- y0)*r0/(r0 + r1);
                          } else {
                            //相交则套用公式（上面推导出的）
                            //(BE) =(AB) /2+((BQ) ^2-(AQ) ^2)/(2(AB)  )
                            double dr = p2p / 2 +
                                (pow(point[i].distance, 2) -
                                        pow(point[j].distance, 2)) /
                                    (2 * p2p);
                            X += point[i].x +
                                (point[j].x - point[i].x) * dr / p2p;
                            Y += point[i].y +
                                (point[j].y - point[i].y) * dr / p2p;
                          }
                        }
                      }
                      X /= 3;
                      Y /= 3;
                      //設定顯示文字
                      showText += " 利用三角定位得出你現在的位子為 " +
                          X.toStringAsFixed(2) +
                          " , " +
                          Y.toStringAsFixed(2);
                    } else {
                      showText += "掃描數量為 " +
                          selectDevice.length.toString() +
                          " 無法計算三角定位";
                    }
                    if (switchOn) {
                      selectDevice = selectDevice.sublist(0, 3);
                    }
                    return Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            showText,
                            style: TextStyle(fontSize: 18),
                          ),
                          Column(
                            children: selectDevice
                                .map(
                                  (r) => ScanResultTile(
                                    result: r,
                                    open: true,
                                  ),
                                )
                                .toList(),
                          ),
                          show_map == true ? canvasRoute(X, Y) : Column()
                        ],
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
      floatingActionButton: StreamBuilder<bool>(
        stream: FlutterBlue.instance.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data) {
            return FloatingActionButton(
              child: Icon(Icons.stop),
              onPressed: () => FlutterBlue.instance.stopScan(),
              backgroundColor: Colors.red,
            );
          } else {
            return FloatingActionButton(
                child: Icon(Icons.search),
                onPressed: () async {
                  await FlutterBlue.instance.startScan(
                      timeout: Duration(seconds: 999), allowDuplicates: true);
                });
          }
        },
      ),
    );
  }
}
