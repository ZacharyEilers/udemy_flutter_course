import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import './price_tag.dart';
import '../../models/product.dart';
import '../../scoped-models/main.dart';
import './product_card.dart';
class Products extends StatelessWidget {
  
  Widget _buildProductList(List<Product> products) {
    Widget productCards;
    if (products.length > 0) {
      productCards = ListView.builder(
        itemBuilder: (BuildContext context, int index) => ProductCard(products[index], index),
        itemCount: products.length,
      );  
    } else {
      productCards = Center(child: Text("No Products Found, Please Add Some"));
    }
    return productCards;
  }

  @override
  Widget build(BuildContext context) {
    print('products Widget Build');

    return ScopedModelDescendant<MainModel>(builder: (BuildContext context, Widget child, MainModel model){
      return _buildProductList(model.displayedProducts);
    });
  }
}
