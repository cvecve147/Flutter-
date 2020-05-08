import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:newapp1/pages/bluetooth/package2.dart';

import 'DB/sqlhelper.dart';

Color appColor = Color(0xFF2A6FDB);

Widget getTimeWidgets(String all) {
  WidgetsFlutterBinding.ensureInitialized();
  var data = all.split(" ");

  String date = data[0];
  String time = data[1];

  List<Widget> list = new List<Widget>();
  list.add(
    new Padding(
        padding: new EdgeInsets.all(28.0),
        child: new Column(
          children: <Widget>[
            Center(
              child: Text(
                '上次量測時間',
                textScaleFactor: 1.5,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
            ),
            Text(
              date,
              textScaleFactor: 2.5,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            Text(
              time,
              textScaleFactor: 2.5,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        )),
  );

  return new Column(children: list);
}



class statefulScanScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ScanScreenState();
  }
}

showCurrentDate(BuildContext context) {
  var now = new DateTime.now();
  String twoDigit(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  String currentDate = twoDigit(now.year) + "-" + twoDigit(now.month) + "-" + twoDigit(now.day);
  String currentTime = twoDigit(now.hour) + "-" + twoDigit(now.minute) + "-" + twoDigit(now.second);

  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text("測量時間：" + currentDate + " " + currentTime),
  ));
}

class _ScanScreenState extends State<statefulScanScreen> {

  String lastScanDate = "尚未量測 無上次量測時間";

  @override
  void initState() {
    super.initState();
    (() async {
      sqlhelper helper = sqlhelper();
      List temp = await helper.showLastDate();
      print(await helper.showLastDate());
      if (temp.length > 0) {
        lastScanDate = temp[0].time;
      }
      print(temp);
      setState(() {});
    })();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("體溫量測"),
        centerTitle: true,
        backgroundColor: appColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          getTimeWidgets(lastScanDate),
          Padding(
              padding: new EdgeInsets.only(top: 0),
              child: new RaisedButton(
                onPressed: () {
//                  showCurrentDate(context);
                  FlutterBlue.instance
                      .startScan(timeout: Duration(seconds: 10));
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FindDevicesScreen()),
                  );
                },
                textColor: Colors.white,
                splashColor: appColor,
                padding: const EdgeInsets.all(0.0),
                color: Color(0xFF122C91),
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(25.0),
//                side: BorderSide(color: Color(0xFF122C91))
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 90.0),
                  child: const Text('開始量測', style: TextStyle(fontSize: 30)),
                ),
              ))
        ],
      ),
    );
  }
}

//class ScanScreen extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text("體溫量測"),
//        centerTitle: true,
//        backgroundColor: appColor,
//      ),
//      body: Column(
//        mainAxisAlignment: MainAxisAlignment.center,
//        children: <Widget>[
//          getTimeWidgets(currentDate, currentTime),
//          Padding(
//              padding: new EdgeInsets.only(top: 0),
//              child: new RaisedButton(
//                onPressed: () {
////                  showCurrentDate(context);
//                  FlutterBlue.instance
//                      .startScan(timeout: Duration(seconds: 10));
//                  Navigator.push(
//                    context,
//                    MaterialPageRoute(
//                        builder: (context) => FindDevicesScreen()),
//                  );
//                },
//                textColor: Colors.white,
//                splashColor: appColor,
//                padding: const EdgeInsets.all(0.0),
//                color: Color(0xFF122C91),
//                shape: new RoundedRectangleBorder(
//                  borderRadius: new BorderRadius.circular(25.0),
////                side: BorderSide(color: Color(0xFF122C91))
//                ),
//                child: Container(
//                  padding: const EdgeInsets.symmetric(
//                      vertical: 20.0, horizontal: 90.0),
//                  child: const Text('開始量測', style: TextStyle(fontSize: 30)),
//                ),
//              ))
//        ],
//      ),
//    );
//  }
//}

class FlutterBlueApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //確認是否開啟藍芽，若未開顯示藍芽未開的畫面
    return MaterialApp(
      color: Colors.white,
      //StreamBuilder本身是一個Widget，會監聽一個Stream，只要這個Stream有數據變化，
      //它內部的UI就會根據這個新的數據進行變化，完全不需要setState((){})
      home: StreamBuilder<BluetoothState>(
          //負責監聽的Stream
          stream: FlutterBlue.instance.state,
          //初始化值
          initialData: BluetoothState.unknown,
          //根據Stream變化進行修改的UI
          builder: (context, snapshot) {
            final state = snapshot.data;
            if (state == BluetoothState.on) {
              //藍芽已開，進入搜尋畫面
              return FindDevicesScreen();
            }
            //藍芽未開
            return BluetoothOffScreen(state: state);
          }),
    );
  }
}

//藍芽未開的畫面
class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key key, this.state}) : super(key: key);

  final BluetoothState state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
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
              'Bluetooth Adapter is ${state.toString().substring(15)}.',
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

//初始首頁
class FindDevicesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("量測結果"),
        backgroundColor: Color(0xFF2A6FDB),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: '重新掃描',
            onPressed: () =>
                FlutterBlue.instance.startScan(timeout: Duration(seconds: 10)),
          ),
        ],
      ),

//      body: Center(child: getTempWidgets(nameList, tempList, numList)),
      body: RefreshIndicator(
        onRefresh: () =>
            FlutterBlue.instance.startScan(timeout: Duration(seconds: 4)),
        child: SingleChildScrollView(
          //SingleChildScrollView滾動條
          child: Column(
            children: <Widget>[
              //當已經connect上後才顯示的部分，少了RSSI與詳細資訊，多了open按鍵//
              StreamBuilder<List<BluetoothDevice>>(
                //用于創建一个周期性發送事件的串流Stream.periodic //asyncMap異步
                stream: Stream.periodic(Duration(seconds: 2))
                    .asyncMap((_) => FlutterBlue.instance.connectedDevices),
                //initialData初始資料為空
                initialData: [],
                builder: (c, snapshot) => Column(
                  //ListTile 通常用於在 Flutter 中填充 ListView
                  children: snapshot.data
                      .map((d) =>
//                      getTempWidgets(nameList, tempList, numList)
                          ListTile(
                            //名稱
                            title: Text(d.name),
                            //mac
                            subtitle: Text(d.id.toString()),

                            //trailing設置拖尾將在列表的末尾放置一個圖像
                            trailing: StreamBuilder<BluetoothDeviceState>(
                              stream: d.state,
                              //預設未連接
                              initialData: BluetoothDeviceState.disconnected,
                              builder: (c, snapshot) {
                                if (snapshot.data ==
                                    BluetoothDeviceState.connected) {
                                  return RaisedButton(
                                    child: Text('OPEN'),
                                    //跳頁
                                    onPressed: () => Navigator.of(context).push(
                                        //跳頁到DeviceScreen並攜帶device
                                        MaterialPageRoute(
//                                    builder: (context) =>
//                                        DeviceScreen(device: d)
                                            )),
                                  );
                                }
                                //如果未連線，則顯示未連線資訊
                                return Text(snapshot.data.toString());
                              },
                            ),
                          ))
                      .toList(),
                ),
              ),

//              所有搜尋到的結果列表
              StreamBuilder<List<ScanResult>>(
                stream: FlutterBlue.instance.scanResults,
                initialData: [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data
                      .map(
                        (r) => Scan(
                          result: r,
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),

      //改變按鈕
//      floatingActionButton: StreamBuilder<bool>(
//        stream: FlutterBlue.instance.isScanning,
//        initialData: false,
//        builder: (c, snapshot) {
//          if (snapshot.data) {
//            //當在掃描中就改變icon為stop，要是被按下就執行stopScan()，背景是紅色停止鍵
//            return FloatingActionButton(
//              child: Icon(Icons.stop),
//              onPressed: () => FlutterBlue.instance.stopScan(),
//              backgroundColor: Colors.red,
//            );
//          } else {
//            //不在掃描中就icon為search，要是被按下就開始掃10秒
//            return FloatingActionButton(
//                child: Icon(Icons.search),
//                onPressed: () => FlutterBlue.instance
//                    .startScan(timeout: Duration(seconds:10)));
//          }
//        },
//      ),
    );
  }
}
