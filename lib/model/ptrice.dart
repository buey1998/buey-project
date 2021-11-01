class Ptrice {
  String details;
  String id;
  String image;
  String name;
  dynamic price;
  String setproduct;

  Ptrice.fromMap(Map<String, dynamic> data) {
    this.details = data['details'];
    this.id = data['id'];
    this.image = data['image'];
    this.name = data['name'];
    this.price = data['price'];
    this.setproduct = data['setproduct'];
  }
}
