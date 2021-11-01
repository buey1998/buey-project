import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_project/detailsOroder.dart/classButton.dart';
import 'package:ecommerce_project/product/productPage/chart.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class Result extends StatefulWidget {
  // Result({Key key}) : super(key: key);
  final List<charts.Series> seriesList;
  final bool animate;
  Result({this.seriesList, this.animate});

  @override
  _ResultState createState() => _ResultState();
}

RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
Function mathFunc = (Match match) => '${match[1]},';

List<YersResult> _yearsResult = YersResult.getYearsResult();
List<DropdownMenuItem<YersResult>> _dropdonwitems;
YersResult _yersResultItem;

class _ResultState extends State<Result> {
  // List<YersResult> _yearsResult = YersResult.getYearsResult();
  // List<DropdownMenuItem<YersResult>> _dropdonwitems;
  // YersResult _yersResultItem;

  @override
  void initState() {
    _dropdonwitems = buildDropdonwMenuItem(_yearsResult);
    _yersResultItem = _dropdonwitems[0].value;
    super.initState();
  }

  List<DropdownMenuItem<YersResult>> buildDropdonwMenuItem(List yersResult) {
    List<DropdownMenuItem<YersResult>> item = List();
    for (YersResult yersResult in yersResult) {
      item.add(DropdownMenuItem(
        value: yersResult,
        child: Text(yersResult.yersResult),
      ));
    }
    return item;
  }

  onChangeDropdonwItem(YersResult selectYears) {
    setState(() {
      _yersResultItem = selectYears;
      count -= count;
    });
  }

  int key = 0;

  CollectionReference datoOnFirebase =
      FirebaseFirestore.instance.collection('myorder');

  CollectionReference fuckYou = FirebaseFirestore.instance.collection('result');

  dynamic count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: datoOnFirebase
                    .where('status', isEqualTo: 'สำเร็จ')
                    .where('date',
                        isGreaterThan: '${_yersResultItem.yersResult}' '/01/01',
                        isLessThan: '${_yersResultItem.yersResult}' '/12/31')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Something went wrong'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: Text("Loading"));
                  }

                  final text = snapshot.data.docs
                      .map((e) => count += e.data()['summary']);
                  print('$text');
                  // for (var i = 0; i < text.length ; i++) {
                  //   count += text[i];
                  //   return count;
                  // }

                  return Column(
                    children: [
                      Text(
                        'สรุปยอด',
                        style: TextStyle(fontSize: 25),
                      ),
                      Text(
                        'ยอดเงิน ณ วันที่ 01 มกราคม - 30 ธันวาคม'
                        ' ${_yersResultItem.yersResult}',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Divider(),

                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('จำนวนทำรายการ'),
                          Text('ยอดขายรวม (บาท)')
                        ],
                      ),

                      Divider(
                        color: Colors.white,
                      ),

                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Text('${totalPrice(productItem).toString()}'),

                          Text('${snapshot.data.docs.length.toString()}'),

                          // Text('${snapshot.data.docChanges.map((e) => e.doc.data()['summary'])}'),

                          Text('$count'.replaceAllMapped(reg, mathFunc),
                              style: TextStyle(
                                  fontSize: 20, color: Color(0xFF639458)))
                        ],
                      ),

                      Divider(),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('ยอดขายสินค้า/เดือน ของปี ',
                              style: TextStyle(fontSize: 20)),
                          DropdownButton(
                            hint: const Text('เลือกรายการ'),
                            items: _dropdonwitems,
                            onChanged: onChangeDropdonwItem,
                            value: _yersResultItem,
                          )
                        ],
                      ),

                      Divider(
                        color: Colors.white,
                      ),
                      // Text('$count'),
                    ],
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      width: 190,
                      height: 40,
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            color: Color(0xffFBDFEB),
                          ),
                          Expanded(
                            child: Container(
                              height: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(color: Color(0xffFBDFEB)),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('  มกราคม  :'),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: _january(),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      )),
                  Container(
                    width: 190,
                    height: 40,
                    child: Row(
                      children: [
                        Container(
                          width: 10,
                          color: Color(0xffDEDAED),
                        ),
                        Expanded(
                          child: Container(
                            height: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(color: Color(0xffFDEDAED)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('  กุมภาพันธ์  :'),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: _february(),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              Divider(
                color: Colors.white,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      width: 190,
                      height: 40,
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            color: Color(0xffAA9FCE),
                          ),
                          Expanded(
                            child: Container(
                              height: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(color: Color(0xffAA9FCE)),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('  มีนาคม  :'),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: _march(),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      )),
                  Container(
                    width: 190,
                    height: 40,
                    child: Row(
                      children: [
                        Container(
                          width: 10,
                          color: Color(0xff8071B3),
                        ),
                        Expanded(
                          child: Container(
                            height: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(color: Color(0xff8071B3)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('  เมษายน  :'),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: _april(),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              Divider(
                color: Colors.white,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      width: 190,
                      height: 40,
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            color: Color(0xff00ADE2),
                          ),
                          Expanded(
                            child: Container(
                              height: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(color: Color(0xff00ADE2)),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('  พฤษภาคม  :'),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: _may(),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      )),
                  Container(
                    width: 190,
                    height: 40,
                    child: Row(
                      children: [
                        Container(
                          width: 10,
                          color: Color(0xff63C7EC),
                        ),
                        Expanded(
                          child: Container(
                            height: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(color: Color(0xff63C7EC)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('  มิถุนายน  :'),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: _june(),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              Divider(
                color: Colors.white,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      width: 190,
                      height: 40,
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            color: Color(0xffCCE9F8),
                          ),
                          Expanded(
                            child: Container(
                              height: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(color: Color(0xffCCE9F8)),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('  กรกฎาคม  :'),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: _july(),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      )),
                  Container(
                    width: 190,
                    height: 40,
                    child: Row(
                      children: [
                        Container(
                          width: 10,
                          color: Color(0xff95D5D2),
                        ),
                        Expanded(
                          child: Container(
                            height: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(color: Color(0xff95D5D2)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('  สิงหาคม  :'),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: _august(),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              Divider(
                color: Colors.white,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      width: 190,
                      height: 40,
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            color: Color(0xff68C8C3),
                          ),
                          Expanded(
                            child: Container(
                              height: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(color: Color(0xff68C8C3)),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('  กันยายน  :'),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: _september(),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      )),
                  Container(
                    width: 190,
                    height: 40,
                    child: Row(
                      children: [
                        Container(
                          width: 10,
                          color: Color(0xff00B6AD),
                        ),
                        Expanded(
                          child: Container(
                            height: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(color: Color(0xff00B6AD)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('  ตุลาคม  :'),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: _october(),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              Divider(
                color: Colors.white,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      width: 190,
                      height: 40,
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            color: Color(0xffF49AC1),
                          ),
                          Expanded(
                            child: Container(
                              height: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(color: Color(0xffF49AC1)),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('  พฤศจิกายน  :'),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: _november(),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      )),
                  Container(
                    width: 190,
                    height: 40,
                    child: Row(
                      children: [
                        Container(
                          width: 10,
                          color: Color(0xffF8BCD6),
                        ),
                        Expanded(
                          child: Container(
                            height: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(color: Color(0xffF8BCD6)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('  ธันวาคม  :'),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: _december(),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              Divider(
                color: Colors.white,
              ),
              // Container(
              //   height: 600,
              //   child: SalesResult())
              Padding(
                padding: const EdgeInsets.all(20),
                child: InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SalesResult()));
                  },
                  child: Container(
                    height: 40,
                    width: double.infinity,
                    child: Center(
                        child: Text('ดูข้อมูลเปรียบเทียบยอดขายสินค้า',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black))),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Color(0xFFF2DD80),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Null> _refresh() async {
    // datoOnFirebase.get();
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      count -= count;
    });
    return null;
  }
}

Widget _january() {
  var jan = 0;
  return FutureBuilder<QuerySnapshot>(
    future: FirebaseFirestore.instance
        .collection('myorder')
        .where('status', isEqualTo: 'สำเร็จ')
        .where('date',
            isGreaterThan: '${_yersResultItem.yersResult}' '/01/01',
            isLessThan: '${_yersResultItem.yersResult}' '/01/31')
        .get(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError) {
        return Center(child: Text('Something went wrong'));
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: Text("Loading"));
      }
      final sum = snapshot.data.docs.map((e) => jan += e.data()['summary']);
      print('$sum');
      Future future = FirebaseFirestore.instance
          .collection('result')
          .doc('01-มกราคม')
          .set({'sum': jan, 'resultMount': 'มกราคม', 'colors': '0xffFBDFEB'});
      print('$future');
      return
          // Text('${snapshot.data.docs.map((e) =>  e.data()['summary'].runtimeType)}');
          Text('${jan.toInt()}'.replaceAllMapped(reg, mathFunc) + ' THB');
    },
  );
}

Widget _february() {
  var feb = 0;
  return FutureBuilder<QuerySnapshot>(
    future: FirebaseFirestore.instance
        .collection('myorder')
        .where('status', isEqualTo: 'สำเร็จ')
        .where('date',
            isGreaterThan: '${_yersResultItem.yersResult}' '/02/01',
            isLessThan: '${_yersResultItem.yersResult}' '/02/28')
        .get(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError) {
        return Center(child: Text('Something went wrong'));
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: Text("Loading"));
      }
      final sum = snapshot.data.docs.map((e) => feb += e.data()['summary']);
      print('$sum');
      Future future = FirebaseFirestore.instance
          .collection('result')
          .doc('02-กุมภาพันธ์')
          .set({
        'sum': feb,
        'resultMount': 'กุมภาพันธ์',
        'colors': '0xffFDEDAED'
      });
      print('$future');
      return Text('${feb.toInt()}'.replaceAllMapped(reg, mathFunc) + ' THB');
    },
  );
}

Widget _march() {
  var march = 0;
  return FutureBuilder<QuerySnapshot>(
    future: FirebaseFirestore.instance
        .collection('myorder')
        .where('status', isEqualTo: 'สำเร็จ')
        .where('date',
            isGreaterThan: '${_yersResultItem.yersResult}' '/03/01',
            isLessThan: '${_yersResultItem.yersResult}' '/03/31')
        .get(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError) {
        return Center(child: Text('Something went wrong'));
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: Text("Loading"));
      }
      final sum = snapshot.data.docs.map((e) => march += e.data()['summary']);
      print('$sum');
      Future future = FirebaseFirestore.instance
          .collection('result')
          .doc('03-มีนาคม')
          .set({'sum': march, 'resultMount': 'มีนาคม', 'colors': '0xffAA9FCE'});
      print('$future');
      return Text('${march.toInt()}'.replaceAllMapped(reg, mathFunc) + ' THB');
    },
  );
}

Widget _april() {
  var april = 0;
  return FutureBuilder<QuerySnapshot>(
    future: FirebaseFirestore.instance
        .collection('myorder')
        .where('status', isEqualTo: 'สำเร็จ')
        .where('date',
            isGreaterThan: '${_yersResultItem.yersResult}' '/04/01',
            isLessThan: '${_yersResultItem.yersResult}' '/04/30')
        .get(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError) {
        return Center(child: Text('Something went wrong'));
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: Text("Loading"));
      }
      final sum = snapshot.data.docs.map((e) => april += e.data()['summary']);
      print('$sum');
      Future future = FirebaseFirestore.instance
          .collection('result')
          .doc('04-เมษายน')
          .set({'sum': april, 'resultMount': 'เมษายน', 'colors': '0xff8071B3'});
      print('$future');
      return Text('${april.toInt()}'.replaceAllMapped(reg, mathFunc) + ' THB');
    },
  );
}

Widget _may() {
  var may = 0;
  return FutureBuilder<QuerySnapshot>(
    future: FirebaseFirestore.instance
        .collection('myorder')
        .where('status', isEqualTo: 'สำเร็จ')
        .where('date',
            isGreaterThan: '${_yersResultItem.yersResult}' '/05/01',
            isLessThan: '${_yersResultItem.yersResult}' '/05/31')
        .get(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError) {
        return Center(child: Text('Something went wrong'));
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: Text("Loading"));
      }
      final sum = snapshot.data.docs.map((e) => may += e.data()['summary']);
      print('$sum');
      Future future = FirebaseFirestore.instance
          .collection('result')
          .doc('05-พฤษภาคม')
          .set({'sum': may, 'resultMount': 'พฤษภาคม', 'colors': '0xff00ADE2'});
      print('$future');
      return Text('${may.toInt()}'.replaceAllMapped(reg, mathFunc) + ' THB');
    },
  );
}

Widget _june() {
  var june = 0;
  return FutureBuilder<QuerySnapshot>(
    future: FirebaseFirestore.instance
        .collection('myorder')
        .where('status', isEqualTo: 'สำเร็จ')
        .where('date',
            isGreaterThan: '${_yersResultItem.yersResult}' '/06/01',
            isLessThan: '${_yersResultItem.yersResult}' '/06/30')
        .get(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError) {
        return Center(child: Text('Something went wrong'));
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: Text("Loading"));
      }
      final sum = snapshot.data.docs.map((e) => june += e.data()['summary']);
      print('$sum');
      Future future = FirebaseFirestore.instance
          .collection('result')
          .doc('06-มิถุนายน')
          .set(
              {'sum': june, 'resultMount': 'มิถุนายน', 'colors': '0xff63C7EC'});
      print('$future');
      return Text('${june.toInt()}'.replaceAllMapped(reg, mathFunc) + ' THB');
    },
  );
}

Widget _july() {
  var july = 0;
  return FutureBuilder<QuerySnapshot>(
    future: FirebaseFirestore.instance
        .collection('myorder')
        .where('status', isEqualTo: 'สำเร็จ')
        .where('date',
            isGreaterThan: '${_yersResultItem.yersResult}' '/07/01',
            isLessThan: '${_yersResultItem.yersResult}' '/07/31')
        .get(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError) {
        return Center(child: Text('Something went wrong'));
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: Text("Loading"));
      }
      final sum = snapshot.data.docs.map((e) => july += e.data()['summary']);
      print('$sum');
      Future future = FirebaseFirestore.instance
          .collection('result')
          .doc('07-กรกฏาคม')
          .set({'sum': july, 'resultMount': 'กรกฏาคม', 'colors': '0xffCCE9F8'});
      print('$future');
      return Text('${july.toInt()}'.replaceAllMapped(reg, mathFunc) + ' THB');
    },
  );
}

Widget _august() {
  var august = 0;
  return FutureBuilder<QuerySnapshot>(
    future: FirebaseFirestore.instance
        .collection('myorder')
        .where('status', isEqualTo: 'สำเร็จ')
        .where('date',
            isGreaterThan: '${_yersResultItem.yersResult}' '/08/01',
            isLessThan: '${_yersResultItem.yersResult}' '/08/31')
        .get(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError) {
        return Center(child: Text('Something went wrong'));
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: Text("Loading"));
      }
      final sum = snapshot.data.docs.map((e) => august += e.data()['summary']);
      print('$sum');
      Future future = FirebaseFirestore.instance
          .collection('result')
          .doc('08-สิงหาคม')
          .set({
        'sum': august,
        'resultMount': 'สิงหาคม',
        'colors': '0xff95D5D2'
      });
      print('$future');
      return Text('${august.toInt()}'.replaceAllMapped(reg, mathFunc) + ' THB');
    },
  );
}

Widget _september() {
  var september = 0;
  return FutureBuilder<QuerySnapshot>(
    future: FirebaseFirestore.instance
        .collection('myorder')
        .where('status', isEqualTo: 'สำเร็จ')
        .where('date',
            isGreaterThan: '${_yersResultItem.yersResult}' '/09/01',
            isLessThan: '${_yersResultItem.yersResult}' '/09/30')
        .get(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError) {
        return Center(child: Text('Something went wrong'));
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: Text("Loading"));
      }
      final sum =
          snapshot.data.docs.map((e) => september += e.data()['summary']);
      print('$sum');
      Future future = FirebaseFirestore.instance
          .collection('result')
          .doc('09-กันยายน')
          .set({
        'sum': september,
        'resultMount': 'กันยายน',
        'colors': '0xff68C8C3'
      });
      print('$future');
      return Text(
          '${september.toInt()}'.replaceAllMapped(reg, mathFunc) + ' THB');
    },
  );
}

Widget _october() {
  var october = 0;
  return FutureBuilder<QuerySnapshot>(
    future: FirebaseFirestore.instance
        .collection('myorder')
        .where('status', isEqualTo: 'สำเร็จ')
        .where('date',
            isGreaterThan: '${_yersResultItem.yersResult}' '/10/01',
            isLessThan: '${_yersResultItem.yersResult}' '/10/31')
        .get(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError) {
        return Center(child: Text('Something went wrong'));
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: Text("Loading"));
      }
      final sum = snapshot.data.docs.map((e) => october += e.data()['summary']);
      print('$sum');
      Future future = FirebaseFirestore.instance
          .collection('result')
          .doc('10-ตุลาคม')
          .set({
        'sum': october,
        'resultMount': 'ตุลาคม',
        'colors': '0xff00B6AD'
      });
      print('$future');
      return Text(
          '${october.toInt()}'.replaceAllMapped(reg, mathFunc) + ' THB');
    },
  );
}

Widget _november() {
  var november = 0;
  return FutureBuilder<QuerySnapshot>(
    future: FirebaseFirestore.instance
        .collection('myorder')
        .where('status', isEqualTo: 'สำเร็จ')
        .where('date',
            isGreaterThan: '${_yersResultItem.yersResult}' '/11/01',
            isLessThan: '${_yersResultItem.yersResult}' '/11/30')
        .get(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError) {
        return Center(child: Text('Something went wrong'));
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: Text("Loading"));
      }
      final sum =
          snapshot.data.docs.map((e) => november += e.data()['summary']);
      print('$sum');
      Future future = FirebaseFirestore.instance
          .collection('result')
          .doc('11-พฤษจิกายน')
          .set({
        'sum': november,
        'resultMount': 'พฤษจิกายน',
        'colors': '0xffF49AC1'
      });
      print('$future');
      return Text(
          '${november.toInt()}'.replaceAllMapped(reg, mathFunc) + ' THB');
    },
  );
}

Widget _december() {
  var december = 0;
  return FutureBuilder<QuerySnapshot>(
    future: FirebaseFirestore.instance
        .collection('myorder')
        .where('status', isEqualTo: 'สำเร็จ')
        .where('date',
            isGreaterThan: '${_yersResultItem.yersResult}' '/12/01',
            isLessThan: '${_yersResultItem.yersResult}' '/12/31')
        .get(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError) {
        return Center(child: Text('Something went wrong'));
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: Text("Loading"));
      }
      final sum =
          snapshot.data.docs.map((e) => december += e.data()['summary']);
      print('$sum');
      Future future = FirebaseFirestore.instance
          .collection('result')
          .doc('12-ธันวาคม')
          .set({
        'sum': december,
        'resultMount': 'ธันวาคม',
        'colors': '0xffF8BCD6'
      });
      print('$future');
      return Text(
          '${december.toInt()}'.replaceAllMapped(reg, mathFunc) + ' THB');
    },
  );
}
