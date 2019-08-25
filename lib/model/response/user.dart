class UserResponse{
  String id, name, userName, year, card, money_card, money_face;

  UserResponse.fromJson(Map<String, dynamic> json){
    this.id= json['id'];
    this.name= json['name'];
    this.userName= json['user_name'];
    this.year= json['year'];
    this.card= json['card'];
    this.money_card= json['money_card'];
    this.money_face= json['money_face'];
  }
}