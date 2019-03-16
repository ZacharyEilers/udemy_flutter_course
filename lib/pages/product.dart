import 'dart:async';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../widgets/ui_elements/title_default.dart';

import '../models/product.dart';
import '../scoped-models/main.dart';
import '../scoped-models/connected_products.dart';

class ProductPage extends StatelessWidget {
 final int productIndex;

  ProductPage(this.productIndex);

  Widget _buildAddressPriceRow(double price){
     return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Union Square, San Francisco", style: TextStyle(fontFamily: "Oswald", color: Colors.black),),
          Container(margin: EdgeInsets.symmetric(horizontal: 5.0), child: Text("|", style: TextStyle(color: Colors.black)),),
          Text("\$${price.toString()}", style: TextStyle(fontFamily: 'Oswald', color: Colors.black),),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
        onWillPop: () {
          print("back button pressed");
          Navigator.pop(context, false);

          //the false tells flutter to not execute the default pop request from the back button
          //and to only use the custom request we have here
          return Future.value(false);
        },
        child: ScopedModelDescendant<MainModel>(
          builder: (BuildContext context, Widget child, MainModel model){
            final Product product = model.allProducts[productIndex];
            return Scaffold(
              appBar: AppBar(
                title: Text(product.title),
              ),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Image.asset(product.image),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: TitleDefault(product.title)
                  ),
                _buildAddressPriceRow(product.price),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Text(product.description, textAlign: TextAlign.center,),
                  )
                ],
              ));
          },
        )
    );
  }
}
