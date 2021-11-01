import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_project/model/resultChart.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class SalesResult extends StatefulWidget {
  SalesResult({Key key}) : super(key: key);

  @override
  _SalesResultState createState() => _SalesResultState();
}

RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
Function mathFunc = (Match match) => '${match[1]},';

class _SalesResultState extends State<SalesResult> {
  List<charts.Series<ResultChaert, String>> _salesResultState;
  List<ResultChaert> myBoo;
  _generateData(myBoo) {
    _salesResultState = List<charts.Series<ResultChaert, String>>();
    _salesResultState.add(charts.Series(
        domainFn: (ResultChaert sales, _) => sales.resultMount,
        measureFn: (ResultChaert sales, _) => sales.sum,
        colorFn: (ResultChaert sales, _) =>
            charts.ColorUtil.fromDartColor(Color(int.parse(sales.colors))),
        id: 'sales',
        data: myBoo,
        labelAccessorFn: (ResultChaert row, _) =>
            '${row.sum.toString().replaceAllMapped(reg, mathFunc)}'));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('ข้อมูลเปรียบเทียบ'),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection('result').get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        } else {
          List<ResultChaert> salesResult = snapshot.data.docs
              .map((documentSnapshot) =>
                  ResultChaert.fromMap(documentSnapshot.data()))
              .toList();
          return _buildChart(context, salesResult);
        }
      },
    );
  }

  Widget _buildChart(BuildContext context, List<ResultChaert> salesResult) {
    myBoo = salesResult;
    _generateData(myBoo);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 10),
                child: Text('เปรีบยเทียบยอดขาย / เดือน',
                    style: TextStyle(fontSize: 30)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 550,
                  child: charts.BarChart(
                    _salesResultState,
                    animate: true,
                    animationDuration: Duration(seconds: 1),
                    vertical: false,
                    barRendererDecorator: charts.BarLabelDecorator<String>(
                      labelAnchor: charts.BarLabelAnchor.middle,
                      labelPosition: charts.BarLabelPosition.auto,
                    ),
                    behaviors: [
                      charts.DatumLegend(
                        // entryTextStyle: charts.TextStyleSpec(fontFamily: 'Kanit'),
                        outsideJustification: charts.OutsideJustification.start,
                        horizontalFirst: false,
                        desiredMaxRows: 3,
                        cellPadding: EdgeInsets.all(5),
                        position: charts.BehaviorPosition.bottom,
                      ),
                    ],
                    // defaultRenderer: charts.ArcRendererConfig(
                    //     arcWidth: 50,
                    //     arcRendererDecorators: [
                    //       charts.ArcLabelDecorator(
                    //         labelPosition: charts.ArcLabelPosition.outside,
                    //       ),
                    //     ]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
