import 'package:flutter/material.dart';
//import 'package:flutter/rendering.dart';

import 'package:scoped_model/scoped_model.dart';

//PAGES
import './pages/auth.dart';
import './pages/products_admin.dart';
import './pages/products.dart';
import './pages/product.dart';
import './models/product.dart';

import './scoped-models/main.dart';


void main() { 
  //debugPaintSizeEnabled = true; 
  // debugPaintBaselinesEnabled = true;
  // debugPaintPointersEnabled = true;
  runApp(MyApp());
} 

class MyApp extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyAppState();
  }
}
class _MyAppState extends State<MyApp>{

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: MainModel(),
      child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                brightness: Brightness.light,
                primarySwatch: Colors.deepOrange,
                accentColor: Colors.deepPurple,
                buttonColor: Colors.deepPurple,
              ),
              //home: AuthPage(),
              routes: {
                '/':(BuildContext context) => AuthPage(),
                '/products':(BuildContext context) => ProductsPage(),
                '/admin': (BuildContext context) => ProductsAdminPage(),
              },
              onGenerateRoute: (RouteSettings settings){
                final List<String> pathElements = settings.name.split('/');
                if(pathElements[0] != ''){
                  //executes onUnknownRoute
                  return null;
                }
                if(pathElements[1] == 'product'){
                  final int index = int.parse(pathElements[2]);
                  return MaterialPageRoute<bool>( 
                    builder: (BuildContext context) {
                      return ProductPage(index);
                    }
                  );
                }
                //executes onUnknownRoute
                return null;
              },
              onUnknownRoute: (RouteSettings settings){
                return MaterialPageRoute<bool>(
                  builder: (BuildContext context){
                    ProductsPage();
                  }
                );
              },
            )
    ); 
  }
}
