// Copyright 2017, Paul DeMarco.
// All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';
import 'dart:math';

import 'package:Tem_Tracker/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:Tem_Tracker/pages/people_screen.dart';
import '../DB/sqlhelper.dart';
import '../DB/employee_model.dart';
import '../DB/temperature_model.dart';
import 'package:Tem_Tracker/app_localizations.dart';
import './functionmap.dart';

List<Map<String, dynamic>> timesData = [{}];
List<String> statusList;

listTranslate() {
  if (currentLang == "zh") {
    statusList = [
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
  } else {
    statusList = [
      'Fever',
      'Cough',
      'Tired',
      'Sputum',
      'Shortness of Breath',
      'Muscle or Joint Pain',
      'Sore throat',
      'Headache',
      'Chills',
      'Nausea and Vomiting'
    ];
  }
}

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
              title: Text(AppLocalizations.of(context)
                      .translate('alertDialog_person_pairing') //"人員配對確認"
                  ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Row(
                        children: <Widget>[
                          Text(AppLocalizations.of(context)
                                  .translate('staff_num') + //"編號："
                              "：" +
                              rssi),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Row(
                        children: <Widget>[
                          Text(AppLocalizations.of(context)
                                  .translate('staff_name') + //"姓名："
                              "：" +
                              mac),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Row(
                        children: <Widget>[
                          Text(AppLocalizations.of(context).translate(
                                  'alertDialog_measuring_temperature') + //"量測溫度："
                              "：" +
                              data),
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
                      child: Text(AppLocalizations.of(context)
                              .translate('alertDialog_confirm') //'確認'
                          ),
                      onPressed: () async {
                        await insertData(
                          macL,
                          tempL,
                          rssiL,
                          i,
                          statusList,
                          getRoomTempData(
                              result.advertisementData.manufacturerData),
                        );
                        Navigator.of(context).pop();
                        return showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                  AppLocalizations.of(context).translate(
                                      'alertDialog_confirm_success') //'確認成功'
                                  ),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(top: 16),
                                      child: Row(
                                        children: <Widget>[
                                          Text(AppLocalizations.of(context)
                                                  .translate(
                                                      'staff_num') + //"編號："
                                              "：" +
                                              rssi),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 16),
                                      child: Row(
                                        children: <Widget>[
                                          Text(AppLocalizations.of(context)
                                                  .translate(
                                                      'staff_name') + //"姓名："
                                              "：" +
                                              mac),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 16),
                                      child: Row(
                                        children: <Widget>[
                                          Text(AppLocalizations.of(context)
                                                  .translate(
                                                      'alertDialog_measuring_temperature') + //"量測溫度："
                                              "：" +
                                              data),
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
                        AppLocalizations.of(context)
                            .translate('alertDialog_cancel') //'取消'
                        ,
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
              caption: AppLocalizations.of(context)
                  .translate('alertDialog_confirm') //'確認'
              ,
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

  Future<String> searchData() async {
    sqlhelper sqlhepler = new sqlhelper();
    List a = await sqlhepler.showEmployee();
    return a[0].name;
  }

  Future<void> insertData(macL, tempL, rssiL, int i, List s, roomTemp) async {
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
        roomTemp: roomTemp,
        temp: tempL,
        time: getCurrentDate().toString(),
        symptom: s.join("、"));
    timesData
        .add({"id": a[0], "temp": tempL, "time": getCurrentDate().toString()});
    //print(getCurrentDate());
    await sqlhepler.insertData(data);
//    print(await sqlhepler.showtemperature());
  }

  Future<String> downloadData(macList) async {
    sqlhelper helper = new sqlhelper();
//    if (tagis(result.advertisementData.manufacturerData,
//            result.advertisementData.serviceData, macList[0]) ==
//        true) {
    var a = await helper.searchEmployeeMAC(macList[0].toString());
    print(a);
    if (a.length != 0) {
      await nameList.add(a[0].name.toString());
      await numList.add(a[0].employeeID);
    } else {
      await nameList.add(macList[0].toString());
      await numList.add("");
    }
//    }
//    await nameList.add(macList[0].toString());
//    await numList.add("0");
//      print(macList);
    return Future.value("Get Data"); // return your response
  }

  @override
  Widget build(BuildContext context) {
    List<String> tempList = [];
    List<String> rssiList = [];
    List<String> macList = [];
    List<String> m = [];
    //bool turn = true;

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
              title: Text(AppLocalizations.of(context)
                      .translate('alertDialog_update') //"量測確認"
                  ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Row(
                        children: <Widget>[
                          Text(AppLocalizations.of(context)
                                  .translate('staff_num') + //"編號："
                              "：" +
                              num),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Row(
                        children: <Widget>[
                          Text(AppLocalizations.of(context)
                                  .translate('staff_name') + //"姓名："
                              "：" +
                              name),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Row(
                        children: <Widget>[
                          Text(AppLocalizations.of(context).translate(
                                  'alertDialog_measuring_temperature') + //"量測溫度："
                              "：" +
                              data),
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
                      child: Text(AppLocalizations.of(context)
                              .translate('alertDialog_confirm') //'確認'
                          ),
                      onPressed: () async {
                        //setState(){};
                        if (name != '') {
                          //setState(){};
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
                          await insertData(
                            macList[i],
                            tempList[i],
                            num,
                            i,
                            selectedStatus,
                            getRoomTempData(
                                result.advertisementData.manufacturerData),
                          );
                          Navigator.of(context).pop();
                          setState(() {});
                          return showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(
                                    AppLocalizations.of(context).translate(
                                        'alertDialog_confirm_success') //'確認成功'
                                    ),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(top: 16),
                                        child: Row(
                                          children: <Widget>[
                                            Text(AppLocalizations.of(context)
                                                    .translate(
                                                        'staff_num') + //"編號："
                                                "：" +
                                                num),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 16),
                                        child: Row(
                                          children: <Widget>[
                                            Text(AppLocalizations.of(context)
                                                    .translate(
                                                        'staff_name') + //"姓名："
                                                "：" +
                                                name),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 16),
                                        child: Row(
                                          children: <Widget>[
                                            Text(AppLocalizations.of(context)
                                                    .translate(
                                                        'alertDialog_measuring_temperature') + //"量測溫度："
                                                "：" +
                                                data),
                                          ],
                                        ),
                                      ),
                                      if (selectedStatus.length != 0)
                                        Padding(
                                          padding: EdgeInsets.only(top: 16),
                                          child: Text(
                                            AppLocalizations.of(context)
                                                    .translate(
                                                        'staff_status') //"狀態："
                                                +
                                                ":" +
                                                selectedStatus.join(", "),
                                          ),
                                        ),
                                      if (selectedStatus.length == 0)
                                        Padding(
                                          padding: EdgeInsets.only(top: 16),
                                          child: Text(
                                            AppLocalizations.of(context)
                                                    .translate(
                                                        'staff_status') //"狀態："
                                                +
                                                ":" +
                                                AppLocalizations.of(context)
                                                    .translate(
                                                        'staff_no_status'), //無狀態
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
                                  title: Text(
                                      AppLocalizations.of(context).translate(
                                          'alertDialog_person_pairing') //'未配對成功'
                                      ),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: <Widget>[
                                        Text(
                                            AppLocalizations.of(context).translate(
                                                'alertDialog_not_paired_yet') //"還並未配對"
                                            ),
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
                        AppLocalizations.of(context)
                            .translate('alertDialog_cancel') //'取消'
                        ,
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
        print(snapshot);
        if (snapshot.hasData) {
          if (tagis(result.advertisementData.manufacturerData,
                  result.advertisementData.serviceData, macList[0]) &&
              nameList.length > 0) {
            print(list);
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
                if (nameList[i] == macList[0]) {
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
                            caption: AppLocalizations.of(context)
                                .translate('alertDialog_pair'), //'配對',
                            color: Colors.blue,
                            icon: Icons.settings_ethernet,
                            onTap: () async => {
                                  await createConnectPeopleAlertDialog(
                                      context,
                                      nameList[i].toString(),
                                      macList[0].toString(),
                                      tempList[i].toString(),
                                      numList[i].toString()),
                                  await print("lev"),
                                  await setState(() {}),
                                }),
                      ],
                    ),
                  );
                } else if (nameList[i] != macList[0]) {
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
                          caption: AppLocalizations.of(context)
                              .translate('alertDialog_confirm'), //'確認',
                          color: Color(0xFF81E9E6),
                          icon: Icons.check_circle,
                          onTap: () => createConfirmDataAlertDialog(
                              context, nameList[i], tempList[i], numList[i], i),
                        ),
                      ],
                    ),
                  );
                }
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
                  if (nameList[i] == macList[0]) {
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
                              numList.length <= 0 ? "hh" : numList[i],
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
                              caption: AppLocalizations.of(context)
                                  .translate('alertDialog_pair'), //'配對',
                              color: Colors.blue,
                              icon: Icons.settings_ethernet,
                              onTap: () async => {
                                    await createConnectPeopleAlertDialog(
                                        context,
                                        nameList[i].toString(),
                                        macList[0].toString(),
                                        tempList[i].toString(),
                                        numList[i].toString()),
                                    await print("lev"),
                                    await setState(() {}),
                                  }),
                        ],
                      ),
                    );
                  } else if (nameList[i] != macList[0]) {
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
                            caption: AppLocalizations.of(context)
                                .translate('alertDialog_confirm'), //'確認',
                            color: Color(0xFF81E9E6),
                            icon: Icons.check_circle,
                            onTap: () => createConfirmDataAlertDialog(context,
                                nameList[i], tempList[i], numList[i], i),
                          ),
                        ],
                      ),
                    );
                  }
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
    if (num == '') {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context)
                      .translate('alertDialog_person_pairing') //"人員配對"
                  ),
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
                                labelText: AppLocalizations.of(context)
                                    .translate('staff_num'), //'編號',
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
                                labelText: AppLocalizations.of(context)
                                    .translate('staff_name'), //'姓名',
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
                      child: Text(AppLocalizations.of(context)
                              .translate('alertDialog_confirm') //'確認'
                          ),
                      // ignore: missing_return
                      onPressed: () async {
                        sqlhelper helper = new sqlhelper();
                        String editName = editNameController.text;
                        String editNumber = editNumController.text;
                        if (editName != "") {
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
                            Navigator.of(context).pop();
                            if (result == "請檢查資料") {
                              return showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(
                                        AppLocalizations.of(context).translate(
                                            'alertDialog_pairing_failed') //'配對失敗'
                                        ),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Text(AppLocalizations.of(context)
                                                  .translate(
                                                      'toast_repeat_tag') //"人員編號重複，請重新新增"
                                              ),
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
                                    title: Text(
                                        AppLocalizations.of(context).translate(
                                            'alertDialog_paired_success') //'配對成功'
                                        ),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Text(AppLocalizations.of(context)
                                                  .translate(
                                                      'staff_name') + //"姓名："
                                              "：" +
                                              editName),
                                          Text(AppLocalizations.of(context)
                                                  .translate(
                                                      'staff_num') + //"編號："
                                              "：" +
                                              editNumber),
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
                                          Text(AppLocalizations.of(context)
                                                  .translate(
                                                      'alertDialog_please_enter_the_number') //"請輸入編號"
                                              ),
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
                                        Text(
                                            AppLocalizations.of(context).translate(
                                                'alertDialog_please_enter_your_name') //"請輸入姓名"
                                            ),
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
                        AppLocalizations.of(context)
                            .translate('alertDialog_cancel') //'取消'
                        ,
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
              title: Text(
                  AppLocalizations.of(context).translate('toast_pair') //'人員已配對'
                  ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(AppLocalizations.of(context)
                            .translate('toast_pair') //"已配對"
                        ),
                  ],
                ),
              ),
            );
          });
    }
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

class StatusBoxState extends State<StatusBox> {
  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();

    List<Widget> list = new List<Widget>();
    listTranslate();

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
