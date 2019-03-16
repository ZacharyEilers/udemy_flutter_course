import 'dart:convert';
import 'dart:async';

import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
//import 'package:dio/dio.dart';

import '../models/product.dart';
import '../models/user.dart';

mixin ConnectedProductsModel on Model {
  List<Product> _products = [];
  User _authenticatedUser;
  int _selProductIndex;

  void addProduct(String title, String description, String image, double price) {
    print("AuthenticatedUserEmail: ${_authenticatedUser.email}");

    final Map<String, String> productData = {
      'title': title,
      'description': description,
      'image': "https://static.scientificamerican.com/sciam/cache/file/BCC3BD1E-5DC0-4843-A841706AE575C694_source.jpg?w=590&h=800&39BBF62E-5F96-4C6A-A59590CCF416DA11",
      'price': price.toString()
    };
    print(json.encode(productData));

    Future<String> postData() async{
      http.Response response = await http.post(
        Uri.encodeFull("https://flutter-products-bebf3.firebaseio.com/products.json")
      );

      print(response.body);
    }

    postData();

    //http.post("https://flutter-products-bebf3.firebaseio.com/products.json", body: json.encode(productData) );

    final Product newProduct = Product(
        title: title,
        description: description,
        image: image,
        price: price,
        userEmail: _authenticatedUser.email,
        userId: _authenticatedUser.id);

    _products.add(newProduct);
    //_selProductIndex = null;

    notifyListeners();
  }
}

mixin ProductsModel on ConnectedProductsModel{
  bool _showFavorites = false;

  List<Product> get allProducts{
    //List.from creates a copy of a list, which is helpful so that we don't create
    //a pointer to the same list in memory.
    return List.from(_products);
  }

  List<Product> get displayedProducts{
    //List.from creates a copy of a list, which is helpful so that we don't create
    //a pointer to the same list in memory.
    if(_showFavorites){
      return List.from( _products.where((Product product) => product.isFavorite).toList() );
    }
    return List.from(_products);
  }

  int get selectedProductIndex{
    return _selProductIndex;
  }

  Product get selectedProduct{
    if(selectedProductIndex == null){
      return null;
    }
    return _products[selectedProductIndex];
  }

  bool get displayFavoritesOnly{
    return _showFavorites;
  }

  void updateProduct( String title, String description, String image, double price){
    final Product updatedProduct = Product(
        title: title,
        description: description,
        image: image,
        price: price,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId);

    _products[selectedProductIndex] = updatedProduct;
    
  }

  void deleteProduct(int index){
    _products.removeAt(index);
    notifyListeners();
  }

  void selectProduct(int index){
    _selProductIndex = index;
    if(index != null){
      notifyListeners();
    }
  }

  void toggleProductFavoriteStatus(){
    final bool isCurrentlyFavorite = _products[selectedProductIndex].isFavorite;
    final bool newFavoriteStatus = !isCurrentlyFavorite;

    final Product updatedProduct = Product(
        title: selectedProduct.title,
        description: selectedProduct.description,
        price:selectedProduct.price,
        image: selectedProduct.image,
        isFavorite: newFavoriteStatus,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId
      );
    _products[selectedProductIndex] = updatedProduct;
    notifyListeners();
  }

  void toggleDisplayMode(){
    _showFavorites = !_showFavorites;
    notifyListeners();
  }
}

mixin UserModel on ConnectedProductsModel{
  void login(String email, String password){
    _authenticatedUser = User(id: 'abcd', email: email, password: password);
    print("AuthenticatedUserEmail: ${_authenticatedUser.email}");
  }
}