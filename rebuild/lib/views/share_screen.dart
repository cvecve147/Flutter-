import 'package:flutter/material.dart';
import 'package:rebuild/DB/sqlhelper.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:rebuild/DB/temperature_model.dart';
import '../components/ShareDialog.dart';

Color appColor = Color(0xFF2A6FDB);
Color cashColor = Color(0xFFFEFCBF);

class ShareScreen extends StatefulWidget {
  ShareScreen({Key key}) : super(key: key);

  @override
  _ShareScreenState createState() => _ShareScreenState();
}

class _ShareScreenState extends ShareDialog {
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
              createShareDialog(context, "全體匯出");
            },
          ),
        ],
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

class _BodyState extends ShareDialog {
  List Data = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    (() async {
      sqlhelper helper = sqlhelper();
      Data = await helper.showLastTemp();
      await setState(() {});
    }());
  }

  @override
  Widget build(BuildContext context) {
    int length = Data.length;
    if (Data.length > 0) {
      var list = List.generate(length, (i) {
        print("build");
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
                Data[i].temp.length > 0 ? Data[i].temp : "20",
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
              caption: '匯出',
              color: Color(0xFFFEFCBF),
              icon: Icons.share,
              onTap: () =>
                  createShareDialog(context, "個人匯出", Data[i].id, Data[i].name),
            ),
          ],
        );
      });

      return SingleChildScrollView(
        child: Column(children: list),
      );
    } else {
      return SingleChildScrollView(
        child: Column(),
      );
    }
  }
}
