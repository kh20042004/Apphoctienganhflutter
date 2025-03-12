import 'package:flutter/foundation.dart';

class UserProvider with ChangeNotifier {
  String _name = 'John Doe';
  String _email = 'john.doe@example.com';
  String _phone = '';
  String? _imagePath;

  String get name => _name;
  String get email => _email;
  String get phone => _phone;
   String? get imagePath => _imagePath;

  void updateProfile({
    required String name,
    required String email,
    required String phone,
    String? imagePath,
  }) {
    _name = name;
    _email = email;
    _phone = phone;
    _imagePath = imagePath;
    notifyListeners();
  }
}