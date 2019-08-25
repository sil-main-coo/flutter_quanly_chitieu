class ValidationsAccount {
  static bool isValidFullname(String fullname){
    return fullname!=null && fullname.contains(" ") &&
        fullname.length>4 && fullname.length<50;
  }

  static bool isValidUser(String user){
    return user!=null && user.length > 2 ;
  }

  static bool isValidYear(String year){
    return year!=null && year.length == 4 ;
  }

  static bool isValidNotEmpty(String s){
    return s!=null && s.length > 0 ;
  }

  static bool isValidCardNumber(String card){
    return card!=null && card.length > 7 ;
  }

  static bool isValidPwd(String pwd){
    return pwd!=null && pwd.length>5;
  }
}