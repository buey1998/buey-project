// class Order {
//   String adressed;
//   String date;
//   String district;
//   String name;
//   String note;
//   String orderid;
//   String payment;
//   String phone;
//   String province;
//   String slip;
//   int summary;
//   String tumbon;
//   String status;
//   List list;

//   Order.fromMap(Map<String, dynamic> data) {
//     this.adressed = data['adressed'];
//     this.date = data['date'];
//     this.district = data['district'];
//     this.name = data['name'];
//     this.note = data['note'];
//     this.orderid = data['orderId'];
//     this.payment = data['payment'];
//     this.phone = data['phone'];
//     this.province = data['province'];
//     this.slip = data['slip'];
//     this.summary = data['summary'];
//     this.tumbon = data['tumbon'];
//     this.status = data['status'];
//     this.list = data['list'];
//   }
// }

class Order {
  String adressed;
  String date;
  String district;
  String name;
  String note;
  String orderid;
  String payment;
  String phone;
  String province;
  String slip;
  int summary;
  String tumbon;
  String status;
  List<OrderList> list;

  Order.fromMap(Map<String, dynamic> data) {
    this.adressed = data['adressed'];
    this.date = data['date'];
    this.district = data['district'];
    this.name = data['name'];
    this.note = data['note'];
    this.orderid = data['orderId'];
    this.payment = data['payment'];
    this.phone = data['phone'];
    this.province = data['province'];
    this.slip = data['slip'];
    this.summary = data['summary'];
    this.tumbon = data['tumbon'];
    this.status = data['status'];
    this.list = List<OrderList>.from(data['list'].map((x) => OrderList.fromMap(x)));
  }
}

class OrderList {
  int amount;
  String idproduct;
  String imageproduct;
  String nameproduct;
  int price;
  int total;

  OrderList.fromMap(Map<String, dynamic> datalist) {
    this.amount = datalist['amount'];
    this.idproduct = datalist['idproduct'];
    this.imageproduct = datalist['imageproduct'];
    this.nameproduct = datalist['nameproduct'];
    this.price = datalist['price'];
    this.total = datalist['total'];
  }
}
