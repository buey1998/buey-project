import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loader extends StatefulWidget {
  Loader({Key key}) : super(key: key);

  @override
  _LoaderState createState() => _LoaderState();
}

class _LoaderState extends State<Loader> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(child: Text('กำลังประมวลผล รอสักครูนะคะ')),
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: SpinKitDoubleBounce(
                    color: Colors.black,
                    size: 50,
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
