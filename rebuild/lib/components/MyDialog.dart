import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rebuild/DB/employee_model.dart';
import 'package:rebuild/DB/sqlhelper.dart';

Color appColor = Color(0xFF2A6FDB);
Color cashColor = Color(0xFFFEFCBF);

class showMySimpleDialogs extends State {
  showMySimpleDialog(BuildContext context, int condition,
      [id, name, employeeID, mac]) {
    // condition 1 = insert
    //           2 = edit
    //           3 = del
    GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
    print(mac);
    List macs;
    String title =
        (condition == 1) ? "新增人員" : (condition == 2) ? "修改人員" : "刪除人員";
    if (mac != null && mac != "") {
      macs = mac.split(":");
    } else {
      macs = ["", "", "", "", "", ""];
    }

    List<String> inputmac = ["", "", "", "", "", ""];
    String inputname = "";
    String inputemployeeID = "";
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
                child: Form(
                    key: _formKey,
                    autovalidate: true,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        if (condition == 3)
                          Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: Row(
                              children: <Widget>[
                                Text('確定要刪除此資料？'),
                              ],
                            ),
                          ),
                        if (condition == 3)
                          Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: Row(
                              children: <Widget>[
                                Text('姓名：'),
                                Text(name),
                              ],
                            ),
                          ),
                        if (condition == 3)
                          Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: Row(
                              children: <Widget>[
                                Text('編號：'),
                                Text(employeeID),
                              ],
                            ),
                          ),
                        if (condition == 3)
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
                        if (condition != 3)
                          TextFormField(
                            initialValue: name,
                            decoration: InputDecoration(labelText: "姓名"),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "請輸入";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              inputname = value.toString();
                            },
                          ),
                        if (condition != 3)
                          TextFormField(
                            initialValue: employeeID,
                            decoration: InputDecoration(labelText: "編號"),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "請輸入";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              inputemployeeID = value.toString();
                            },
                          ),
                        if (condition != 3)
                          Text(
                            "MAC",
                            style: TextStyle(height: 2),
                          ),
                        if (condition != 3)
                          Row(
                            children: <Widget>[
                              for (int i = 0; i < 6; i++)
                                Flexible(
                                    child: Row(
                                  children: <Widget>[
                                    Flexible(
                                      child: TextFormField(
                                        initialValue: macs[i],
                                        decoration: InputDecoration(),
                                        maxLength: 2,
                                        onSaved: (value) {
                                          inputmac[i] = value.toString();
                                        },
                                      ),
                                    ),
                                    if (i != 5) Text(":")
                                  ],
                                )),
                            ],
                          )
                      ],
                    ))),
            actions: <Widget>[
              new ButtonBar(
                children: <Widget>[
                  new FlatButton(
                    child: Text('確認'),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        sqlhelper helper = sqlhelper();
                        employee inputdata;
                        if (condition == 1) {
                          _formKey.currentState.save();
                          inputdata = employee(
                              employeeID: inputemployeeID,
                              name: inputname,
                              mac: inputmac[0] != "" ? inputmac.join(":") : "");
                          await helper.insertData(inputdata);
                          print(inputdata);
                          Navigator.of(context).pop();
                        } else if (condition == 2) {
                          _formKey.currentState.save();
                          inputdata = employee(
                              id: id,
                              employeeID: inputemployeeID,
                              name: inputname,
                              mac: inputmac.join(":"));
                          await helper.updateData(inputdata);
                          Navigator.of(context).pop();
                        } else {
                          await helper.deleteEmployee(id);
                          Navigator.of(context).pop();
                        }
                        await setState(() {});
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
    // TODO: implement build
    return null;
  }
}
