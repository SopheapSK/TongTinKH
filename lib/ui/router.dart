
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ton_tin_local/ui/views/add_properties.dart';
import 'package:ton_tin_local/ui/views/home_list.dart';

​
class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/' :
        return  MaterialPageRoute(
          builder: (_)=>  ListPage(title: ' Personal ')
        );
      case '/home_tong_tin' :
        return  MaterialPageRoute(
            builder: (_)=>  ListPage(title: ' Personal ')
        );


      case '/create' :
        return MaterialPageRoute(
            builder: (_)=>  CreateProperty()
        ) ;

        //CreateProperty
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(
                child: Text('No route defined for ${settings.name}'),
              ),
            ));
    }
  }
}

