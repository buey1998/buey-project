import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_project/product/loading/loading.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddproductSK extends StatefulWidget {
  AddproductSK({Key key}) : super(key: key);

  @override
  _AddproductSKState createState() => _AddproductSKState();
}

class _AddproductSKState extends State<AddproductSK> {
  CollectionReference addDatoToFirebase =
      FirebaseFirestore.instance.collection('cooked_rice');
  PickedFile imageFile;
  ImagePicker _picker = ImagePicker();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String nameProduct, detailsProduct, weightProduct;
  String priceProduct;

  var urlPicture;

  bool loader = false;

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
    // textOnSave();
    _addDataTofirebase();
  }

  Future<void> _addDataTofirebase() async {
    if (textOnSave()) {
      setState(() {
        loader = true;
      });
      try {
        Random random = Random();
        int i = random.nextInt(100) + 10;
        var radomIDproduct = ('product_0$i');

        return addDatoToFirebase
            .doc(radomIDproduct)
            .set({
              'image': urlPicture,
              'id': radomIDproduct,
              'name': nameProduct,
              'details': detailsProduct,
              'setproduct': weightProduct +' กิโลกรัม',
              'price': priceProduct,
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
    return loader
        ? Loader()
        : Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              brightness: Brightness.dark,
              title: Text(
                'ข้าวเหนียว',
                style: TextStyle(color: Colors.white),
              ),
              leading: IconButton(
                color: Colors.white,
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () => Navigator.of(context).pop(),
              ),
              centerTitle: true,
              backgroundColor: Colors.black,
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formkey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 20),
                            height: 300,
                            width: double.infinity,
                            child: imageFile == null
                                ? Center(child: Text('ไม่มีข้อมูลรูปภาพ'))
                                : Image.file(File(imageFile.path)),
                          ),
                          FlatButton.icon(
                            icon: Icon(Icons.image),
                            label: Text('เพิ่มรูปภาพ'),
                            color: Colors.indigo,
                            textColor: Colors.white,
                            disabledColor: Colors.white,
                            disabledTextColor: Colors.black,
                            onPressed: () {
                              _showChoiceDialog(context);
                            },
                          )
                        ],
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'ชื่อสินค้า'),
                        validator: (String value) =>
                            value.isEmpty ? 'กรุณาใส่ชื่อสินค้า' : null,
                        onSaved: (value) => nameProduct = value.trim(),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration:
                            InputDecoration(labelText: 'รายละเอียดสินค้า'),
                        validator: (String value) =>
                            value.isEmpty ? 'กรุณาใส่รายละเอียดสินค้า' : null,
                        onSaved: (value) => detailsProduct = value,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: 'น้ำหนัก', hintText: 'กิโลกรัม'),
                        validator: (String value) =>
                            value.isEmpty ? 'กรุณาใส่น้ำหนักสินค้า' : null,
                        onSaved: (value) => weightProduct = value.trim(),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration:
                            InputDecoration(labelText: 'ราคา', hintText: 'บาท'),
                        validator: (String value) =>
                            value.isEmpty ? 'กรุณาใส่ราคาสินค้า' : null,
                        onSaved: (value) => priceProduct = value.trim(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: InkWell(
                          onTap: () {
                            if (imageFile == null) {
                              _showAlertImage(context);
                            } else {
                              _upLoadPictureToStrang();
                              textOnSave();
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 20),
                            height: 40,
                            width: double.infinity,
                            child: Center(
                                child: Text('ยืนยันการบันทึกสินค้า',
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
            ),
          );
  }
}

Future<void> _showAlertImage(BuildContext context) async {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
              child: Text(
            'เกิดข้อผิดพลาด',
            style: TextStyle(color: Colors.red),
          )),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Icon(
                  Icons.block,
                  size: 100,
                  color: Colors.red,
                ),
                Divider(
                  color: Colors.white,
                ),
                Center(child: Text('เลือกรูปสินค้าก่อนกดบันทึก')),
                Divider(
                  color: Colors.white,
                ),
                FlatButton(
                    color: Colors.red,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('ตกลง', style: TextStyle(color: Colors.white)))
              ],
            ),
          ),
        );
      });
}
