import 'package:flutter/material.dart';

class Product {
  final String title;
  final String description;
  final double price;
  final String image;
  final bool isFavorite;
  final userEmail;
  final userId;

  Product({@required this.title,
           @required this.description,
           @required this.price,
           @required this.image,
           @required this.userEmail,
           @required this.userId,
           this.isFavorite = false});
}
