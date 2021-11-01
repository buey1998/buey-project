class StatusOrder {
  int id;
  String status;

  StatusOrder(this.id, this.status);

  static List<StatusOrder> getStatus() {
    return <StatusOrder>[
      StatusOrder(1, 'ยืนยันรายการสั่งซื้อ'),
      StatusOrder(2, 'อยู่ในระหว่างการจัดส่ง'),
      StatusOrder(3, 'สำเร็จ'),
      StatusOrder(4, 'ยกเลิก'),
    ];
  }
}

class YersResult {
  int id;
  String yersResult;

  YersResult(this.id,this.yersResult);
  static List<YersResult> getYearsResult(){
    return <YersResult>[
      YersResult(1, '2021'),
      YersResult(2, '2022'),
      YersResult(3, '2023'),
      YersResult(4, '2024'),
      YersResult(5, '2025'),
      YersResult(6, '2026'),
      YersResult(7, '2027'),
    ];
  }

}