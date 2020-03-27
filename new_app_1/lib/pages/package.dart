// Copyright 2017, Paul DeMarco.
// All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:newapp1/pages/people_screen.dart';
import 'DB/sqlhelper.dart';
import 'DB/employee_model.dart';
import 'DB/temperature_model.dart';


class ScanResultTile extends StatelessWidget {
  const ScanResultTile({Key key, this.result, this.onTap}) : super(key: key);

  final ScanResult result;
  final VoidCallback onTap;

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

          //MacAdress
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

  Widget getTempWidgets(List<String> nameL, List<String> tempL, List<String> numberL) {
    List<Widget> list = new List<Widget>();
    for (var i = 0; i < nameL.length; i++) {
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
                  fontSize: 32,
                ),
                textAlign: TextAlign.right,
              ),
              title: Text(
                nameL[i],
                style: TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.left,
              ),
              subtitle: Text(
                numberL[i],
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
//              onTap: () => _showSnackBar('Archive'),
            ),
            IconSlideAction(
              caption: '刪除',
              color: Colors.red,
              icon: Icons.delete,
//                onTap: () => _showSnackBar('Delete'),
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

  String transValue(correct,bytes) {
    String t ='${bytes.map((i) => i.toRadixString(16).padLeft(2, '0')).join(', ')}'
        .toUpperCase();
    var data1,data2,data3,data4,pid,check1,check2;
    check1 = bytes.elementAt(0).toRadixString(16).padLeft(2, '0').toUpperCase().toString();
    check2 = bytes.elementAt(1).toRadixString(16).padLeft(2, '0').toUpperCase().toString();
    pid = bytes.elementAt(2).toRadixString(16).padLeft(2, '0').toUpperCase().toString();
    if(correct=='8796' && check1 == '59' && check2 == '80' && pid == '03'){
      data1 = bytes.elementAt(4).toRadixString(16).padLeft(2, '0').toUpperCase().toString();
      data2 = bytes.elementAt(5).toRadixString(16).padLeft(2, '0').toUpperCase().toString();
      data3 = bytes.elementAt(6).toRadixString(16).padLeft(2, '0').toUpperCase().toString();
      data4 = bytes.elementAt(7).toRadixString(16).padLeft(2, '0').toUpperCase().toString();
      double tem = bytesToFloat(toRadix(data1), toRadix(data2), toRadix(data3), toRadix(data4));//decodeTempLevel(data,0);
      return tem.toString();//+data2+data3+data4
    }else{
      return correct;
    }
  }

  String checkAddress(correct,bytes) {
    var pid,check1,check2;
    check1 = bytes.elementAt(0).toRadixString(16).padLeft(2, '0').toUpperCase().toString();
    check2 = bytes.elementAt(1).toRadixString(16).padLeft(2, '0').toUpperCase().toString();
    pid = bytes.elementAt(2).toRadixString(16).padLeft(2, '0').toUpperCase().toString();
    return correct+check1+check2+pid;
  }

  String transTemp(bytes) {
    var data1,data2,data3,data4,data;
    data = bytes.split(',');
    data1 = data[0].trim();//trim():將字符串兩邊去除空格處理
    data2 = data[1].trim();
    data3 = data[2].trim();
    data4 = data[3].trim();
    print(data1);
    print(data2);
    print(data3);
    print(data4);
    double tem = bytesToFloat(toRadix(data1), toRadix(data2), toRadix(data3), toRadix(data4));//decodeTempLevel(data,0);
    return tem.toString();//+data2+data3+data4
  }

  int toRadix(x) {
    var first,sec;
    first = x.substring(0,1);
    switch (first) {
      case 'F':{
        first = 15;
      }break;
      case 'E':{
        first = 14;
      }break;
      case 'D':{
        first = 13;
      }break;
      case 'C':{
        first = 12;
      }break;
      case 'B':{
        first = 11;
      }break;
      case 'A':{
        first = 10;
      }break;
      default:{
        first = int.parse(first);
      }
    }
    sec = x.substring(1,2);
    switch (sec) {
      case 'F':{
        sec = 15;
      }break;
      case 'E':{
        sec = 14;
      }break;
      case 'D':{
        sec = 13;
      }break;
      case 'C':{
        sec = 12;
      }break;
      case 'B':{
        sec = 11;
      }break;
      case 'A':{
        sec = 10;
      }break;
      default:{
        sec = int.parse(sec);
      }
    }
    var ans = first*16+sec;
    return ans & 0xFF;
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
      res.add(
          '${transValue(c,bytes)}');
    });
    return res.join(', ');
  }

  //取得體溫資料
  String getBodyTempData(Map<String, List<int>> data) {//String
    if (data.isEmpty) {
      return null;
    }
    List<String> res = [];
//    res.add('${trans(data[1])}');
    data.forEach((id, bytes) {
      res.add('${trans(bytes)}');//${id.toUpperCase()}  ${getNiceHexArray(bytes)}
    });
    return res.elementAt(0);
  }

  //取得溫度資料
  String getTempData(Map<int, List<int>> data1,Map<String, List<int>> data2){
    var check;
    List<String> res1 = [],res2 = [];
    data1.forEach((id, bytes) {
      var c = '${id.toRadixString(16).toUpperCase()}';
      check = '${checkAddress(c,bytes)}';
      res1.add(
          '${checkAddress(c,bytes)}');
    });
    data2.forEach((id, bytes) {
      res2.add('${trans(bytes)}');//${id.toUpperCase()}  ${getNiceHexArray(bytes)}
    });
    if(check == '8796598003'){
      return transTemp(res2.elementAt(1));
    }else{
      return res1.elementAt(0);
    }
  }

  //取得服務資料
  String getNiceServiceData(Map<String, List<int>> data) {//String
    if (data.isEmpty) {
      return null;
    }
    List<String> res = [];
    data.forEach((id, bytes) {
      res.add('${id.toUpperCase()}: ${getNiceHexArray(bytes)}');//${id.toUpperCase()}  ${getNiceHexArray(bytes)}
    });
    return res.join(', ');
  }

  Future<void> searchData(List<String> nameL, List<String> tempL, List<String> numberL) async {
      sqlhelper sqlhepler = new sqlhelper();
      List a = await sqlhepler.showEmployee();
      return a;
  }

  Future<void> insertData(List<String> nameL, List<String> tempL, List<String> numberL,int i) async {
    sqlhelper sqlhepler = new sqlhelper();
    var a= await sqlhepler.searchEmployeeMAC(nameL[i]);
    temperature  data=new temperature (id:a[0].id,temp:tempL[i],time:"2020-01-23 19:00:00");
    await sqlhepler.insertData(data);
    print(await sqlhepler.showtemperature());
  }

  @override
  Widget build(BuildContext context) {
//    var appColor;
    List<String> nameList = [];
    List<String> tempList = [];
    List<String> numList = [];
    nameList.clear();
    tempList.clear();
    numList.clear();
    nameList.add(result.device.id.toString());
    tempList.add(getTempData(result.advertisementData.manufacturerData,result.advertisementData.serviceData));
    numList.add(result.rssi.toString());
    print(nameList);print(tempList);print(numList);

    createConfirmDataAlertDialog(BuildContext context, String name, String data, String num,int i) {
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
                  ],
                ),
              ),
              actions: <Widget>[
                new ButtonBar(
                  children: <Widget>[
                    new FlatButton(
                      child: Text('確認'),
                      // ignore: missing_return
                      onPressed: () {
                        insertData(nameList,tempList,numList,i);
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

    List<Widget> list = new List<Widget>();
    for (var i = 0; i < nameList.length; i++) {
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
                nameList[i],
                style: TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.left,
              ),
              subtitle: Text(
                numList[i],
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
              onTap: () =>  createConfirmDataAlertDialog(
                  context, nameList[i], tempList[i], numList[i],i),
            ),
//            IconSlideAction(
//              caption: '刪除',
//              color: Colors.red,
//              icon: Icons.delete,
//                onTap: () => print("456"),
//            ),
          ],
        ),
      );
    }
    return new Column(children: list);

//    return ExpansionTile(
//      title: _buildTitle(context),//Text(result.device.id.toString()),//_buildTitle(context),
//      leading: getTempWidgets(nameList,tempList,numList),//Text(result.rssi.toString()),
//      trailing:Text(getTempData(result.advertisementData.manufacturerData,result.advertisementData.serviceData)),
////      RaisedButton(
////        child: Text('CONNECT'),
////        color: Colors.black,
////        textColor: Colors.white,
////        onPressed: (result.advertisementData.connectable) ? onTap : null,
////      ),
//      children: <Widget>[
//        AlertDialog(//提示框组件
//          title: Text("體溫測量"),
//          content:Text("員工編號:"+ "123"+"\n姓名:" + "Ivy"+"\n量測體溫:"+getTempData(result.advertisementData.manufacturerData,result.advertisementData.serviceData)),
//          actions: <Widget>[
//            new ButtonBar(
//              children: <Widget>[
//                new FlatButton(
//                  child: Text(
//                    '確認',
//                    style: new TextStyle(color: appColor),
//                  ),
//                  onPressed: () {
//                    Navigator.of(context).pop();
//                  },
//                ),
//                new FlatButton(
//                  child: Text(
//                    '取消',
//                    style: new TextStyle(color: appColor),
//                  ),
//                  onPressed: () {
//                    Navigator.of(context).pop();
//                  },
//                )
//              ],
//            ),
//          ],
//        ),
//        getTempWidgets(nameList,tempList,numList),
////        _buildAdvRow(
////            context, 'Complete Local Name', result.advertisementData.localName),
////        _buildAdvRow(context, 'Tx Power Level',
////            '${result.advertisementData.txPowerLevel ?? 'N/A'}'),
////        _buildAdvRow(
////            context,
////            'Manufacturer Data',
////            getNiceManufacturerData(
////                result.advertisementData.manufacturerData) ?? //getNiceManufacturerData(result.advertisementData.manufacturerData)
////                'N/A'),
////        _buildAdvRow(
////            context,
////            'Service UUIDs',
////            (result.advertisementData.serviceUuids.isNotEmpty)
////                ? result.advertisementData.serviceUuids.join(', ').toUpperCase()
////                : 'N/A'),
////        _buildAdvRow(context, 'Service Data',
////            getNiceServiceData(result.advertisementData.serviceData) ?? 'N/A'),
////        _buildAdvRow(
////            context,
////            'Room temp Data',
////            getRoomTempData(
////                result.advertisementData.manufacturerData) ?? //getNiceManufacturerData(result.advertisementData.manufacturerData)
////                'N/A'),
////        _buildAdvRow(context, 'Body temp Data',
////            getBodyTempData(result.advertisementData.serviceData) ?? 'N/A'),
////        _buildAdvRow(context, 'temp Data',
////            getTempData(result.advertisementData.manufacturerData,result.advertisementData.serviceData) ?? 'N/A'),
//      ],
//
//    );
  }

  double bytesToFloat(b0,b1,b2,b3) {
//    int mantissa = unsignedToSigned(b0 + (b1 << 8) + (b2 << 16), 24);
    b3 = -2;
    int mantissa = unsignedToSigned(unsignedByteToInt(b0) + (unsignedByteToInt(b1) << 8) + (unsignedByteToInt(b2) << 16), 24);
    //(mantissa * pow(10, int.parse(b3)))
    return (mantissa * pow(10,b3));
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