class Detail{
  String id, money, detail, type_money, time;

  Detail(this.id, this.money, this.detail, this.type_money, this.time);

  Detail.fromJson(Map<String, dynamic> json){
    this.id= json['idthu'] ?? json['idchi'];
    this.type_money= json['type_money'];
    this.time= json['time'];
    this.money= json['money'];
    this.detail= json['detail'];
  }
}