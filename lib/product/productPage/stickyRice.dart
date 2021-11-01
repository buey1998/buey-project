import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_project/model/skrice.dart';
import 'package:ecommerce_project/product/addproductSK.dart';
import 'package:ecommerce_project/product/editProductSK.dart';
import 'package:flutter/material.dart';

class StickyRice extends StatefulWidget {
  StickyRice({Key key}) : super(key: key);

  @override
  _StickyRiceState createState() => _StickyRiceState();
}

class _StickyRiceState extends State<StickyRice> {
  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  Function mathFunc = (Match match) => '${match[1]},';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection('cooked_rice').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Something went wrong'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: Text("Loading"));
            }
            return Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: ListView(
                  children: snapshot.data.docs.map(
                (DocumentSnapshot documents) {
                  Skrice skricedata = Skrice.fromMap(documents.data());
                  var docs = documents.id;
                  return Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: GestureDetector(
                        child: Stack(
                          children: [
                            Container(
                              height: 180,
                            ),
                            Container(
                              width: 300,
                              height: 180,
                              decoration: BoxDecoration(
                                color: Colors.teal[200],
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    bottomRight: Radius.circular(20)),
                              ),
                            ),
                            Positioned(
                                left: 10,
                                top: 10,
                                child: Container(
                                  width: 220,
                                  height: 160,
                                  // color: Colors.yellow,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        '${skricedata.name}',
                                        style: TextStyle(
                                            fontSize: 25, color: Colors.white),
                                      ),
                                      Text('ID สินค้า' ' ${skricedata.id}',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white)),
                                      Text('${skricedata.setproduct} ',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white)),
                                      Text(
                                          'ราคา ' '${skricedata.price} '
                                                  .replaceAllMapped(
                                                      reg, mathFunc) +
                                              ' บาท',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white)),
                                    ],
                                  ),
                                )),
                            Positioned(
                                right: -5,
                                bottom: 10,
                                child: Container(
                                  width: 160,
                                  height: 160,
                                  // color: Colors.teal,
                                  child: Image.network(
                                    skricedata.image,
                                    loadingBuilder: (context, child, progress) {
                                      return progress == null
                                          ? child
                                          : Center(
                                              child:
                                                  CircularProgressIndicator());
                                    },
                                    fit: BoxFit.fitHeight,
                                    errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace stackTrace) {
                                      return Text('$exception');
                                    },
                                  ),
                                ))
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailsProductSK(
                                      skricedata: skricedata, docs: docs)));
                        }),
                  );
                },
              ).toList()),
            );
          }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddproductSK()));
        },
        icon: Icon(Icons.add),
        label: Text('เพิ่มสินค้า'),
        backgroundColor: Color(0xFFDECAF1),
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.black, width: 1.5),
            borderRadius: BorderRadius.circular(30.0)),
      ),
    );
  }
}
