class ResultChaert {
  final int sum;
  final String colors;
  final String resultMount;
  ResultChaert({this.sum, this.colors, this.resultMount});

  ResultChaert.fromMap(Map<String, dynamic> map)
      : assert(map['sum'] != null),
        assert(map['colors'] != null),
        assert(map['resultMount'] != null),
        sum = map['sum'],
        colors = map['colors'],
        resultMount = map['resultMount'];

  @override
  String toString() => "Record<$sum:$resultMount>";
}

// class ResultChaert {
//   int sum;
//   String colors;
//   String resultMount;

//   ResultChaert.fromMap(Map<String, dynamic> data){
//     this.sum = data['sum'];
//     this.colors = data['colors'];
//     this.resultMount = data['resultMount'];
//   }
// }
