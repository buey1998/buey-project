// import 'package:ecommerce_project/product/addproduct.dart';
import 'package:ecommerce_project/product/productPage/result.dart';
import 'package:ecommerce_project/product/productPage/ricepretty.dart';
import 'package:ecommerce_project/product/productPage/stickyRice.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Products extends StatefulWidget {
  Products({Key key}) : super(key: key);

  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              'รายการสินค้า',
              style: TextStyle(color: Colors.black, fontSize: 28),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0,
            toolbarHeight: 150,
            automaticallyImplyLeading: false,
            leading: IconButton(
              color: Colors.black,
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.of(context).pop(),
            ),
            bottom: TabBar(
                unselectedLabelColor: Color(0xFF639458),
                indicatorSize: TabBarIndicatorSize.label,
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Color(0xFFF2DD80)),
                tabs: [
                  Tab(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border:
                              Border.all(color: Color(0xFF639458), width: 1)),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("ข้าวสวย"),
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border:
                              Border.all(color: Color(0xFF639458), width: 1)),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("ข้าวเหนียว"),
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border:
                              Border.all(color: Color(0xFF639458), width: 1)),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("สรุปยอด"),
                      ),
                    ),
                  ),
                ]),
          ),
          body: TabBarView(children: [
            RicePretty(),
            StickyRice(),
            Result(),
          ]),
        ));
  }
}
