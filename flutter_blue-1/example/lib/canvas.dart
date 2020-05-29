import 'package:flutter/material.dart';
import 'package:image/image.dart' as image;
import 'package:flutter/services.dart' show rootBundle;
import './main.dart';
import 'dart:ui' as ui;

class canvasRoute extends StatefulWidget {
  @override
  _cnavasRouteState createState() => _cnavasRouteState();
}

class _cnavasRouteState extends State<canvasRoute> {
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
    if (this.images == null)
      return Scaffold(
          appBar: AppBar(
            title: Text("Canvas"),
          ),
          body: Center(child: Text("loading Image")));
    double x = 0, y = 0;
    if (nowPosition.length > 0) {
      x = nowPosition[0].x;
      y = nowPosition[0].y;
      return Scaffold(
          appBar: AppBar(
            title: Text("Canvas"),
          ),
          body: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "紅點為beacon位置，綠點為你現在位置",
                  style: TextStyle(fontSize: 18),
                ),
                Padding(
                  padding: EdgeInsets.all(4.0),
                ),
                Text(
                  "現在位置為" + x.toStringAsFixed(2) + " , " + y.toStringAsFixed(2),
                  style: TextStyle(fontSize: 18),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                CustomPaint(
                  size: Size(400, 400),
                  painter: MyPainter(image: this.images),
                ),
              ],
            ),
          ));
    }
    // return Scaffold(
    //     appBar: AppBar(
    //       title: Text("Canvas"),
    //     ),
    //     body: Center(
    //       child: Text(
    //         "請檢查附近beacon數量",
    //         style: TextStyle(fontSize: 18),
    //       ),
    //     ));
    return Scaffold(
        appBar: AppBar(
          title: Text("Canvas"),
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "紅點為beacon位置，綠點為你現在位置",
                style: TextStyle(fontSize: 18),
              ),
              Padding(
                padding: EdgeInsets.all(4.0),
              ),
              Text(
                "現在位置為" + x.toStringAsFixed(2) + " , " + y.toStringAsFixed(2),
                style: TextStyle(fontSize: 18),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
              ),
              CustomPaint(
                size: Size(400, 400),
                painter: MyPainter(image: this.images),
              ),
            ],
          ),
        ));
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
