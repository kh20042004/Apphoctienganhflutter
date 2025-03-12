import 'package:flutter/material.dart';
import '../screen/home/home_screen.dart';
import '../screen/product/product_detail_screen.dart' as product;

class AppRoutes {
  static final Map<String, WidgetBuilder> routes = {
    "/": (context) => HomeScreen(),
    "/product-detail": (context) => product.ProductDetailScreen(),
  };
}
