import 'package:flutter/foundation.dart';

class WishlistProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _items = [];
  List<Map<String, dynamic>> get items => _items;

  void toggleFavorite(Map<String, dynamic> product) {
  // Tìm chỉ số của sản phẩm trong danh sách `_items` dựa vào `id` của sản phẩm
  final index = _items.indexWhere((item) => item['id'] == product['id']);
  
  if (index >= 0) {
    // Nếu sản phẩm đã có trong danh sách, xóa sản phẩm khỏi danh sách (bỏ yêu thích)
    _items.removeAt(index);
  } else {
    // Nếu sản phẩm chưa có trong danh sách, thêm sản phẩm vào danh sách (thêm yêu thích)
    _items.add(product);
  }
  // Thông báo cho các widget lắng nghe thay đổi để cập nhật giao diện
  notifyListeners();
}

bool isFavorite(Map<String, dynamic> product) {
  // Kiểm tra xem sản phẩm có trong danh sách yêu thích hay không
  return _items.any((item) => item['id'] == product['id']);
}

}
