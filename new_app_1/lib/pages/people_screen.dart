import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/foundation.dart';
import 'package:newapp1/pages/DB/sqlhelper.dart';
import 'package:newapp1/pages/DB/employee_model.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:newapp1/pages/bluetooth/package.dart';

Color appColor = Color(0xFF2A6FDB);
Color cashColor = Color(0xFFFEFCBF);

getData() async {
  sqlhelper helper = new sqlhelper();
//  employee data=new employee(employeeID: "12",name: "123");
//  temperature data=new temperature(id:1,time: "2020-01-12",temp: "25.6");
//  helper.insertData(data);
//  print(await helper.showEmployee());
  return await helper.showEmployee();
}

class Content extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ContentState();
  }
}

class ContentState extends State<Content> {
  List data;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: downloadData(), // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        // AsyncSnapshot<Your object type>
        List<Widget> list;
        if (snapshot.hasData) {
          list = new List<Widget>();
          for (var i = 0; i < data.length; i++) {
            if (data[i].mac.toString() == ":::::" ||
                data[i].mac.toString() == "") {
              print(
                  data[i].id.toString() + "," + data[i].mac.toString() + "未配對");
              list.add(
                new Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  child: Container(
                    color: Colors.white,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.indigoAccent,
                        child: Text(
                          data[i].employeeID.toString(),
                        ),
                        foregroundColor: Colors.white,
                      ),
                      trailing: Text(
                        data[i].mac.toString(),
                        style: TextStyle(
                          fontSize: 22,
                        ),
                        textAlign: TextAlign.right,
                      ),
                      title: Text(
                        data[i].name.toString(),
                        style: TextStyle(
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.left,
                      ),
//                      subtitle: Text(
//                        data[i].employeeID.toString(),
//                        style: TextStyle(
//                          fontSize: 16,
//                        ),
//                        textAlign: TextAlign.left,
//                      ),
                    ),
                  ),
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      caption: '修改',
                      color: cashColor,
                      icon: Icons.edit,
                      onTap: () => createEditPeopleAlertDialog(
                        context,
                        data[i],
                      ),
                    ),
                    IconSlideAction(
                      caption: '配對',
                      color: Colors.blue,
                      icon: Icons.bluetooth_connected,
                      onTap: () => createPairPeopleAlertDialog(context),
                    ),
                    IconSlideAction(
                      caption: '刪除',
                      color: Colors.red,
                      icon: Icons.delete,
                      onTap: () => createDeletePeopleAlertDialog(
                          context,
                          data[i].name,
                          data[i].mac.toString(),
                          data[i].employeeID.toString(),
                          data[i].id),
                    ),
                  ],
                ),
              );
            } else {
              print(data[i].id.toString() + "已配對");
              list.add(
                new Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  child: Container(
                    color: Colors.white,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.indigoAccent,
                        child: Text(
                          data[i].employeeID.toString(),
                        ),
                        foregroundColor: Colors.white,
                      ),
                      trailing: Text(
                        data[i].mac.toString(),
                        style: TextStyle(
                          fontSize: 22,
                        ),
                        textAlign: TextAlign.right,
                      ),
                      title: Text(
                        data[i].name.toString(),
                        style: TextStyle(
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.left,
                      ),
//                      subtitle: Text(
//                        data[i].employeeID.toString(),
//                        style: TextStyle(
//                          fontSize: 16,
//                        ),
//                        textAlign: TextAlign.left,
//                      ),
                    ),
                  ),
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      caption: '修改',
                      color: cashColor,
                      icon: Icons.edit,
                      onTap: () => createEditPeopleAlertDialog(
                        context,
                        data[i],
                      ),
                    ),
                    IconSlideAction(
                      caption: '取消配對',
                      color: Colors.pink,
                      icon: Icons.bluetooth_disabled,
                      onTap: () async {
                        print("按下取消配對");
                        sqlhelper helpler = new sqlhelper();
                        employee editData = employee(
                            id: data[i].id,
                            employeeID: data[i].employeeID,
                            name: data[i].name,
                            mac: "");
                        await helpler.updateData(editData);
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text(data[i].name + "已解除配對"),
                        ));
                        setState(() {});
                      },
                    ),
                    IconSlideAction(
                      caption: '刪除',
                      color: Colors.red,
                      icon: Icons.delete,
                      onTap: () => createDeletePeopleAlertDialog(
                          context,
                          data[i].name,
                          data[i].mac.toString(),
                          data[i].employeeID.toString(),
                          data[i].id),
                    ),
                  ],
                ),
              );
            }
          }
          return new Column(children: list);
        } else {
          return Text('無資料');
        }
      },
    );
  }

  createDeletePeopleAlertDialog(
      BuildContext context, String name, String mac, String num, int idNum) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("刪除確認"),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Row(
                      children: <Widget>[
                        Text('確定要刪除此資料？'),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Row(
                      children: <Widget>[
                        Text('姓名：'),
                        Text(name),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Row(
                      children: <Widget>[
                        Text('編號：'),
                        Text(num),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Row(
                      children: <Widget>[
                        Text('MAC編碼：'),
                        Text(
                          mac,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              new ButtonBar(
                children: <Widget>[
                  new FlatButton(
                    child: Text('確認'),
                    // ignore: missing_return
                    onPressed: () async {
                      sqlhelper helpler = new sqlhelper();
                      await helpler.deleteEmployee(idNum);
                      Navigator.of(context).pop();
                      setState(() {});
                    },
                    color: appColor,
                  ),
                  new FlatButton(
                    child: Text(
                      '取消',
                      style: new TextStyle(color: appColor),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ),
            ],
          );
        });
  }

  TextEditingController editNameController = new TextEditingController();
  TextEditingController editNumController = new TextEditingController();
  List<TextEditingController> _editMaccontroller = [
    for (int i = 1; i < 7; i++) TextEditingController()
  ];

  createEditPeopleAlertDialog(BuildContext context, dynamic data) {
    editNameController.text = data.name;
    editNumController.text = data.employeeID.toString();
    var macSpilt = data.mac.toString().split(":");

    for (int i = 0; i < 6; i++) {
      _editMaccontroller[i].text = macSpilt[i];
    }

    Widget getMacWidgets() {
      List<Widget> list = new List<Widget>();
      for (var i = 0; i < 11; i++) {
        if (i % 2 == 0) {
          int $Control = (i / 2).toInt();
          list.add(
            new Flexible(
              child: new TextField(
                maxLength: 2,
                controller: _editMaccontroller[$Control],
              ),
            ),
          );
        } else {
          list.add(
            Text(":"),
          );
        }
      }
      return new Row(children: list);
    }

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("修改人員"),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Row(
                      children: <Widget>[
                        new Flexible(
                          child: new TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: '姓名',
                            ),
                            controller: editNameController,
                            style: Theme.of(context).textTheme.body1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Row(
                      children: <Widget>[
                        new Flexible(
                          child: new TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: '編號',
                            ),
                            keyboardType: TextInputType.number,
                            controller: editNumController,
                            style: Theme.of(context).textTheme.body1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: getMacWidgets()),
                ],
              ),
            ),
            actions: <Widget>[
              new ButtonBar(
                children: <Widget>[
                  new FlatButton(
                    child: Text('確認'),
                    // ignore: missing_return
                    onPressed: () async {
                      sqlhelper helpler = new sqlhelper();
                      employee editData = employee(
                          id: data.id,
                          employeeID: editNumController.text,
                          name: editNameController.text,
                          mac: _editMaccontroller[0].text +
                              ":" +
                              _editMaccontroller[1].text +
                              ":" +
                              _editMaccontroller[2].text +
                              ":" +
                              _editMaccontroller[3].text +
                              ":" +
                              _editMaccontroller[4].text +
                              ":" +
                              _editMaccontroller[5].text);
                      await helpler.updateData(editData);
                      Navigator.of(context).pop();
//                      Scaffold.of(context).showSnackBar(SnackBar(
//                        content: Text(data.name + "資料已修改"),
//                      ));
                      setState(() {});
                    },
                    color: appColor,
                  ),
                  new FlatButton(
                    child: Text(
                      '取消',
                      style: new TextStyle(color: appColor),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ),
            ],
          );
        });
  }

  createPairPeopleAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          debugPrint("Press Pair button.");
          return AlertDialog(
            title: Text("配對"),
            content: RefreshIndicator(
              onRefresh: () =>
                  FlutterBlue.instance.startScan(timeout: Duration(seconds: 4)),
              child: SingleChildScrollView(
                //SingleChildScrollView滾動條
                child: Column(
                  children: <Widget>[
                    //當已經connect上後才顯示的部分，少了RSSI與詳細資訊，多了open按鍵//
                    StreamBuilder<List<BluetoothDevice>>(
                      //用于創建一个周期性發送事件的串流Stream.periodic //asyncMap異步
                      stream: Stream.periodic(Duration(seconds: 2)).asyncMap(
                          (_) => FlutterBlue.instance.connectedDevices),
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
//                          trailing: StreamBuilder<BluetoothDeviceState>(
//                            stream: d.state,
//                            //預設未連接
//                            initialData: BluetoothDeviceState.disconnected,
//                            builder: (c, snapshot) {
//                              if (snapshot.data == BluetoothDeviceState.connected) {
//                                return RaisedButton(
//                                  child: Text('OPEN'),
//                                  //跳頁
//                                  onPressed: () => Navigator.of(context).push(
//                                    //跳頁到DeviceScreen並攜帶device
//                                      MaterialPageRoute(
////                                    builder: (context) =>
////                                        DeviceScreen(device: d)
//                                      )),
//                                );
//                              }
//                              //如果未連線，則顯示未連線資訊
//                              return Text(snapshot.data.toString());
//                            },
//                          ),
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
                              (r) => ScanResultTile(
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
          );
        });
  }

  Future<String> downloadData() async {
    data = await getData();
    sqlhelper helper = new sqlhelper();
    print(await helper.showEmployee());
    return Future.value("Get Data");
  }
}

class PeopleScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PeopleScreenState();
  }
}

class PeopleScreenState extends State<PeopleScreen> {
  Widget getMacWidgets() {
    List<Widget> list = new List<Widget>();
    for (var i = 0; i < 11; i++) {
      if (i % 2 == 0) {
        int $Control = (i / 2).toInt();
        list.add(
          new Flexible(
            child: new TextField(
              maxLength: 2,
              controller: _maccontroller[$Control],
            ),
          ),
        );
      } else {
        list.add(
          Text(":"),
        );
      }
    }
    return new Row(children: list);
  }

  List<TextEditingController> _maccontroller = [
    for (int i = 1; i < 7; i++) TextEditingController()
  ];
  TextEditingController nameController = new TextEditingController();
  TextEditingController numController = new TextEditingController();

  createAddPeopleAlertDialog(BuildContext context) {
    nameController.text = "";
    numController.text = "";

    for (int i = 0; i < 6; i++) {
      _maccontroller[i].text = "";
    }

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("新增人員"),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Row(
                      children: <Widget>[
//                      Text('姓名：'),
                        new Flexible(
                          child: new TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: '姓名',
                            ),
                            controller: nameController,
                            style: Theme.of(context).textTheme.body1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Row(
                      children: <Widget>[
//                      Text('姓名：'),
                        new Flexible(
                          child: new TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: '編號',
                            ),
                            keyboardType: TextInputType.number,
                            controller: numController,
                            style: Theme.of(context).textTheme.body1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: getMacWidgets()),
                ],
              ),
            ),
            actions: <Widget>[
              new ButtonBar(
                children: <Widget>[
                  new FlatButton(
                    child: Text('確認'),
                    // ignore: missing_return
                    onPressed: () async {
                      sqlhelper helper = new sqlhelper();

                      String name = nameController.text;
                      String num = numController.text;
                      String macAddress = _maccontroller[0].text.toUpperCase() +
                          ":" +
                          _maccontroller[1].text.toUpperCase() +
                          ":" +
                          _maccontroller[2].text.toUpperCase() +
                          ":" +
                          _maccontroller[3].text.toUpperCase() +
                          ":" +
                          _maccontroller[4].text.toUpperCase() +
                          ":" +
                          _maccontroller[5].text.toUpperCase();
                      if (name != "") {
                        Navigator.of(context).pop();
                        debugPrint(name);
                        if (num != "") {
                          if (_maccontroller[0].text == "" ||
                              _maccontroller[1].text == "" ||
                              _maccontroller[2].text == "" ||
                              _maccontroller[3].text == "" ||
                              _maccontroller[4].text == "" ||
                              _maccontroller[5].text == "") {
                            macAddress = "";
                          }
                          employee data = new employee(
                              employeeID: num, name: name, mac: macAddress);
                          await helper.insertData(data);
                          setState(() {});
                          return showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Result'),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      Text("姓名：" + name),
                                      Text("編號：" + num),
                                      Text("Mac Address：" + macAddress),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Result'),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: <Widget>[
                                        Text("請輸入編號"),
                                      ],
                                    ),
                                  ),
                                );
                              });
                        }
                      } else {
                        return showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Result'),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      Text("請輸入姓名"),
                                    ],
                                  ),
                                ),
                              );
                            });
                      }
                    },
                    color: appColor,
                  ),
                  new FlatButton(
                    child: Text(
                      '取消',
                      style: new TextStyle(color: appColor),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("人員管理"),
        centerTitle: true,
        backgroundColor: appColor,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.person_add),
            tooltip: '新增人員',
            onPressed: () {
              createAddPeopleAlertDialog(context);
            },
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.input),
          tooltip: '匯入人員',
          onPressed: () async {
            sqlhelper helpler = new sqlhelper();
//            await helpler.readCsvToEmployee();
            String result = await helpler.readCsvToEmployee();
            print(result);
            if (result == "匯入成功") {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("人員資料匯入成功"),
              ));
            } else {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("人員資料匯入失敗"),
              ));
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[Content()],
        ),
      ),
    );
  }

  Future<void> searchData() async {
    sqlhelper hepler = new sqlhelper();
//    var employee =await hepler.searchEmployeeMAC("11:11:21:11"); //id
    // var a= await sqlhepler.searchEmployeeMAC(nameL[i]);
//    employee.length;//id:1,name:"123",mac:"11:11:21:11", employeeID:"001", employee[0].name
    employee data1 = new employee(
        name: "ivy", employeeID: "1", id: 1, mac: "30:45:11:3E:30:E5");
    await hepler.updateData(data1);
  }
}

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
                        (r) => ScanResultTile(
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

class People extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PeopleState();
  }
}

class _PeopleState extends State<People> {
  @override
  Widget build(BuildContext context) {
    return null;
  }
}
