import 'package:flutter/foundation.dart';

class CartProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _items = [];

  List<Map<String, dynamic>> get items => _items;

  // Phương thức thêm một sản phẩm vào giỏ hàng
void addItem(Map<String, dynamic> product) {
  // Kiểm tra nếu sản phẩm đã có trong giỏ hàng hay chưa
  final existingIndex =
      _items.indexWhere((item) => item['name'] == product['name']);
  if (existingIndex >= 0) {
    // Nếu sản phẩm đã có trong giỏ, tăng số lượng của sản phẩm lên 1
    _items[existingIndex]['quantity'] =
        (_items[existingIndex]['quantity'] ?? 0) + 1;
  } else {
    // Nếu sản phẩm chưa có, thêm sản phẩm mới vào giỏ hàng với số lượng 1
    _items.add({
      ...product, // Sao chép tất cả các thuộc tính của sản phẩm
      'quantity': 1, // Thiết lập số lượng của sản phẩm là 1
    });
  }
  print('Added item: ${product['name']}, Cart size: ${_items.length}');
  notifyListeners(); // Thông báo cho các widget lắng nghe sự thay đổi
}

// Phương thức cập nhật số lượng của một sản phẩm trong giỏ hàng
void updateQuantity(Map<String, dynamic> item, int quantity) {
  // Tìm kiếm chỉ số của sản phẩm cần cập nhật
  final index = _items.indexWhere((i) => i['name'] == item['name']);
  if (index >= 0) {
    if (quantity <= 0) {
      // Nếu số lượng nhỏ hơn hoặc bằng 0, xóa sản phẩm khỏi giỏ hàng
      _items.removeAt(index);
    } else {
      // Cập nhật số lượng của sản phẩm
      _items[index]['quantity'] = quantity;
    }
    notifyListeners(); // Thông báo cho các widget lắng nghe sự thay đổi
  }
}

// Phương thức tính tổng giá trị giỏ hàng
double getTotal() {
  return _items.fold(
      0, // Bắt đầu từ tổng = 0
      (total, item) =>
          total + (double.parse(item['price'].toString()) * (item['quantity'] ?? 1))); 
  // Tính tổng giá trị bằng cách nhân giá của từng sản phẩm với số lượng của nó và cộng vào tổng
}

// Phương thức xóa tất cả các sản phẩm trong giỏ hàng
void clear() {
  _items.clear(); // Xóa tất cả các sản phẩm trong giỏ hàng
  notifyListeners(); // Thông báo cho các widget lắng nghe sự thay đổi
}

}
