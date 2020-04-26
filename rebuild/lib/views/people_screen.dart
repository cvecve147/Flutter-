import 'package:flutter/material.dart';

import 'package:flutter_slidable/flutter_slidable.dart';
import '../components/MyDialog.dart';
import '../DB/employee_model.dart';
import '../DB/sqlhelper.dart';
import '../main.dart';

Color appColor = Color(0xFF2A6FDB);
Color cashColor = Color(0xFFFEFCBF);

class PeopleScreen extends StatefulWidget {
  PeopleScreen({Key key}) : super(key: key);

  @override
  PeopleScreenState createState() => PeopleScreenState();
}

class PeopleScreenState extends showMySimpleDialogs {
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
            onPressed: () async {
              await showMySimpleDialog(context, 1);
              await setState(() {});
            },
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.input),
          tooltip: '匯入人員',
          onPressed: () async {
            sqlhelper helpler = new sqlhelper();
            await helpler.readCsvToEmployee();
          },
        ),
      ),
      body: Body(),
    );
  }
}

class Body extends StatefulWidget {
  Body({Key key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends showMySimpleDialogs {
  List Data = [];

  @override
  Widget build(BuildContext context) {
    Future<String> downloadData() async {
      sqlhelper helper = sqlhelper();
      Data = await helper.showEmployee();
      return "get data";
    }

    return FutureBuilder<String>(
      future: downloadData(), // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        // AsyncSnapshot<Your object type>
        if (snapshot.hasData) {
          int length = Data.length;
          var list = List.generate(length, (i) {
            return Slidable(
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
                    Data[i].mac,
                    style: TextStyle(
                      fontSize: 22,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  title: Text(
                    Data[i].name,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  subtitle: Text(
                    Data[i].employeeID,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              secondaryActions: <Widget>[
                IconSlideAction(
                    caption: '修改',
                    color: cashColor,
                    icon: Icons.edit,
                    onTap: () async {
                      await showMySimpleDialog(context, 2, Data[i].id,
                          Data[i].name, Data[i].employeeID, Data[i].mac);
                      await setState(() {});
                    }),
                if (Data[i].mac != "")
                  IconSlideAction(
                      caption: '取消配對',
                      color: Colors.pink,
                      icon: Icons.bluetooth_disabled,
                      onTap: () async {
                        checkData.remove(Data[i].mac.toString());
                        print("按下取消配對");
                        sqlhelper helpler = new sqlhelper();
                        employee editData = employee(
                            id: Data[i].id,
                            employeeID: Data[i].employeeID,
                            name: Data[i].name,
                            mac: "");
                        await helpler.updateData(editData);
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text(Data[i].name + "已解除配對"),
                        ));
                        setState(() {});
                      }),
                if (Data[i].mac == "")
                  IconSlideAction(
                    caption: '配對',
                    color: Colors.blue,
                    icon: Icons.settings_ethernet,
                    onTap: () => showMySimpleDialog(context, 2),
                  ),
                IconSlideAction(
                  caption: '刪除',
                  color: Colors.red,
                  icon: Icons.delete,
                  onTap: () => showMySimpleDialog(context, 3, Data[i].id,
                      Data[i].name, Data[i].employeeID, Data[i].mac),
                ),
              ],
            );
          });

          return SingleChildScrollView(
            child: Column(children: list),
          );
        } else {
          return Text('無資料');
        }
      },
    );
  }
}
