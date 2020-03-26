import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:newapp1/pages/DB/employee_model.dart';
import 'package:newapp1/pages/DB/sqlhelper.dart';
import 'package:newapp1/pages/DB/temperature_model.dart';

Color appColor = Color(0xFF2A6FDB);
Color primaryColor = Color(0xFF122C91);

getData() async {
  sqlhelper helper = new sqlhelper();
//  employee data=new employee(employeeID: "12",name: "123");
  temperature data=new temperature(id:1,time: "2020-01-12",temp: "25.6");
  helper.insertData(data);
  print(await helper.showEmployee());
  return await helper.showLastTemp();
}

class content extends StatelessWidget {
  List data;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: downloadData(), // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {  // AsyncSnapshot<Your object type>
        List<Widget> list;
        print("123"+data.toString());
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
                    child: Icon(Icons.person),
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
                    data[i].employeeID.toString(),
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
//                onTap: () => _showSnackBar('Delete'),
                ),
              ],
            ),
          );
        }
        return new Column(children: list);
      },
    );;
  }
//  new Column(children: list);
  Future<String> downloadData() async {
    data = await getData();
    //   var response =  await http.get('https://getProjectList');
    return Future.value("Data download successfully"); // return your response
  }
}

class fulShareScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return null;
  }
}

class _shareScreenState extends State<fulShareScreen> {
  @override
  Widget build(BuildContext context) {
    var finaldate;

    void callDatePicker() async {
      var order = await getDate();
      setState(() {
        finaldate = order;
      });
    }
  }

  Future<DateTime> getDate() {
    // Imagine that this function is
    // more complex and slow.
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2018),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light(),
          child: child,
        );
      },
    );
  }
}

class ShareScreen extends StatelessWidget {
  TextEditingController startDateController = new TextEditingController();
  TextEditingController endDateController = new TextEditingController();

  DateTime _selectedDate;

  createSelectShareDateAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
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
                          Future<DateTime> selectedDate = showDatePicker(
                            context: context,
                            initialDate:
                                DateTime.now().add(new Duration(days: -15)),
                            firstDate:
                                DateTime.now().add(new Duration(days: -30)),
                            lastDate: DateTime.now(),
                            builder: (BuildContext context, Widget child) {
                              return Theme(
                                data: ThemeData.dark(),
                                child: child,
                              );
                            },
                          );
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
                      return showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Result'),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  Text(startDateController.text),
                                  Text(endDateController.text),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("資料匯出"),
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
