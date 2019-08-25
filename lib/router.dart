
import 'package:flutter/material.dart';
import 'package:quanly_chitieu/view/home.dart';
import 'package:quanly_chitieu/view/login.dart';
import 'package:quanly_chitieu/view/register.dart';

import 'main.dart';

class Router{
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {

    switch(settings.name){
      case '/': return MaterialPageRoute(builder: (_) => MyApp());
      case '/home': return MaterialPageRoute(builder: (_) => HomePage());
      case '/login': return MaterialPageRoute(builder: (_) => LoginPage());
      case '/register': return MaterialPageRoute(builder: (_) => RegisterPage());

     default: return MaterialPageRoute(
         builder: (_)=> Scaffold(
           body: Center(
             child: Text("Not yet define page"),
           ),
         )
     );
    }
  }
}