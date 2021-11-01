import 'package:ecommerce_project/product/productPage/productBar.dart';
import 'package:ecommerce_project/search/search.dart';
import 'package:ecommerce_project/statuspage/alreadyPay.dart';
import 'package:ecommerce_project/statuspage/deilverd.dart';
import 'package:ecommerce_project/statuspage/dismissOrder.dart';
import 'package:ecommerce_project/statuspage/listOrder.dart';
import 'package:ecommerce_project/statuspage/packing.dart';
import 'package:ecommerce_project/statuspage/paymentOnDestination.dart';
import 'package:ecommerce_project/statuspage/shipped.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Kanit',
        primaryColor: Color(0xFFDECAF1),
        accentColor: Color(0xFFDECAF1),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: Padding(
                padding: const EdgeInsets.only(top: 10, left: 10),
                child: InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Products()));
                    },
                    child: Text('สินค้า'))),
            actions: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Search()));
                    },
                    child: Text('ค้นหา')),
              ),
            ],
            backgroundColor: Color(0xFF639458),
            elevation: 0,
            centerTitle: true,
            toolbarHeight: 150,
            title: Center(
                child: Image.asset(
              'assets/fronts/image/brand.png',
              height: 100,
            )),
            bottom: PreferredSize(
                child: TabBar(
                    labelColor: Colors.black,
                    isScrollable: true,
                    unselectedLabelColor: Colors.white.withOpacity(0.8),
                    indicator: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        color: Colors.white),
                    tabs: [
                      Tab(
                        child: Text('รายการสั่งสินค้า'),
                      ),
                      Tab(
                        child: Text('ชำระเงินแล้ว'),
                      ),
                      Tab(
                        child: Text('ชำระเงินปลายทาง'),
                      ),
                      Tab(
                        child: Text('ยืนยันรายการสั่งซื้อ'),
                      ),
                      Tab(
                        child: Text('อยู่ในระหว่างการจัดส่ง'),
                      ),
                      Tab(
                        child: Text('สำเร็จ'),
                      ),
                      Tab(
                        child: Text('ยกเลิก'),
                      )
                    ]),
                preferredSize: Size.fromHeight(30.0)),
          ),
          body: TabBarView(
            children: <Widget>[
              ListOrder(),
              AlreadyPay(),
              PaymentOnDestination(),
              Packing(),
              Shipped(),
              Deilvered(),
              DismissOrder(),
            ],
          )),
    );
  }
}
