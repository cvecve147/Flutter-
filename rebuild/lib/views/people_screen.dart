import 'package:flutter/material.dart';

import 'package:rebuild/DB/sqlhelper.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../components/MyDialog.dart';

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
            onPressed: () {
              showMySimpleDialog(context);
            },
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.input),
          tooltip: '匯入人員',
          onPressed: () async {
//              Scaffold.of(context).showSnackBar(SnackBar(
//                content: Text("Pressing inport button."),
//              ));
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
  void initState() {
    super.initState();
    (() async {
      sqlhelper helper = sqlhelper();
      Data = await helper.showEmployee();
      setState(() {});
    })();
  }

  @override
  Widget build(BuildContext context) {
    var length = Data.length;
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
            onTap: () => showMySimpleDialog(
                context, Data[i].name, Data[i].mac, Data[i].employeeID),
          ),
          IconSlideAction(
            caption: '配對',
            color: Colors.blue,
            icon: Icons.settings_ethernet,
            onTap: () => showMySimpleDialog(context),
          ),
          IconSlideAction(
            caption: '刪除',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () => showMySimpleDialog(
                context, Data[i].name, Data[i].mac, Data[i].employeeID),
          ),
        ],
      );
    });
    return SingleChildScrollView(
      child: Column(children: list),
    );
  }
}
