import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_project/detailsOroder.dart/detail.dart';
import 'package:ecommerce_project/model/order.dart';
import 'package:flutter/material.dart';

class AlreadyPay extends StatefulWidget {
  AlreadyPay({Key key}) : super(key: key);

  @override
  _AlreadyPayState createState() => _AlreadyPayState();
}

class _AlreadyPayState extends State<AlreadyPay> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('myorder')
            // .where('date', isGreaterThan: '2021/02/01' , isLessThan: '2021/02/30')
            .where('status', isEqualTo: 'โอนผ่านเงินธนาคาร')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Text("Loading"));
          }
          return ListView(
              children: snapshot.data.docs.map((DocumentSnapshot documents) {
            Order orderdata = Order.fromMap(documents.data());
            var docs = documents.id;
            return GestureDetector(
                child: Card(
                  // elevation: 1,
                  margin: EdgeInsets.all(5),
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: Colors.white,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Container(
                                  width: 150,
                                  height: 100,
                                  child: Image.asset(
                                    'assets/fronts/image/brown-rice.png',
                                    height: 100,
                                  )
                                  // Image.network(
                                  //   '${orderdata.list[0].imageproduct}',
                                  //   loadingBuilder: (context, child, progress) {
                                  //     return progress == null
                                  //         ? child
                                  //         : Center(
                                  //             child: CircularProgressIndicator());
                                  //   },
                                  // ),
                                  ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Container(
                                    height: double.infinity,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text('ผู้สั่ง ' + '${orderdata.name}',
                                            style: TextStyle(fontSize: 22)),
                                        Text('วันเวลาที่สั่ง'),
                                        Text('${documents.data()['date']}'),
                                        Text('สถานะการสั่ง : ' +
                                            '${documents.data()['status']}'),
                                        Text('รายการสินค้ามี '
                                            ' ${orderdata.list.length.toString()} '
                                            ' รายการ'),
                                        // Text('จำนวน  ' +
                                        //     '${orderdata.list[0].amount.round()}'),
                                        Container(
                                          child: Text(
                                              'รวม  ' +
                                                  '${orderdata.summary}' +
                                                  '  บาท',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Color(0xFF639458))),
                                          alignment: Alignment.bottomRight,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailsOrder(
                                orderdata: orderdata,
                                docs: docs,
                              )));
                });
          }).toList());
        });
  }
}
