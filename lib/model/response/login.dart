class Login{
  String user_name;

  Login.fromJson(Map<String, dynamic> json){
    this.user_name= json['user_name'];
  }
}