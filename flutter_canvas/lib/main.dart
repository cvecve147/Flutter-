import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:image/image.dart' as image;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import './device.dart';

List<Device> device = new List<Device>();
List<Device> nowPosition = new List<Device>();
void main() {
  runApp(MyApp());
  Device temp = Device(mac: "D4:6C:51:7D:F8:DB", x: 12, y: 14.4);
  device.add(temp);
  temp = Device(mac: "FE:42:E1:2F:42:77", x: 24, y: 12);
  device.add(temp);
  temp = Device(mac: "EB:A7:C6:6A:7C:CD", x: 36, y: 12);
  device.add(temp);
  temp = Device(mac: "DC:F6:28:8B:95:8E", x: 45, y: 14.4);
  device.add(temp);
  temp = Device(mac: "CC:E1:BF:9D:6B:9C", x: 31.95, y: 21);
  device.add(temp);
  temp = Device(mac: "CA:8F:29:16:7F:4A", x: 37.2, y: 31.8);
  device.add(temp);
  temp = Device(mac: "F8:94:1E:4E:31:D3", x: 34.65, y: 42);
  device.add(temp);
  print(device[0].mac);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Canvas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyCanvas(),
      routes: <String, WidgetBuilder>{'/register': (_) => new canvasRoute()},
    );
  }
}

class canvasRoute extends StatefulWidget {
  @override
  _canvasRouteState createState() => _canvasRouteState();
}

class _canvasRouteState extends State<canvasRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Canvas"),
        ),
        body: Center(child: Text("canvas Route ")));
  }
}

class MyCanvas extends StatefulWidget {
  @override
  _MyCanvasState createState() => _MyCanvasState();
}

class _MyCanvasState extends State<MyCanvas> {
  ui.Image images;

  @override
  void initState() {
    super.initState();
    (() async {
      if (this.images == null) {
        loadUiImage('assets/image/7F.png', 400, 400).then((img) {
          images = img;
          setState(() {});
        });
      }
    })();
  }

  Future<ui.Image> loadUiImage(String assetPath, height, width) async {
    final data = await rootBundle.load(assetPath);
    image.Image baseSizeImage = image.decodeImage(data.buffer.asUint8List());
    image.Image resizeImage =
        image.copyResize(baseSizeImage, height: height, width: width);
    ui.Codec codec =
        await ui.instantiateImageCodec(image.encodePng(resizeImage));
    ui.FrameInfo frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }

  @override
  Widget build(BuildContext context) {
    if (images == null)
      return Scaffold(
          appBar: AppBar(
            title: Text("Canvas"),
          ),
          body: Center(child: Text("loading ")));
    return Scaffold(
      appBar: AppBar(
        title: Text("Canvas"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            RaisedButton(onPressed: () {
              Navigator.of(context).pushNamed('/register');
            }),
            CustomPaint(
              size: Size(400, 400),
              painter: MyPainter(image: this.images),
            ),
          ],
        ),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  ui.Image image;
  Paint painter;
  MyPainter({this.image});
  @override
  void paint(Canvas canvas, Size size) {
    painter = Paint();
    canvas.drawImage(image, Offset(0.0, 0.0), painter);
    painter
      ..style = PaintingStyle.fill
      ..color = Colors.red;
    for (var item in device) {
      canvas.drawCircle(
        Offset(item.x * 8.45, size.height - item.y * 7.7),
        5,
        painter,
      );
    }
    painter
      ..style = PaintingStyle.fill
      ..color = Colors.green;
    for (var item in nowPosition) {
      canvas.drawCircle(
        Offset(item.x * 8.45, size.height - item.y * 7.7),
        5,
        painter,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
