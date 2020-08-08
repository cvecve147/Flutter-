import 'dart:io';
import 'dart:math';

String getNiceHexArray(List<int> bytes) {
  return '[${bytes.map((i) => i.toRadixString(16).padLeft(2, '0')).join(', ')}]'
      .toUpperCase();
}

String transValue(correct, bytes) {
  String t =
      '${bytes.map((i) => i.toRadixString(16).padLeft(2, '0')).join(', ')}'
          .toUpperCase();
  var data1, data2, data3, data4, pid, check1, check2;
  if (correct == '8796') {
    check1 = bytes
        .elementAt(0)
        .toRadixString(16)
        .padLeft(2, '0')
        .toUpperCase()
        .toString();
    check2 = bytes
        .elementAt(1)
        .toRadixString(16)
        .padLeft(2, '0')
        .toUpperCase()
        .toString();
  } else {
    check1 = '00';
    check2 = '00';
  }
  if (correct + check1 + check2 == '87965980') {
    pid = bytes
        .elementAt(2)
        .toRadixString(16)
        .padLeft(2, '0')
        .toUpperCase()
        .toString();
  } else {
    pid = '00';
  }
  if (correct == '8796' && check1 == '59' && check2 == '80' && pid == '03') {
    data1 = bytes
        .elementAt(4)
        .toRadixString(16)
        .padLeft(2, '0')
        .toUpperCase()
        .toString();
    data2 = bytes
        .elementAt(5)
        .toRadixString(16)
        .padLeft(2, '0')
        .toUpperCase()
        .toString();
    data3 = bytes
        .elementAt(6)
        .toRadixString(16)
        .padLeft(2, '0')
        .toUpperCase()
        .toString();
    data4 = bytes
        .elementAt(7)
        .toRadixString(16)
        .padLeft(2, '0')
        .toUpperCase()
        .toString();
    double tem = bytesToFloat(toRadix(data1), toRadix(data2), toRadix(data3),
        toRadix(data4)); //decodeTempLevel(data,0);
    return formatNum(tem, 2); //+data2+data3+data4
  } else {
    return correct;
  }
}

int toRadix(x) {
  var first, sec;
  first = x.substring(0, 1);
  switch (first) {
    case 'F':
      {
        first = 15;
      }
      break;
    case 'E':
      {
        first = 14;
      }
      break;
    case 'D':
      {
        first = 13;
      }
      break;
    case 'C':
      {
        first = 12;
      }
      break;
    case 'B':
      {
        first = 11;
      }
      break;
    case 'A':
      {
        first = 10;
      }
      break;
    default:
      {
        first = int.parse(first);
      }
  }
  sec = x.substring(1, 2);
  switch (sec) {
    case 'F':
      {
        sec = 15;
      }
      break;
    case 'E':
      {
        sec = 14;
      }
      break;
    case 'D':
      {
        sec = 13;
      }
      break;
    case 'C':
      {
        sec = 12;
      }
      break;
    case 'B':
      {
        sec = 11;
      }
      break;
    case 'A':
      {
        sec = 10;
      }
      break;
    default:
      {
        sec = int.parse(sec);
      }
  }
  var ans = first * 16 + sec;
  return ans & 0xFF;
}

//取得16進制array
String trans(List<int> bytes) {
  return '${bytes.map((i) => i.toRadixString(16).padLeft(2, '0')).join(', ')}'
      .toUpperCase();
}

//取得製造商資訊
String getNiceManufacturerData(Map<int, List<int>> data) {
  if (data.isEmpty) {
    return null;
  }
  List<String> res = [];
  data.forEach((id, bytes) {
    res.add('${id.toRadixString(16).toUpperCase()}: ${getNiceHexArray(bytes)}');
  });
  return res.join(', ');
}

double bytesToFloat(b0, b1, b2, b3) {
//    int mantissa = unsignedToSigned(b0 + (b1 << 8) + (b2 << 16), 24);
  b3 = -2;
  int mantissa = unsignedToSigned(
      unsignedByteToInt(b0) +
          (unsignedByteToInt(b1) << 8) +
          (unsignedByteToInt(b2) << 16),
      24);
  //(mantissa * pow(10, int.parse(b3)))
  return (mantissa * pow(10, b3));
}

int unsignedByteToInt(b) {
  return b & 0xFF;
}

int unsignedToSigned(int unsigned, int size) {
  if ((unsigned & (1 << size - 1)) != 0) {
    unsigned = -1 * ((1 << size - 1) - (unsigned & ((1 << size - 1) - 1)));
  }
  return unsigned;
}

String checkAddress(correct, bytes) {
  var pid, check1, check2;
  if (correct == '8796') {
    check1 = bytes
        .elementAt(0)
        .toRadixString(16)
        .padLeft(2, '0')
        .toUpperCase()
        .toString();
    check2 = bytes
        .elementAt(1)
        .toRadixString(16)
        .padLeft(2, '0')
        .toUpperCase()
        .toString();
  } else {
    check1 = '00';
    check2 = '00';
  }
  if (correct + check1 + check2 == '87965980') {
    pid = bytes
        .elementAt(2)
        .toRadixString(16)
        .padLeft(2, '0')
        .toUpperCase()
        .toString();
  } else {
    pid = '00';
  }
  return correct + check1 + check2 + pid;
}

String transTemp(bytes) {
  var data1, data2, data3, data4, data;
  data = bytes.split(',');
  data1 = data[0].trim(); //trim():將字符串兩邊去除空格處理
  data2 = data[1].trim();
  data3 = data[2].trim();
  data4 = data[3].trim();
  double tem = bytesToFloat(toRadix(data1), toRadix(data2), toRadix(data3),
      toRadix(data4)); //decodeTempLevel(data,0);
  return formatNum(tem, 2); //+data2+data3+data4
}

//溫度小數取到第二位
formatNum(double num, int postion) {
  if ((num.toString().length - num.toString().lastIndexOf(".") - 1) < postion) {
    return num.toStringAsFixed(postion)
        .substring(0, num.toString().lastIndexOf(".") + postion + 1)
        .toString();
  } else {
    return num.toString()
        .substring(0, num.toString().lastIndexOf(".") + postion + 1)
        .toString();
  }
}

//取得體溫資料
String getBodyTempData(Map<String, List<int>> data) {
  //String
  if (data.isEmpty) {
    return null;
  }
  List<String> res = [];
//    res.add('${trans(data[1])}');
  data.forEach((id, bytes) {
    res.add('${trans(bytes)}'); //${id.toUpperCase()}  ${getNiceHexArray(bytes)}
  });
  return res.elementAt(0);
}

//判斷是否為華星tag
bool tagis(Map<int, List<int>> data1, Map<String, List<int>> data2, mac) {
  var check;
  List<String> res1 = [], res2 = [];
  data1.forEach((id, bytes) {
    var c = '${id.toRadixString(16).toUpperCase()}';
    check = '${checkAddress(c, bytes)}';
    res1.add('${checkAddress(c, bytes)}');
  });
  data2.forEach((id, bytes) {
    res2.add(
        '${trans(bytes)}'); //${id.toUpperCase()}  ${getNiceHexArray(bytes)}
  });
  if (check == '8796598003') {
    return true;
  } else {
    return false;
  }
}

getCurrentDate() {
  var now = new DateTime.now();
  String twoDigit(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  String currentDate =
      twoDigit(now.year) + "-" + twoDigit(now.month) + "-" + twoDigit(now.day);
  String currentTime = twoDigit(now.hour) +
      ":" +
      twoDigit(now.minute) +
      ":" +
      twoDigit(now.second);

  return currentDate + " " + currentTime;
}

//取得溫度資料
String getTempData(Map<int, List<int>> data1, Map<String, List<int>> data2) {
  var check;
  List<String> res1 = [], res2 = [];
  data1.forEach((id, bytes) {
    var c = '${id.toRadixString(16).toUpperCase()}';
    check = '${checkAddress(c, bytes)}';
    res1.add('${checkAddress(c, bytes)}');
  });
  data2.forEach((id, bytes) {
    res2.add(
        '${trans(bytes)}'); //${id.toUpperCase()}  ${getNiceHexArray(bytes)}
  });
  if (check == '8796598003') {
    if (Platform.isAndroid) {
      return transTemp(res2.elementAt(1));
      // Android-specific code
    } else if (Platform.isIOS) {
      return transTemp(res2.elementAt(2));
      // iOS-specific code
    }
    // Android:1, iOS:2
  } else {
    return res1.toString(); //elementAt(0)
  }
}

//取得服務資料
String getNiceServiceData(Map<String, List<int>> data) {
  //String
  if (data.isEmpty) {
    return null;
  }
  List<String> res = [];
  data.forEach((id, bytes) {
    res.add(
        '${id.toUpperCase()}: ${getNiceHexArray(bytes)}'); //${id.toUpperCase()}  ${getNiceHexArray(bytes)}
  });
  return res.join(', ');
}

title(String allmac, String mac, String name) {
  if (allmac == mac) {
    return name;
  } else {
    return mac;
  }
}

id(String allmac, String mac, String id) {
  if (allmac == mac) {
    return id;
  } else {
    return 0.toString();
  }
}

//取得室溫資訊
String getRoomTempData(Map<int, List<int>> data) {
  if (data.isEmpty) {
    return null;
  }
  List<String> res = [];
  data.forEach((id, bytes) {
    var c = '${id.toRadixString(16).toUpperCase()}';
    res.add('${transValue(c, bytes)}');
  });
  return res.join(', ');
}
