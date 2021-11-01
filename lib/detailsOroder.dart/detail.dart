// import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_project/detailsOroder.dart/classButton.dart';
import 'package:ecommerce_project/model/order.dart';
import 'package:flutter/material.dart';

class DetailsOrder extends StatefulWidget {
  // DetailsOrder({Key key, Order orderdata, String docs}) : super(key: key);
  final Order orderdata;
  final docs;
  DetailsOrder({this.docs, this.orderdata});

  @override
  _DetailsOrderState createState() => _DetailsOrderState();
}

class _DetailsOrderState extends State<DetailsOrder> {
  List<StatusOrder> _status = StatusOrder.getStatus();
  List<DropdownMenuItem<StatusOrder>> _dropdonwitems;
  StatusOrder _selectedStatus;
  List<OrderList> listdata = [];

  @override
  void initState() {
    _dropdonwitems = buildDropdonwMenuItem(_status);
    _selectedStatus = _dropdonwitems[0].value;
    super.initState();
  }

  List<DropdownMenuItem<StatusOrder>> buildDropdonwMenuItem(List status) {
    List<DropdownMenuItem<StatusOrder>> item = List();
    for (StatusOrder status in status) {
      item.add(DropdownMenuItem(
        value: status,
        child: Text(status.status),
      ));
    }
    return item;
  }

  onChangeDropdonwItem(StatusOrder selectStatus) {
    setState(() {
      _selectedStatus = selectStatus;
    });
  }

  Future<void> addStatus() async {
    return await FirebaseFirestore.instance
        .collection('myorder')
        .doc(widget.docs)
        .update({
          'status': _selectedStatus.status,
        })
        .then((value) => {Navigator.pop(context)})
        .catchError((error) => print("Failed to update: $error"));
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actions: [
            RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  side: BorderSide(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
              },
              color: Colors.red,
              textColor: Colors.white,
              child: Text("ปิด".toUpperCase(), style: TextStyle(fontSize: 14)),
            ),
          ],
          title: Center(
              child: Text(
            'รายการสินค้า',
            style: TextStyle(color: Color(0xFF639458)),
          )),
          content: SingleChildScrollView(
              child: Container(
            // color: Colors.teal,
            width: 800,
            height: 500,
            child: ListView.builder(
                itemCount: widget.orderdata.list.length,
                itemBuilder: (context, index) {
                  OrderList orderList = widget.orderdata.list[index];
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                                // color: Colors.indigoAccent,
                                width: 110,
                                height: 140,
                                child: Image.network(
                                  '${orderList.imageproduct}',
                                  loadingBuilder: (context, child, progress) {
                                    return progress == null
                                        ? child
                                        : Center(
                                            child: CircularProgressIndicator());
                                  },
                                )),
                            Expanded(
                              child: Container(
                                height: 150,
                                // color: Colors.grey,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'ชื่อสินค้า : '
                                      '${orderList.nameproduct}',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                        'รหัสสินค้า : '
                                        '${orderList.idproduct}',
                                        style: TextStyle(fontSize: 13)),
                                    Text('จำนวน : ' '${orderList.amount}',
                                        style: TextStyle(fontSize: 13)),
                                    Text('ราคา : ' '${orderList.price}',
                                        style: TextStyle(fontSize: 13)),
                                    Text(
                                        'ราคารวมของสินค้านี้ : '
                                        '${orderList.total}',
                                        style: TextStyle(fontSize: 13)),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        Divider(),
                      ],
                    ),
                  );
                }),
          )),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายละเอียดการสั่งสินค้า'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('วิธีการชำระเงิน'),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('${widget.orderdata.payment}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            fontSize: 16)),
                  )
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('สถานะ'),
                  Text('${widget.orderdata.status}',
                      style: TextStyle(fontSize: 16))
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('รหัสออเดอร์'),
                  Text('${widget.orderdata.orderid}',
                      style: TextStyle(fontSize: 16))
                ],
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text('รายการสินค้า '
                    ' ${widget.orderdata.list.length.toString()} '
                    ' รายการ'),
              ),
              Container(
                  color: Colors.white,
                  width: double.infinity,
                  height: 200,
                  child: GestureDetector(
                    onTap: () {
                      _showChoiceDialog(context);
                    },
                    child: ListView.builder(
                        itemCount: widget.orderdata.list.length,
                        itemBuilder: (context, index) {
                          OrderList orderList = widget.orderdata.list[index];
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(5, 20, 5, 0),
                            child: Row(
                              children: [
                                Container(
                                    // color: Colors.indigoAccent,
                                    width: 150,
                                    height: 150,
                                    child: Image.network(
                                      '${orderList.imageproduct}',
                                      loadingBuilder:
                                          (context, child, progress) {
                                        return progress == null
                                            ? child
                                            : Center(
                                                child:
                                                    CircularProgressIndicator());
                                      },
                                    )),
                                Expanded(
                                  child: Container(
                                    height: 140,
                                    // color: Colors.grey,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'ชื่อสินค้า : '
                                          '${orderList.nameproduct}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text('รหัสสินค้า : '
                                            '${orderList.idproduct}'),
                                        Text('จำนวน : ' '${orderList.amount}'),
                                        Text('ราคา : ' '${orderList.price}'),
                                        Text('ราคารวมของสินค้านี้ : '
                                            '${orderList.total}'),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        }),
                  )),
              Divider(
                height: 30,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('ราคารวมทั้งหมด   '),
                    Text('${widget.orderdata.summary}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: Color(0xFF639458))),
                    Text('   บาท')
                  ],
                ),
              ),
              Divider(
                height: 30,
              ),
              Text('ที่อยู่ที่จะจัดส่ง', style: TextStyle(fontSize: 18)),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('วันเวลาที่สั่งสินค้า : ' '${widget.orderdata.date}'),
                    Text('ชื่อผู้รับ : ' '${widget.orderdata.name}'),
                    Text('เบอร์โทร : ' '${widget.orderdata.phone}'),
                    Text('ข้อมูลที่อยู่ : ' '${widget.orderdata.adressed}'),
                    Text('แขวง/ตำบล : ' '${widget.orderdata.tumbon}'),
                    Text('เขต/อำเภอ : ' '${widget.orderdata.district}'),
                    Text('จังหวัด : ' '${widget.orderdata.province}'),
                    // Text('รหัสไปรษณี : '),
                    Text(
                      '*หมายเหตุ : ' '${widget.orderdata.note}',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 30,
              ),
              Text('หลักฐานการโอนเงิน', style: TextStyle(fontSize: 18)),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Center(
                  child: Container(
                    // color: Colors.white,
                    // height: 500,
                    width: double.infinity,
                    child: Image.network(
                      '${widget.orderdata.slip}',
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        return progress == null
                            ? child
                            : Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace stackTrace) {
                        return Text('*ไม่มีรูปภาพ',
                            style: TextStyle(
                              color: Colors.red,
                            ));
                      },
                    ),
                  ),
                ),
              ),
              Divider(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('เปลี่ยนสถานะ      '),
                  DropdownButton(
                    hint: const Text('เลือกรายการ'),
                    items: _dropdonwitems,
                    onChanged: onChangeDropdonwItem,
                    value: _selectedStatus,
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: InkWell(
                  onTap: addStatus,
                  child: Container(
                    height: 40,
                    width: double.infinity,
                    child: Center(
                        child: Text('ยืนยันการเปลี่ยนสถานะ',
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
}
