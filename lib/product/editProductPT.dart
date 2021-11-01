import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_project/model/ptrice.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DetailsProduct extends StatefulWidget {
  // DetailsProduct({Key key, Ptrice ptricedata}) : super(key: key);

  final Ptrice ptricedata;
  final docs;

  DetailsProduct({this.ptricedata, this.docs});

  @override
  _DetailsProductState createState() => _DetailsProductState();
}

class _DetailsProductState extends State<DetailsProduct> {
  CollectionReference addDatoToFirebase =
      FirebaseFirestore.instance.collection('glutinous_rice');
  PickedFile imageFile;

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  var urlPicture;

  bool textOnSave() {
    final form = formkey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  _openGallary(BuildContext context) async {
    var picture = await _picker.getImage(source: ImageSource.gallery);
    this.setState(() {
      imageFile = picture;
    });
    Navigator.of(context).pop();
  }

  _openCamera(BuildContext context) async {
    var picture = await _picker.getImage(source: ImageSource.camera);
    this.setState(() {
      imageFile = picture;
    });
    Navigator.of(context).pop();
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('เลือกรายการ'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                GestureDetector(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Icon(Icons.image), Text('Gallary')],
                  ),
                  onTap: () {
                    _openGallary(context);
                  },
                ),
                Divider(),
                // Container(height: 10,),
                GestureDetector(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Icon(Icons.camera_alt), Text('Camera')],
                  ),
                  onTap: () {
                    _openCamera(context);
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _deleteProduct(BuildContext context) async {
    if (widget.ptricedata.image != null) {
      StorageReference storageReference = await FirebaseStorage.instance
          .getReferenceFromUrl(widget.ptricedata.image);
      await storageReference.delete();
    }
    var count = 0;
    return addDatoToFirebase
        .doc(widget.docs)
        .delete()
        .then((value) => Navigator.popUntil(context, (route) {
              return count++ == 2;
            }))
        // .then((value) => {Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName))})
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> _confirm(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('รายการนี้จะถูกลบ'),
            content: Text('ฮั่นแน่ดูเมือนคุณอยากจะลบรายการนี้นะ'),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('ยกเลิก'),
                textColor: Colors.grey,
                disabledColor: Colors.grey,
              ),
              FlatButton(
                onPressed: () {
                  _deleteProduct(context);
                },
                child: Text('ยืนยัน'),
                textColor: Colors.red,
                splashColor: Colors.black,
              )
            ],
          );
        });
  }

  Future<void> _upLoadPictureToStrang() async {
    Random random = Random();
    int i = random.nextInt(10000);

    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    StorageReference storageReference =
        firebaseStorage.ref().child('product/product$i.png');
    StorageUploadTask storageUploadTask =
        storageReference.putFile(File(imageFile.path));

    urlPicture =
        await (await storageUploadTask.onComplete).ref.getDownloadURL();
    print('$urlPicture');
    return addDatoToFirebase
        .doc(widget.docs)
        .update({
          'image': urlPicture,
        })
        .then((value) => {Navigator.pop(context)})
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> _addDataTofirebase() async {
    if (textOnSave()) {
      try {
        formkey.currentState.save();
        return addDatoToFirebase
            .doc(widget.docs)
            .update({
              'name': widget.ptricedata.name,
              'details': widget.ptricedata.details,
              'setproduct': widget.ptricedata.setproduct,
              'price': widget.ptricedata.price,
            })
            .then((value) => {Navigator.pop(context)})
            .catchError((error) => print("Failed to add user: $error"));
      } catch (e) {
        print('Error: $e'.toString());
        // setState(() {
        //   _error = e.message;
        // });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text(
          'แก้ไขสินค้า',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          color: Colors.white,
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: InkWell(
              onTap: () {
                _confirm(context);
              },
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
          )
        ],
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: formkey,
          child: ListView(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    height: 300,
                    width: double.infinity,
                    // color: Colors.grey[400],
                    child: imageFile == null
                        ? Image.network('${widget.ptricedata.image}')
                        : Image.file(File(imageFile.path)),
                  ),
                  FlatButton.icon(
                    icon: Icon(Icons.edit),
                    label: Text('แก้ไขรูปภาพ'),
                    color: Color.fromRGBO(100, 100, 100, 0.75),
                    textColor: Colors.white,
                    disabledColor: Colors.white,
                    disabledTextColor: Colors.black,
                    onPressed: () {
                      _showChoiceDialog(context);
                      print('image');
                    },
                  )
                ],
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'ชื่อสินค้า'),
                initialValue: widget.ptricedata.name,
                validator: (String value) =>
                    value.isEmpty ? 'กรุณาใส่ชื่อสินค้า' : null,
                onSaved: (String value) => {widget.ptricedata.name = value},
              ),
              TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(labelText: 'รายละเอียดสินค้า'),
                initialValue: widget.ptricedata.details,
                validator: (String value) =>
                    value.isEmpty ? 'กรุณาใส่รายละเอียดสินค้า' : null,
                onSaved: (String value) => {widget.ptricedata.details = value},
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration:
                    InputDecoration(labelText: 'น้ำหนัก', hintText: 'กิโลกรัม'),
                initialValue: widget.ptricedata.setproduct,
                validator: (String value) =>
                    value.isEmpty ? 'กรุณาใส่น้ำหนักสินค้า' : null,
                onSaved: (String value) =>
                    {widget.ptricedata.setproduct = value},
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'ราคา', hintText: 'บาท'),
                initialValue: widget.ptricedata.price,
                validator: (String value) =>
                    value.isEmpty ? 'กรุณาใส่ราคาสินค้า' : null,
                onSaved: (String value) => {widget.ptricedata.price = value},
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: InkWell(
                  onTap: () async {
                    if (urlPicture == null) {
                      urlPicture = widget.ptricedata.image.toString();
                    }
                    _upLoadPictureToStrang();
                    _addDataTofirebase();
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 20),
                    height: 40,
                    width: double.infinity,
                    child: Center(
                        child: Text('ยืนยันการแก้ไขสินค้า',
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
