import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_project/detailsOroder.dart/detail.dart';
import 'package:ecommerce_project/model/order.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  Search({Key key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _searchQuery = TextEditingController();
  final key = GlobalKey<ScaffoldState>();

  String textSearch = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text('ค้นหา'),
        backgroundColor: Color(0xFFF2DD80),
      ),
      body: Column(
        children: [
          Container(
              width: double.infinity,
              height: 100,
              color: Color(0xFFF2DD80),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: TextField(
                  cursorColor: Color(0xFFF2DD80),
                  controller: _searchQuery,
                  decoration: InputDecoration(
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    filled: true,
                    fillColor: Colors.white,
                    focusColor: Colors.white,
                    // focusedBorder: OutlineInputBorder(
                    //   borderSide:
                    //       const BorderSide(color: Colors.white, width: 2.0),
                    //   borderRadius: BorderRadius.circular(25.0),
                    // ),
                    // border: OutlineInputBorder(),
                    // labelText: 'พิมพ์ชื่อลูกค้าเพื่อค้นหา...',
                    hintText: 'พิมพ์ชื่อลูกค้าเพื่อค้นหา...',
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.clear,
                        size: 15,
                      ),
                      onPressed: () {
                        _searchQuery.clear();
                      },
                    ),
                  ),
                  onSubmitted: (String searchName) {
                    setState(() {
                      textSearch = searchName;
                    });
                    print('$textSearch');
                  },
                ),
              )),
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('myorder')
                      .where('name', isGreaterThanOrEqualTo: textSearch)
                      // .orderBy('DateTime' , descending: true)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Something went wrong'));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.data.docs.length == 0) {
                      return Center(child: Text('ไม่พบข้อมูล'));
                    }
                    return ListView(
                        children: snapshot.data.docs
                            .map((DocumentSnapshot documents) {
                      Order orderdata = Order.fromMap(documents.data());
                      var docs = documents.id;
                      return GestureDetector(
                          child: Card(
                            elevation: 0,
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
                                            //   loadingBuilder:
                                            //       (context, child, progress) {
                                            //     return progress == null
                                            //         ? child
                                            //         : Center(
                                            //             child:
                                            //                 CircularProgressIndicator());
                                            //   },
                                            // ),
                                            ),
                                        Expanded(
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Container(
                                              height: double.infinity,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Text(
                                                      'ผู้สั่ง ' +
                                                          '${orderdata.name}',
                                                      style: TextStyle(
                                                          fontSize: 22)),
                                                  Text(
                                                      'วันและเวลาการสั่งสินค้า  '),
                                                  Text('${orderdata.date}'),
                                                  Text('สถานะการสั่ง : ' +
                                                      '${orderdata.status}'),
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
                                                            color: Color(
                                                                0xFF639458))),
                                                    alignment:
                                                        Alignment.bottomRight,
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
                                        orderdata: orderdata, docs: docs)));
                          });
                    }).toList());
                  }))
        ],
      ),
    );
  }
}
