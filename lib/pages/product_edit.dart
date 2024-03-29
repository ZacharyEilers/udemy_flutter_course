import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import '../models/product.dart';
import '../scoped-models/main.dart';

class ProductEditPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProductEditPageState();
  }
}

class _ProductEditPageState extends State<ProductEditPage> {
  //the map takes two generics, the first one is the key, the second one
  //is the type of values that will be stored.
  //So, for this Map, we have String keys, but dynamic values
  final Map<String, dynamic> _formData = {
    'title': null,
    'description': null,
    'price': null,
    'image': 'assets/food.jpg'
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildTitleTextField(Product product) {
    return TextFormField(
        decoration: InputDecoration(labelText: "Product Title"),
        initialValue: product == null ? '' : product.title.toString(),
        //return null or don't return anything if the validation succeeds.
        //if there is something wrong with the input, then the string returned
        //will be the error message shown to the user
        validator: (String value) {
          if (value.isEmpty || value.length < 5) {
            return 'Title is required and must be 5+ characters long';
          }
        },
        onSaved: (String value) {
          _formData['title'] = value;
        });
  }

  Widget _buildDescriptionTextField(Product product) {
    return TextFormField(
        decoration: InputDecoration(labelText: "Product Description"),
        initialValue: product == null ? '' : product.description.toString(),
        maxLines: 4,
        validator: (String value) {
          if (value.isEmpty || value.length < 10) {
            return 'Description is required and must be 10+ characters long';
          }
        },
        onSaved: (String value) {
          _formData['description'] = value;
        });
  }

  Widget _buildPriceTextField(Product product) {
    return TextFormField(
        decoration: InputDecoration(labelText: "Product Price"),
        initialValue: product == null ? '' : product.price.toString(),
        keyboardType: TextInputType.number,
        validator: (String value) {
          //the regex checks if the input is a number
          if (value.isEmpty ||
              !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value)) {
            return 'Price is required and must be a number';
          }
        },
        onSaved: (String value) {
          _formData['price'] = double.parse(value);
        });
  }

  Widget _buildSubmitButton() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return RaisedButton(
          child: Text("Save"),
          textColor: Colors.white,
          onPressed: () => _submitForm(model.addProduct, model.updateProduct, model.selectProduct,
              model.selectedProductIndex),
        );
      },
    );
  }

  Widget _buildPageContent(BuildContext context, Product product) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
            margin: EdgeInsets.all(20.0),
            child: Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
                  children: <Widget>[
                    _buildTitleTextField(product),
                    _buildDescriptionTextField(product),
                    _buildPriceTextField(product),
                    SizedBox(height: 10.0),
                    _buildSubmitButton()
                  ],
                ))));
  }

  void _submitForm(Function addProduct, Function updateProduct, Function setSelectedProduct, [int selectedProductIndex]) {
    //will not save the values if the form values are not valid
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    //if widget.product exists, it means we passed in a product to be edited, which means
    //that we are editing a product, not creating a new one
    if (selectedProductIndex == null) {
      addProduct(
        _formData['title'],
        _formData['description'],
        _formData['image'],
        _formData['price'],
      );
    } else {
      updateProduct(_formData['title'], _formData['description'],
          _formData['image'], _formData['price']);
    }
    Navigator.pushReplacementNamed(context, "/products").then((_)=> setSelectedProduct(null));
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        final Widget pageContent = _buildPageContent(context, model.selectedProduct);
        if (model.selectedProductIndex == null) {
          return Scaffold(body: pageContent);
        } else {
          return Scaffold(appBar: AppBar(title: Text("Edit Product")), body: pageContent);
        }
      },
    );
  }
}
