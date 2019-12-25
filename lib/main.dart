


import 'package:flutter/material.dart';
import 'package:ton_tin_local/ui/router.dart';

void main() {

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      return MaterialApp(
        onGenerateRoute: Router.generateRoute,
        initialRoute: '/create',

      );

  }
}
