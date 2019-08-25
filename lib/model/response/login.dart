class Login{
  String id;

  Login.fromJson(Map<String, dynamic> json){
    this.id= json['id'];
  }
}