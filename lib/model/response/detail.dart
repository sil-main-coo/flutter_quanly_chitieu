class Detail{
  String id, money, detail;

  Detail(this.id, this.money, this.detail);

  Detail.fromJson(Map<String, dynamic> json){
    this.id= json['id_thu'] ?? json['id_chi'];
    this.money= json['money'];
    this.detail= json['detail'];
  }
}