import 'package:flutter/material.dart';

import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import '../DB/sqlhelper.dart';

Color appColor = Color(0xFF2A6FDB);
Color cashColor = Color(0xFFFEFCBF);
String twoDigit(int n) {
  if (n >= 10) return "$n";
  return "0$n";
}

class ShareDialog extends State {
  createShareDialog(BuildContext context, String title, [id, name]) {
    String startDate = "", endDate = "";
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  if (id != null)
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
                          },
                              currentTime: DateTime.now(),
                              locale: LocaleType.zh);
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
                          },
                              currentTime: DateTime.now(),
                              locale: LocaleType.zh);
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
                                    if (id != null)
                                      Padding(
                                          padding: EdgeInsets.only(top: 16),
                                          child:
                                              Text("確定要匯出" + name + "的資料嗎？")),
                                    if (id == null)
                                      Padding(
                                          padding: EdgeInsets.only(top: 16),
                                          child: Text("確定要匯出全體資料嗎？")),
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
                                        String result = "";
                                        if (id != null) {
                                          result = await helpler
                                              .writeEmployeeToCsv(data, id);
                                        } else {
                                          result = await helpler
                                              .writeEmployeeToCsv(data);
                                        }

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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
}
