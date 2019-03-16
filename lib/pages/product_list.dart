import 'package:flutter/material.dart';

import './product_edit.dart';

import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';

class ProductListPage extends StatelessWidget {


  void _navigateToEditPage(BuildContext context, int index, MainModel model){
    Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context) {
        return ProductEditPage();
      })
    ).then((_){
        model.selectProduct(null);
    });
  }

  Widget _buildEditButton(BuildContext context, int index, MainModel model){
      return IconButton(
        icon: Icon(Icons.edit),
        onPressed: (){
          model.selectProduct(index);
          _navigateToEditPage(context, index, model);
        }
      );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(builder: (BuildContext context, Widget child, MainModel model){
      return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            //flutter just needs us to give it a unique identifier for this dismissible widget
            key: Key(model.allProducts[index].title),
            onDismissed: (DismissDirection direction){
                if(direction == DismissDirection.endToStart){
                  model.selectProduct(index);
                  model.deleteProduct(index);
                } else if(direction ==DismissDirection.startToEnd){
                  model.selectProduct(index);
                  model.deleteProduct(index);
                }
            },
            background: Container(color: Colors.red,),
              child: Column( children: <Widget> [
                ListTile(
                  leading: CircleAvatar(backgroundImage: AssetImage(model.allProducts[index].image)),
                  title: Text(model.allProducts[index].title),
                  subtitle: Text("\$${model.allProducts[index].price.toString()}"),
                  trailing: _buildEditButton(context, index, model)
                ),
                Divider()
              ]
            )
          );
        },
        itemCount: model.allProducts.length,
      );
    });
  }
}
