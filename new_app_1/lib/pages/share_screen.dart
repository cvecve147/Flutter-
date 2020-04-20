import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:newapp1/pages/DB/employee_model.dart';
import 'package:newapp1/pages/DB/sqlhelper.dart';
import 'package:newapp1/pages/DB/temperature_model.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

Color appColor = Color(0xFF2A6FDB);
Color primaryColor = Color(0xFF122C91);

String startDate;
String endDate;

String twoDigit(int n) {
  if (n >= 10) return "$n";
  return "0$n";
}

createSelectShareDateAlertDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        startDate = "";
        endDate = "";
        return AlertDialog(
          title: Text("全體匯出"),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: RaisedButton(
                      color: appColor,
                      splashColor: Color(0xFF122C91),
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 40.0),
                          child: const Text('設定起始日期',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20))),
                      onPressed: () {
                        DatePicker.showDatePicker(context,
                            showTitleActions: true,
                            minTime:
                                DateTime.now().add(new Duration(days: -30)),
                            maxTime: DateTime.now(), onConfirm: (date) {
                          startDate = twoDigit(date.year) +
                              "-" +
                              twoDigit(date.month) +
                              "-" +
                              twoDigit(date.day);
                          print('confirm $date');
                        }, currentTime: DateTime.now(), locale: LocaleType.zh);
                      },
                    )),
                Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: RaisedButton(
                      color: appColor,
                      splashColor: Color(0xFF122C91),
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 40.0),
                          child: const Text('設定結束日期',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20))),
                      onPressed: () {
                        DatePicker.showDatePicker(context,
                            showTitleActions: true,
                            minTime:
                                DateTime.now().add(new Duration(days: -30)),
                            maxTime: DateTime.now(), onConfirm: (date) {
                          endDate = twoDigit(date.year) +
                              "-" +
                              twoDigit(date.month) +
                              "-" +
                              twoDigit(date.day + 1);
                          ;
                        }, currentTime: DateTime.now(), locale: LocaleType.zh);
                      },
                    )),
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
                    print("startDate:" + startDate);
                    print("endDate:" + endDate);
                    return showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("匯出日期確認"),
                            content: SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                      padding: EdgeInsets.only(top: 16),
                                      child: Text("確定要匯出資料嗎？")),
                                  Padding(
                                      padding: EdgeInsets.only(top: 16),
                                      child: Text("起始日期:" + startDate)),
                                  Padding(
                                      padding: EdgeInsets.only(top: 16),
                                      child: Text('|')),
                                  Padding(
                                      padding: EdgeInsets.only(top: 16),
                                      child: Text("結束日期:" + endDate)),
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
                                      Navigator.of(context).pop();
                                      List data = [startDate, endDate];
                                      sqlhelper helpler = new sqlhelper();
                                      await helpler.writeEmployeeToCsv(data);

                                      String result = await helpler
                                          .writeEmployeeToCsv(data);
                                      print(result);

                                      Navigator.of(context).pop();

                                      if (result == "匯出失敗") {
                                        print("匯出失敗");
                                        return showDialog(
                                          context: context,
                                          builder: (context) {
                                            return SimpleDialog(
                                              title: Text("匯出失敗"),
                                              children: <Widget>[
                                                Column(
                                                  children: <Widget>[
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 16),
                                                        child: Text("匯出失敗")),
                                                  ],
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      } else {
                                        print("匯出成功");
                                        return showDialog(
                                          context: context,
                                          builder: (context) {
                                            return SimpleDialog(
                                              title: Text("匯出成功"),
                                              children: <Widget>[
                                                Column(
                                                  children: <Widget>[
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 16),
                                                        child:
                                                            Text("匯出成功 路徑為")),
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                          top: 16,
                                                          left: 8,
                                                          right: 4,
                                                        ),
                                                        child: Text(result)),
                                                  ],
                                                ),
                                              ],
                                            );
                                          },
                                        );
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

createSelectPersonalShareDateAlertDialog(
    BuildContext context, int num, String name) {
  return showDialog(
      context: context,
      builder: (context) {
        startDate = "";
        endDate = "";
        return AlertDialog(
          title: Text("個人匯出"),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text("匯出" + name + "的資料")),
                Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: RaisedButton(
                      color: appColor,
                      splashColor: Color(0xFF122C91),
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 40.0),
                          child: const Text('設定起始日期',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20))),
                      onPressed: () {
                        DatePicker.showDatePicker(context,
                            showTitleActions: true,
                            minTime:
                                DateTime.now().add(new Duration(days: -30)),
                            maxTime: DateTime.now(), onConfirm: (date) {
                          startDate = twoDigit(date.year) +
                              "-" +
                              twoDigit(date.month) +
                              "-" +
                              twoDigit(date.day);
                          print('confirm $date');
                        }, currentTime: DateTime.now(), locale: LocaleType.zh);
                      },
                    )),
                Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: RaisedButton(
                      color: appColor,
                      splashColor: Color(0xFF122C91),
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 40.0),
                          child: const Text('設定結束日期',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20))),
                      onPressed: () {
                        DatePicker.showDatePicker(context,
                            showTitleActions: true,
                            minTime:
                                DateTime.now().add(new Duration(days: -30)),
                            maxTime: DateTime.now(), onConfirm: (date) {
                          endDate = twoDigit(date.year) +
                              "-" +
                              twoDigit(date.month) +
                              "-" +
                              twoDigit(date.day + 1);
                        }, currentTime: DateTime.now(), locale: LocaleType.zh);
                      },
                    )),
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
                    print("startDate:" + startDate);
                    print("endDate:" + endDate);
                    return showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("匯出日期確認"),
                            content: SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                      padding: EdgeInsets.only(top: 16),
                                      child: Text("確定要匯出" + name + "的資料嗎？")),
                                  Padding(
                                      padding: EdgeInsets.only(top: 16),
                                      child: Text("起始日期:" + startDate)),
                                  Padding(
                                      padding: EdgeInsets.only(top: 16),
                                      child: Text('|')),
                                  Padding(
                                      padding: EdgeInsets.only(top: 16),
                                      child: Text("結束日期:" + endDate)),
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
                                      Navigator.of(context).pop();
                                      List data = [startDate, endDate];
                                      sqlhelper helpler = new sqlhelper();
//                                      await helpler.writeEmployeeToCsv(data,num);

                                      String result = await helpler
                                          .writeEmployeeToCsv(data, num);
                                      print(result);

                                      Navigator.of(context).pop();

                                      if (result == "匯出失敗") {
                                        print("匯出失敗");
                                        return showDialog(
                                          context: context,
                                          builder: (context) {
                                            return SimpleDialog(
                                              title: Text("匯出失敗"),
                                              children: <Widget>[
                                                Column(
                                                  children: <Widget>[
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 16),
                                                        child: Text("匯出失敗")),
                                                  ],
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      } else {
                                        print("匯出成功");
                                        return showDialog(
                                          context: context,
                                          builder: (context) {
                                            return SimpleDialog(
                                              title: Text("匯出成功"),
                                              children: <Widget>[
                                                Column(
                                                  children: <Widget>[
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 16),
                                                        child:
                                                            Text("匯出成功 路徑為")),
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                          top: 16,
                                                          left: 8,
                                                          right: 4,
                                                        ),
                                                        child: Text(result)),
                                                  ],
                                                ),
                                              ],
                                            );
                                          },
                                        );
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

getData() async {
  sqlhelper helper = new sqlhelper();
  temperature data = temperature(id: 1, time: "2020-04-07", temp: "25.6");
  await helper.insertData(data);
  print(await helper.showtemperature());
//  employee data=new employee(employeeID: "12",name: "123");
//  temperature data = new temperature(id: 1, time: "2020-01-12", temp: "25.6");
//  helper.insertData(data);
  // print(await helper.showEmployee());
  return await helper.showLastTemp();
}

class content extends StatelessWidget {
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
            list.add(
              new Slidable(
                actionPane: SlidableDrawerActionPane(),
                actionExtentRatio: 0.25,
                child: Container(
                  color: Colors.white,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.indigoAccent,
//                      child: Icon(Icons.person),
                      child: Text(data[i].employeeID.toString()),
                      foregroundColor: Colors.white,
                    ),
                    trailing: Text(
                      data[i].temp.toString(),
                      style: TextStyle(
                        fontSize: 32,
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
                    subtitle: Text(
                      data[i].time.toString(),
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                secondaryActions: <Widget>[
                  IconSlideAction(
                    caption: '匯出',
                    color: Color(0xFFFEFCBF),
                    icon: Icons.share,
                    onTap: () => createSelectPersonalShareDateAlertDialog(
                        context, data[i].id, data[i].name.toString()),
                  ),
                ],
              ),
            );
          }
          return new Column(children: list);
        } else {
          return Text('無資料');
        }
      },
    );
  }

//  new Column(children: list);
  Future<String> downloadData() async {
    data = await getData();
    return Future.value("Get Data"); // return your response
  }
}

class ShareScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("資料匯出"),
        centerTitle: true,
        backgroundColor: appColor,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: '全體匯出',
            onPressed: () {
              createSelectShareDateAlertDialog(context);
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[content()],
      ),
    );
  }
}
