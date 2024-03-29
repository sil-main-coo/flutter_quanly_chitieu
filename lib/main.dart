import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:quanly_chitieu/router.dart';
import 'package:quanly_chitieu/view/home.dart';
import 'package:quanly_chitieu/view/login.dart';

import 'blocs/bloc_detail.dart';
import 'blocs/bloc_status.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<StatusBloc>(builder: (_)=> StatusBloc(),),
        ChangeNotifierProvider<DetailBloc>(builder: (_)=> DetailBloc(),),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        onGenerateRoute: Router.onGenerateRoute,
        home: GetLocal(),
      ),
    );
  }
}

class GetLocal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
     final _sttBloc= StatusBloc.of(context);
     _sttBloc.getUserFromLocal();
     print(_sttBloc.user_name);
    return _sttBloc.user_name == null ? LoginPage() : HomePage();
  }
}

