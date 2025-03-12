import 'package:flutter/material.dart';
import '../routes/app_routes.dart';
import 'package:provider/provider.dart';
import 'screen/widgets/theme_dark.dart';
import 'screen/product/language_setting.dart';
import 'screen/product/user_provider.dart';
import 'screen/product/cart_provider.dart' as provider;
import 'screen/product/wishlist_provider.dart' as provider;
import 'screen/home/cart_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => provider.CartProvider()),
        ChangeNotifierProvider(create: (_) => provider.WishlistProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Shopping App',
          theme: themeProvider.theme,
          routes: AppRoutes.routes,
          initialRoute: "/",
        );
      },
    );
  }
}
