// Copyright 2017, Paul DeMarco.
// All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';
import 'dart:math';

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
//List allData;

class Scan extends StatefulWidget {
  Scan({Key key, this.result, this.onTap}) : super(key: key);

  final ScanResult result;
  final VoidCallback onTap;

//  final String na;
//  final String id;
//  final List<String> items;

  //必需重写createState方法
  @override
  ScanResultTile createState() => new ScanResultTile(result, onTap);
}

class ScanResultTile extends State<Scan> {
  ScanResult result;
  VoidCallback onTap;

  ScanResultTile(this.result, this.onTap);

  List<String> numList = [];
  List<String> macL = [];
  List<String> nameList = [];

  Future<String> searchData() async {
    sqlhelper sqlhepler = new sqlhelper();
    List a = await sqlhepler.showEmployee();
    return a[0].name;
  }

  Future<void> insertData(macL, tempL, rssiL, int i) async {
    sqlhelper sqlhepler = new sqlhelper();
    var a = await sqlhepler.searchEmployeeMAC(macL[i]);
    temperature data =
        new temperature(id: a[0].id, temp: tempL[i], time: getCurrentDate());
    await sqlhepler.insertData(data);
//    print(await sqlhepler.showtemperature());
  }

  Future<String> downloadData(macList) async {
    sqlhelper helper = new sqlhelper();
    if (tagis(result.advertisementData.manufacturerData,
            result.advertisementData.serviceData, macList[0]) ==
        true) {
      var a = await helper.searchEmployeeMAC(macList[0].toString());
      print(a);
      if (a.length != 0) {
        nameList.add(a[0].name.toString());
        numList.add(a[0].employeeID);
      } else {
        nameList.add(macList[0].toString());
        numList.add("0");
      }
    }
//      print(macList);
    print(macList);
    return Future.value("Get Data"); // return your response
  }

  @override
  Widget build(BuildContext context) {
    List<String> tempList = [];
    List<String> rssiList = [];
    List<String> macList = [];
    macList.add(result.device.id.toString());
    tempList.add(getTempData(result.advertisementData.manufacturerData,
        result.advertisementData.serviceData));
    rssiList.add(result.rssi.toString());

    createConfirmDataAlertDialog(BuildContext context, mac, int i) {
      debugPrint("Position:" + confirmPosition.toString());
      debugPrint("data:" + data[confirmPosition].toString());
      debugPrint("name:" + data[confirmPosition].name);
      debugPrint("employeeID:" + data[confirmPosition].employeeID);
      debugPrint("MAC:" + mac);

      String confirmEmployeeID;
      String confirmEmployeeName;

      confirmEmployeeID = data[confirmPosition].employeeID;
      confirmEmployeeName = data[confirmPosition].name;

      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context)
                      .translate('alertDialog_pairing_confirmation') //"配對確認"
                  ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(AppLocalizations.of(context)
                                  .translate('staff_num') + //"編號："
                              "：" +
                              confirmEmployeeID),
                          Text(AppLocalizations.of(context)
                                  .translate('staff_name') + //"姓名："
                              "：" +
                              confirmEmployeeName),
                          Text("Mac：" + mac),
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
                        Navigator.of(context).pop();
                        sqlhelper helper = new sqlhelper();
                        employee employeeData = new employee(
                            id: data[confirmPosition].id,
                            employeeID: confirmEmployeeID,
                            name: confirmEmployeeName,
                            mac: mac);
                        await helper.updateData(employeeData);
                        Navigator.of(context).pop();
                        return showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                  AppLocalizations.of(context).translate(
                                      'alertDialog_matching_result') //'配對結果'
                                  ),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Text(AppLocalizations.of(context).translate(
                                            'alertDialog_paired_success') //"配對成功"
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

    return FutureBuilder<String>(
      future: downloadData(macList), // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        // AsyncSnapshot<Your object type>
        List<Widget> list = new List<Widget>();
        if (snapshot.hasData) {
          if (tagis(result.advertisementData.manufacturerData,
                  result.advertisementData.serviceData, macList[0]) &&
              nameList.length > 0 &&
              macList.length > 0) {
            if (nameList[0] == macList[0]) {
              for (var i = 0; i < macList.length; i++) {
                list.add(
                  new Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.25,
                    child: Container(
                      color: Colors.white,
                      child: ListTile(
//                        leading: CircleAvatar(
//                          backgroundColor: Colors.indigoAccent,
//                          child: Icon(Icons.person),
//                          foregroundColor: Colors.white,
//                        ),
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
//                        subtitle: Text(
//                          numList.length <= 0 ? "" : numList[i],
//                          style: TextStyle(
//                            fontSize: 16,
//                          ),
//                          textAlign: TextAlign.left,
//                        ),
                      ),
                    ),
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        caption: AppLocalizations.of(context)
                            .translate('alertDialog_confirm'), //'確認'
                        color: Color(0xFF81E9E6),
                        icon: Icons.check_circle,
                        onTap: () => createConfirmDataAlertDialog(
                            context, macList[i], i),
                      ),
                    ],
                  ),
                );
              }
            }
          }
          return new Column(children: list);
        } else {
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
    print(1);
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
                                  .translate('staff_name'), //'姓名',
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
                              labelText: AppLocalizations.of(context)
                                  .translate('staff_num'), //'編號',
                            ),
                            controller: editNumController,
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
                      String n = editNameController.text;
                      String number = editNumController.text;
                      if (n != "") {
                        Navigator.of(context).pop();
                        debugPrint(name);
                        if (number != "") {
                          insertData(mac, temp, number, 0);
                          employee employeeData = new employee(
                              employeeID: number, name: n, mac: mac);
                          await helper.insertData(employeeData);
                          return showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Result'),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      Text(AppLocalizations.of(context)
                                              .translate('staff_name') + //"姓名："
                                          "：" +
                                          n),
                                      Text(AppLocalizations.of(context)
                                              .translate('staff_num') + //"編號："
                                          "：" +
                                          number),
                                      Text("Mac Address：" + mac),
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
                                        Text(
                                            AppLocalizations.of(context).translate(
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
  }
}
