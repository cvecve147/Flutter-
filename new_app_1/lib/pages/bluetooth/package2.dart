// Copyright 2017, Paul DeMarco.
// All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math';

import 'package:newapp1/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:newapp1/pages/people_screen.dart';
import '../DB/sqlhelper.dart';
import '../DB/employee_model.dart';
import '../DB/temperature_model.dart';

List<Map<String, dynamic>> timesData = [{}];
//timesData.add({"id":a[0],"temp":tempL,"time":getCurrentDate().toString()});

class Scan extends StatefulWidget {
  Scan({Key key, this.result, this.onTap}) : super(key: key);

  final ScanResult result;
  final VoidCallback onTap;

//  final List<String> items;

  //必需重写createState方法
  @override
  ScanResultTile createState() => new ScanResultTile(result, onTap);
}

class ScanList extends State<Scan> {
  final ScanResult result;
  final VoidCallback onTap;

  ScanList(this.result, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
//            children: <Widget>[ScanResultTile(result,onTap)],
          ),
    ));
  }
}

class ScanResultTile extends State<Scan> {
  //StatelessWidget
//  ScanResultTile({Key key, this.result, this.onTap}) : super(key: key);
  ScanResult result;
  VoidCallback onTap;

//  List<String> items;
  ScanResultTile(this.result, this.onTap);

  List<String> numList = [];
  List<String> nameList = [];

//  List<String> checkList = [];

  Widget _buildTitle(BuildContext context) {
    //先判斷有無Name
    if (result.device.name.length > 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //Name
          Text(
            result.device.name,
            overflow: TextOverflow.ellipsis, //無視省略號(...)
          ),

          //MacAddress
          Text(
            result.device.id.toString(),
            style: Theme.of(context).textTheme.caption,
          )
        ],
      );
    } else {
      return Text(result.device.id.toString());
    }
  }

  Widget getTempWidgets(
      context, List<String> macL, List<String> tempL, List<String> rssiL) {
//    ListView.builder(
//      itemCount:nameL.length,
//      itemExtent: 50,
//      itemBuilder: (BuildContext context, int index){
//        return getTempWidgets(nameL,tempL,numberL);//ListTile(title:Text("$index"))
//      },
//    );
    createConfirmDataAlertDialog(
      BuildContext context,
      String mac,
      String data,
      String rssi,
      int i,
    ) {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("人員配對確認"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Row(
                        children: <Widget>[
                          Text("編號：" + rssi),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Row(
                        children: <Widget>[
                          Text("姓名：" + mac),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Row(
                        children: <Widget>[
                          Text("量測溫度：" + data),
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
                      onPressed: () {
                        insertData(macL, tempL, rssiL, i, statusList,getRoomTempData(result.advertisementData.manufacturerData),);
                        Navigator.of(context).pop();
                        return showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('確認成功'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(top: 16),
                                      child: Row(
                                        children: <Widget>[
                                          Text("編號：" + rssi),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 16),
                                      child: Row(
                                        children: <Widget>[
                                          Text("姓名：" + mac),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 16),
                                      child: Row(
                                        children: <Widget>[
                                          Text("量測溫度：" + data),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
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

//    print(macL);print(tempL);print(rssiL);
    List<Widget> list = new List<Widget>();
    for (var i = 0; i < macL.length; i++) {
      list.add(
        new Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          child: Container(
            color: Colors.white,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.indigoAccent,
                child: Icon(Icons.person),
                foregroundColor: Colors.white,
              ),
              trailing: Text(
                tempL[i],
                style: TextStyle(
                  fontSize: 24,
                ),
                textAlign: TextAlign.right,
              ),
              title: Text(
                macL[i],
                style: TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.left,
              ),
              subtitle: Text(
                rssiL[i],
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: '確認',
              color: Color(0xFF81E9E6),
              icon: Icons.check_circle,
              onTap: () => createConfirmDataAlertDialog(
                  context, macL[i], tempL[i], rssiL[i], i),
            ),
          ],
        ),
      );
    }
    return new Column(children: list);
  }

  //設計
  Widget _buildAdvRow(BuildContext context, String title, String value) {
//    createAddPeopleAlertDialog(context);
    return Padding(
      //對稱型的padding，分別設定水平和垂直的值
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, //靠上
        children: <Widget>[
          //左側
          Text(title, style: Theme.of(context).textTheme.caption),

          //兩側中間留白
          SizedBox(
            width: 12.0,
          ),

          //右側
          Expanded(
            child: Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .caption
                  .apply(color: Colors.black),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  //取得16進制array
  String getNiceHexArray(List<int> bytes) {
    return '[${bytes.map((i) => i.toRadixString(16).padLeft(2, '0')).join(', ')}]'
        .toUpperCase();
  }

  String transValue(correct, bytes) {
    String t =
        '${bytes.map((i) => i.toRadixString(16).padLeft(2, '0')).join(', ')}'
            .toUpperCase();
    var data1, data2, data3, data4, pid, check1, check2;
    check1 = bytes
        .elementAt(0)
        .toRadixString(16)
        .padLeft(2, '0')
        .toUpperCase()
        .toString();
    check2 = bytes
        .elementAt(1)
        .toRadixString(16)
        .padLeft(2, '0')
        .toUpperCase()
        .toString();
    pid = bytes
        .elementAt(2)
        .toRadixString(16)
        .padLeft(2, '0')
        .toUpperCase()
        .toString();
    if (correct == '8796' && check1 == '59' && check2 == '80' && pid == '03') {
      data1 = bytes
          .elementAt(4)
          .toRadixString(16)
          .padLeft(2, '0')
          .toUpperCase()
          .toString();
      data2 = bytes
          .elementAt(5)
          .toRadixString(16)
          .padLeft(2, '0')
          .toUpperCase()
          .toString();
      data3 = bytes
          .elementAt(6)
          .toRadixString(16)
          .padLeft(2, '0')
          .toUpperCase()
          .toString();
      data4 = bytes
          .elementAt(7)
          .toRadixString(16)
          .padLeft(2, '0')
          .toUpperCase()
          .toString();
      double tem = bytesToFloat(toRadix(data1), toRadix(data2), toRadix(data3),
          toRadix(data4)); //decodeTempLevel(data,0);
      return formatNum(tem,2); //+data2+data3+data4
    } else {
      return correct;
    }
  }

  String checkAddress(correct, bytes) {
    var pid, check1, check2;
    check1 = bytes
        .elementAt(0)
        .toRadixString(16)
        .padLeft(2, '0')
        .toUpperCase()
        .toString();
    check2 = bytes
        .elementAt(1)
        .toRadixString(16)
        .padLeft(2, '0')
        .toUpperCase()
        .toString();
    pid = bytes
        .elementAt(2)
        .toRadixString(16)
        .padLeft(2, '0')
        .toUpperCase()
        .toString();
    return correct + check1 + check2 + pid;
  }

  String transTemp(bytes) {
    var data1, data2, data3, data4, data;
    data = bytes.split(',');
    data1 = data[0].trim(); //trim():將字符串兩邊去除空格處理
    data2 = data[1].trim();
    data3 = data[2].trim();
    data4 = data[3].trim();
//    print(data1);
//    print(data2);
//    print(data3);
//    print(data4);
    double tem = bytesToFloat(toRadix(data1), toRadix(data2), toRadix(data3),
        toRadix(data4)); //decodeTempLevel(data,0);
    return formatNum(tem, 2); //+data2+data3+data4
  }

  //溫度小數取到第二位
  formatNum(double num, int postion) {
    if ((num.toString().length - num.toString().lastIndexOf(".") - 1) <
        postion) {
      return num.toStringAsFixed(postion)
          .substring(0, num.toString().lastIndexOf(".") + postion + 1)
          .toString();
    } else {
      return num.toString()
          .substring(0, num.toString().lastIndexOf(".") + postion + 1)
          .toString();
    }
  }

  int toRadix(x) {
    var first, sec;
    first = x.substring(0, 1);
    switch (first) {
      case 'F':
        {
          first = 15;
        }
        break;
      case 'E':
        {
          first = 14;
        }
        break;
      case 'D':
        {
          first = 13;
        }
        break;
      case 'C':
        {
          first = 12;
        }
        break;
      case 'B':
        {
          first = 11;
        }
        break;
      case 'A':
        {
          first = 10;
        }
        break;
      default:
        {
          first = int.parse(first);
        }
    }
    sec = x.substring(1, 2);
    switch (sec) {
      case 'F':
        {
          sec = 15;
        }
        break;
      case 'E':
        {
          sec = 14;
        }
        break;
      case 'D':
        {
          sec = 13;
        }
        break;
      case 'C':
        {
          sec = 12;
        }
        break;
      case 'B':
        {
          sec = 11;
        }
        break;
      case 'A':
        {
          sec = 10;
        }
        break;
      default:
        {
          sec = int.parse(sec);
        }
    }
    var ans = first * 16 + sec;
    return ans & 0xFF;
  }

  //判斷是否為華星tag
  bool tagis(Map<int, List<int>> data1, Map<String, List<int>> data2, mac) {
    var check;
    List<String> res1 = [], res2 = [];
    data1.forEach((id, bytes) {
      var c = '${id.toRadixString(16).toUpperCase()}';
      check = '${checkAddress(c, bytes)}';
      res1.add('${checkAddress(c, bytes)}');
    });
    data2.forEach((id, bytes) {
      res2.add(
          '${trans(bytes)}'); //${id.toUpperCase()}  ${getNiceHexArray(bytes)}
    });
    if (check == '8796598003') {
      return true;
    } else {
      return false;
    }
  }

  //取得16進制array
  String trans(List<int> bytes) {
    return '${bytes.map((i) => i.toRadixString(16).padLeft(2, '0')).join(', ')}'
        .toUpperCase();
  }

  //取得製造商資訊
  String getNiceManufacturerData(Map<int, List<int>> data) {
    if (data.isEmpty) {
      return null;
    }
    List<String> res = [];
    data.forEach((id, bytes) {
      res.add(
          '${id.toRadixString(16).toUpperCase()}: ${getNiceHexArray(bytes)}');
    });
    return res.join(', ');
  }

  //取得室溫資訊
  String getRoomTempData(Map<int, List<int>> data) {
    if (data.isEmpty) {
      return null;
    }
    List<String> res = [];
    data.forEach((id, bytes) {
      var c = '${id.toRadixString(16).toUpperCase()}';
      res.add('${transValue(c, bytes)}');
    });
    return res.join(', ');
  }

  //取得體溫資料
  String getBodyTempData(Map<String, List<int>> data) {
    //String
    if (data.isEmpty) {
      return null;
    }
    List<String> res = [];
//    res.add('${trans(data[1])}');
    data.forEach((id, bytes) {
      res.add(
          '${trans(bytes)}'); //${id.toUpperCase()}  ${getNiceHexArray(bytes)}
    });
    return res.elementAt(0);
  }

  //取得溫度資料
  String getTempData(Map<int, List<int>> data1, Map<String, List<int>> data2) {
    var check;
    List<String> res1 = [], res2 = [];
    data1.forEach((id, bytes) {
      var c = '${id.toRadixString(16).toUpperCase()}';
      check = '${checkAddress(c, bytes)}';
      res1.add('${checkAddress(c, bytes)}');
    });
    data2.forEach((id, bytes) {
      res2.add(
          '${trans(bytes)}'); //${id.toUpperCase()}  ${getNiceHexArray(bytes)}
    });
    if (check == '8796598003') {
      return transTemp(res2.elementAt(1));
    } else {
      return res1.toString(); //elementAt(0)
    }
  }

  //取得服務資料
  String getNiceServiceData(Map<String, List<int>> data) {
    //String
    if (data.isEmpty) {
      return null;
    }
    List<String> res = [];
    data.forEach((id, bytes) {
      res.add(
          '${id.toUpperCase()}: ${getNiceHexArray(bytes)}'); //${id.toUpperCase()}  ${getNiceHexArray(bytes)}
    });
    return res.join(', ');
  }

  Future<String> searchData() async {
    sqlhelper sqlhepler = new sqlhelper();
    List a = await sqlhepler.showEmployee();
    return a[0].name;
  }

  Future<void> insertData(macL, tempL, rssiL, int i, List s,roomTemp) async {
    //print(tempL);
    sqlhelper sqlhepler = new sqlhelper();
    var a = await sqlhepler.searchEmployeeMAC(macL.toString());
    //print(a);
    checkListData.add({
      "id": a.length == 0 ? 0 : a[0].id,
      "temp": tempL,
      "time": getCurrentDate().toString(),
    });
    temperature data = new temperature(
        id: a[0].id,
        roomTemp:roomTemp,
        temp: tempL,
        time: getCurrentDate().toString(),
        symptom: s.join("、"));
    timesData
        .add({"id": a[0], "temp": tempL, "time": getCurrentDate().toString()});
    //print(getCurrentDate());
    await sqlhepler.insertData(data);
//    print(await sqlhepler.showtemperature());
  }

  getCurrentDate() {
    var now = new DateTime.now();
    String twoDigit(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String currentDate = twoDigit(now.year) +
        "-" +
        twoDigit(now.month) +
        "-" +
        twoDigit(now.day);
    String currentTime = twoDigit(now.hour) +
        ":" +
        twoDigit(now.minute) +
        ":" +
        twoDigit(now.second);

    return currentDate + " " + currentTime;
  }

  title(String allmac, String mac, String name) {
    if (allmac == mac) {
      return name;
    } else {
      return mac;
    }
  }

  id(String allmac, String mac, String id) {
    if (allmac == mac) {
      return id;
    } else {
      return 0.toString();
    }
  }

  Future<String> downloadData(macList) async {
    sqlhelper helper = new sqlhelper();
    if (tagis(result.advertisementData.manufacturerData,
            result.advertisementData.serviceData, macList[0]) ==
        true) {
      var a = await helper.searchEmployeeMAC(macList[0].toString());
      //print(a);
      if (a.length != 0) {
        nameList.add(a[0].name.toString());
        numList.add(a[0].employeeID);
      } else {
        nameList.add(macList[0].toString());
        numList.add("0");
      }
    }
//      print(macList);
    return Future.value("Get Data"); // return your response
  }

  @override
  Widget build(BuildContext context) {
    List<String> tempList = [];
    List<String> rssiList = [];
    List<String> macList = [];
    List<String> m = [];
    bool turn = true;

    macList.add(result.device.id.toString());
    tempList.add(getTempData(result.advertisementData.manufacturerData,
        result.advertisementData.serviceData));
    rssiList.add(result.rssi.toString());

    createConfirmDataAlertDialog(
        BuildContext context, String name, String data, String num, int i) {
      _value = [
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false
      ];
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("量測確認"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Row(
                        children: <Widget>[
                          Text("編號：" + num),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Row(
                        children: <Widget>[
                          Text("姓名：" + name),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Row(
                        children: <Widget>[
                          Text("量測溫度：" + data),
                        ],
                      ),
                    ),
                    StatusBox(),
                  ],
                ),
              ),
              actions: <Widget>[
                new ButtonBar(
                  children: <Widget>[
                    new FlatButton(
                      child: Text('確認'),
                      onPressed: () {
                        setState(() {});
                        if (num != '0') {
                          setState(() {});

                          for (var j = 0; j < macList.length; j++) {
                            if (checkData.length <= 0) {
                              checkData.add(macList[0]);
                            } else if (macList[i] != checkData[j]) {
                              checkData.add(macList[0]);
                            }
                          }
                          List<String> selectedStatus = new List();
                          for (var n = 0; n < _value.length; n++) {
                            if (_value[n]) {
                              selectedStatus.add(statusList[n]);
                            }
                          }
                          insertData(
                              macList[i], tempList[i], num, i, selectedStatus,getRoomTempData(result.advertisementData.manufacturerData),);
                          Navigator.of(context).pop();
                          return showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('確認成功'),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(top: 16),
                                        child: Row(
                                          children: <Widget>[
                                            Text("編號：" + num),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 16),
                                        child: Row(
                                          children: <Widget>[
                                            Text("姓名：" + name),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 16),
                                        child: Row(
                                          children: <Widget>[
                                            Text("量測溫度：" + data),
                                          ],
                                        ),
                                      ),
                                      if (selectedStatus.length != 0)
                                        Padding(
                                          padding: EdgeInsets.only(top: 16),
                                          child: Text(
                                            "狀態：" + selectedStatus.join(","),
                                          ),
                                        ),
                                      if (selectedStatus.length == 0)
                                        Padding(
                                          padding: EdgeInsets.only(top: 16),
                                          child: Text(
                                            "狀態：無狀態",
                                          ),
                                        )
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          print("並未配對成功");
                          Navigator.of(context).pop();
                          return showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('未配對成功'),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: <Widget>[
                                        Text("還並未配對"),
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

    return FutureBuilder<String>(
      future: downloadData(macList), // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        // AsyncSnapshot<Your object type>
        List<Widget> list = new List<Widget>();
        if (snapshot.hasData) {
          if (tagis(result.advertisementData.manufacturerData,
                  result.advertisementData.serviceData, macList[0]) ==
              true) {
//            for (var i = 0; i < macL.length; i++) {
//              if (macL.length <= 0) {
//                macL.add(macList[0]);
//              } else if (macL[i] != macList[0]) {
//                macL.add(macList[0]);
//              }
//            }
            //print(macList);
            macL.clear();
            m.clear();
            for (var i = 0; i < macList.length; i++) {
              if (macL.length <= 0) {
                macL.add(macList[0]);
              } else {
                for (var x = 0; x < macL.length; x++) {
                  if (macL[x] != macList[0]) {
                    macL.add(macList[0]);
                  }
                }
              }
              if (checkData.length <= 0) {
                list.add(
                  new Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.25,
                    child: Container(
                      color: Colors.white,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.indigoAccent,
                          child: Icon(Icons.person),
                          foregroundColor: Colors.white,
                        ),
                        trailing: Text(
                          tempList[i],
                          style: TextStyle(
                            fontSize: 24,
                          ),
                          textAlign: TextAlign.right,
                        ),
                        title: Text(
                          nameList.length <= 0 ? "" : nameList[i],
//                      title(allData[i].mac.toString(),macList[i],allData[i].name.toString()),
                          style: TextStyle(
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        subtitle: Text(
                          numList.length <= 0 ? "" : numList[i],
//                      id(allData[i].mac.toString(),macList[i],allData[i].employeeID.toString()),
                          style: TextStyle(
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        caption: '確認',
                        color: Color(0xFF81E9E6),
                        icon: Icons.check_circle,
                        onTap: () => createConfirmDataAlertDialog(
                            context, nameList[i], tempList[i], numList[i], i),
                      ),
                      IconSlideAction(
                          caption: '配對',
                          color: Colors.blue,
                          icon: Icons.settings_ethernet,
                          onTap: () async => {
                                await createConnectPeopleAlertDialog(
                                    context,
                                    nameList[i].toString(),
                                    macList[i].toString(),
                                    tempList[i].toString(),
                                    numList[i].toString()),
                                await print("lev"),
                                await setState(() {}),
                              }),
                    ],
                  ),
                );
              } else {
                bool find = false;
                print(checkData);
                print(macList);
                for (var j = 0; j < checkData.length; j++) {
                  if (macList[0] == checkData[j]) {
                    find = true;
                    break;
                  }
                }
                if (!find) {
                  list.add(
                    new Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.25,
                      child: Container(
                        color: Colors.white,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.indigoAccent,
                            child: Icon(Icons.person),
                            foregroundColor: Colors.white,
                          ),
                          trailing: Text(
                            tempList[i],
                            style: TextStyle(
                              fontSize: 24,
                            ),
                            textAlign: TextAlign.right,
                          ),
                          title: Text(
                            nameList.length <= 0 ? "" : nameList[i],
//                      title(allData[i].mac.toString(),macList[i],allData[i].name.toString()),
                            style: TextStyle(
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          subtitle: Text(
                            numList.length <= 0 ? "" : numList[i],
//                      id(allData[i].mac.toString(),macList[i],allData[i].employeeID.toString()),
                            style: TextStyle(
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          caption: '確認',
                          color: Color(0xFF81E9E6),
                          icon: Icons.check_circle,
                          onTap: () => createConfirmDataAlertDialog(
                              context, nameList[i], tempList[i], numList[i], i),
                        ),
                        IconSlideAction(
                            caption: '配對',
                            color: Colors.blue,
                            icon: Icons.settings_ethernet,
                            onTap: () async => {
                                  await createConnectPeopleAlertDialog(
                                      context,
                                      nameList[i].toString(),
                                      macList[i].toString(),
                                      tempList[i].toString(),
                                      numList[i].toString()),
                                  await print("lev"),
                                  await setState(() {}),
                                }),
                      ],
                    ),
                  );
                }
              }
            }
          }
          return new Column(children: list);
        } else {
//          return CircularProgressIndicator();
          return new Column();
        }
      },
    );
  }

  createConnectPeopleAlertDialog(
      BuildContext context, String name, String mac, String temp, String num) {
    TextEditingController editNameController = new TextEditingController();
    TextEditingController editNumController = new TextEditingController();
//    editNameController.text = name;
//    editNumController.text = num;
    if (num == '0') {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("人員配對"),
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
                        String editName = editNameController.text;
                        String editNumber = editNumController.text;
                        if (editName != "") {
                          Navigator.of(context).pop();
                          debugPrint(name);
                          if (editNumber != "") {
                            employee data = new employee(
                                employeeID: editNumber,
                                name: editName,
                                mac: mac);
                            String result = await helper.insertData(data);
                            await nameList.clear();
                            await numList.clear();
                            print("insert");
                            await setState(() {});

                            if (result == "請檢查資料") {
                              return showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('配對失敗'),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Text("人員編號重複，請重新新增"),
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
                                    title: Text('配對成功'),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Text("姓名：" + editName),
                                          Text("編號：" + editNumber),
                                          Text("MAC Address：" + mac),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
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
    } else {
      print("已配對");
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('人員已配對'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text("已配對"),
                  ],
                ),
              ),
            );
          });
    }
  }

  double bytesToFloat(b0, b1, b2, b3) {
//    int mantissa = unsignedToSigned(b0 + (b1 << 8) + (b2 << 16), 24);
    b3 = -2;
    int mantissa = unsignedToSigned(
        unsignedByteToInt(b0) +
            (unsignedByteToInt(b1) << 8) +
            (unsignedByteToInt(b2) << 16),
        24);
    //(mantissa * pow(10, int.parse(b3)))
    return (mantissa * pow(10, b3));
  }

  int unsignedByteToInt(b) {
    return b & 0xFF;
  }

  int unsignedToSigned(int unsigned, int size) {
    if ((unsigned & (1 << size - 1)) != 0) {
      unsigned = -1 * ((1 << size - 1) - (unsigned & ((1 << size - 1) - 1)));
    }
    return unsigned;
  }
}

class StatusBox extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StatusBoxState();
  }
}

List<bool> _value = [
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false
];
List<String> statusList = [
  '發燒',
  '乾咳',
  '倦怠',
  '有痰',
  '呼吸急促',
  '肌肉或關節痛',
  '喉嚨痛',
  '頭痛',
  '發冷',
  '噁心嘔吐'
];

class StatusBoxState extends State<StatusBox> {
  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();

    List<Widget> list = new List<Widget>();

    for (var i = 0; i < statusList.length; i++) {
      _valueChanged(bool value) {
        _value[i] = false;
        setState(() {
          _value[i] = value;
        });
        print(_value.join(","));
      }

      list.add(
        new CheckboxListTile(
          value: _value[i],
          onChanged: _valueChanged,
          title: new Text(statusList[i]),
          controlAffinity: ListTileControlAffinity.leading,
          activeColor: appColor,
        ),
      );
    }

    return new Column(children: list);
  }
}

//getData() async {
//  sqlhelper helper = new sqlhelper();
//  print(await helper.showEmployee());
//  return await helper.showLastTemp();
//}

//class _MyHomePageState extends State<ScanResultTile> {
//  List<String> items;
//
//  _MyHomePageState(this.items);
//
//  @override
//  Widget build(BuildContext context) {
//    return new Scaffold(
//      body: ListView.builder(
//        itemCount: items.length,
//        itemBuilder: (context, index) {
//          final item = items[index];
//          return GestureDetector(
//              onTap: () {
//                items.removeAt(index);
//                setState(() {});
//              },
//              child: new ListTile(
//                title: new Text("$item"),
//              ));
//        },
//      ),
//    );
//  }
//}

/*
class ServiceTile extends StatelessWidget {
  final BluetoothService service;
  final List<CharacteristicTile> characteristicTiles;

  const ServiceTile({Key key, this.service, this.characteristicTiles})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (characteristicTiles.length > 0) {
      return ExpansionTile(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Service'),
            Text('0x${service.uuid.toString().toUpperCase().substring(4, 8)}',
                style: Theme.of(context)
                    .textTheme
                    .body1
                    .copyWith(color: Theme.of(context).textTheme.caption.color))
          ],
        ),
        children: characteristicTiles,
      );
    } else {
      return ListTile(
        title: Text('Service'),
        subtitle:
        Text('0x${service.uuid.toString().toUpperCase().substring(4, 8)}'),
      );
    }
  }
}

class CharacteristicTile extends StatelessWidget {
  final BluetoothCharacteristic characteristic;
  final List<DescriptorTile> descriptorTiles;
  final VoidCallback onReadPressed;
  final VoidCallback onWritePressed;
  final VoidCallback onNotificationPressed;

  const CharacteristicTile(
      {Key key,
        this.characteristic,
        this.descriptorTiles,
        this.onReadPressed,
        this.onWritePressed,
        this.onNotificationPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<int>>(
      stream: characteristic.value,
      initialData: characteristic.lastValue,
      builder: (c, snapshot) {
        final value = snapshot.data;
        return ExpansionTile(
          title: ListTile(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Characteristic'),
                Text(
                    '0x${characteristic.uuid.toString().toUpperCase().substring(4, 8)}',
                    style: Theme.of(context).textTheme.body1.copyWith(
                        color: Theme.of(context).textTheme.caption.color))
              ],
            ),
            subtitle: Text(value.toString()),
            contentPadding: EdgeInsets.all(0.0),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.file_download,
                  color: Theme.of(context).iconTheme.color.withOpacity(0.5),
                ),
                onPressed: onReadPressed,
              ),
              IconButton(
                icon: Icon(Icons.file_upload,
                    color: Theme.of(context).iconTheme.color.withOpacity(0.5)),
                onPressed: onWritePressed,
              ),
              IconButton(
                icon: Icon(
                    characteristic.isNotifying
                        ? Icons.sync_disabled
                        : Icons.sync,
                    color: Theme.of(context).iconTheme.color.withOpacity(0.5)),
                onPressed: onNotificationPressed,
              )
            ],
          ),
          children: descriptorTiles,
        );
      },
    );
  }
}

class DescriptorTile extends StatelessWidget {
  final BluetoothDescriptor descriptor;
  final VoidCallback onReadPressed;
  final VoidCallback onWritePressed;

  const DescriptorTile(
      {Key key, this.descriptor, this.onReadPressed, this.onWritePressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Descriptor'),
          Text('0x${descriptor.uuid.toString().toUpperCase().substring(4, 8)}',
              style: Theme.of(context)
                  .textTheme
                  .body1
                  .copyWith(color: Theme.of(context).textTheme.caption.color))
        ],
      ),
      subtitle: StreamBuilder<List<int>>(
        stream: descriptor.value,
        initialData: descriptor.lastValue,
        builder: (c, snapshot) => Text(snapshot.data.toString()),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.file_download,
              color: Theme.of(context).iconTheme.color.withOpacity(0.5),
            ),
            onPressed: onReadPressed,
          ),
          IconButton(
            icon: Icon(
              Icons.file_upload,
              color: Theme.of(context).iconTheme.color.withOpacity(0.5),
            ),
            onPressed: onWritePressed,
          )
        ],
      ),
    );
  }
}

class AdapterStateTile extends StatelessWidget {
  const AdapterStateTile({Key key, @required this.state}) : super(key: key);

  final BluetoothState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.redAccent,
      child: ListTile(
        title: Text(
          'Bluetooth adapter is ${state.toString().substring(15)}',
          style: Theme.of(context).primaryTextTheme.subhead,
        ),
        trailing: Icon(
          Icons.error,
          color: Theme.of(context).primaryTextTheme.subhead.color,
        ),
      ),
    );
  }
}
*/
