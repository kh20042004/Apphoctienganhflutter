// Import các thư viện cần thiết
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../home/home_screen.dart';
import '../product/product_list_screen.dart';
import '../product/cart_provider.dart';
import '../product/language_setting.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Danh sách các sản phẩm và giỏ hàng
  final List<Map<String, dynamic>> products = ProductList.products;
  final List<Map<String, dynamic>> cartItems = [];

  // Khởi tạo giỏ hàng khi màn hình được tạo
  @override
  void initState() {
    super.initState();
    cartItems.addAll(
      ProductList.products
          .map((product) => {
                ...product,
                'quantity': 0, // Khởi tạo số lượng của sản phẩm trong giỏ là 0
              })
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Kiểm tra chế độ sáng/tối
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Lấy đối tượng languageProvider để hỗ trợ đa ngôn ngữ
    final languageProvider = context.watch<LanguageProvider>();

    // Sử dụng Consumer để lắng nghe sự thay đổi từ CartProvider
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        final items = cartProvider.items; // Lấy danh sách các mặt hàng trong giỏ

        return Scaffold(
          // Màu nền của màn hình dựa trên chế độ sáng/tối
          backgroundColor: isDark ? Colors.black : Colors.white,
          appBar: AppBar(
            // Thiết lập AppBar với màu sắc và tiêu đề tương ứng
            backgroundColor: isDark ? Colors.black : Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: isDark ? Colors.white : Colors.black,
              ),
              // Quay lại màn hình chính khi nhấn nút
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              ),
            ),
            title: Text(
              languageProvider.translate('cart'), // Tiêu đề "Giỏ hàng" (được dịch)
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Nếu giỏ hàng trống, hiển thị thông báo giỏ hàng trống
          body: items.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 64,
                        color: isDark ? Colors.white54 : Colors.black54,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        languageProvider.translate('cart_empty'), // Thông báo giỏ hàng trống
                        style: TextStyle(
                          color: isDark ? Colors.white54 : Colors.black54,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length, // Số lượng mục trong giỏ
                  itemBuilder: (context, index) {
                    final item = items[index]; // Lấy mặt hàng tại vị trí index
                    return Card(
                      color: isDark ? Colors.grey[900] : Colors.white,
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          children: [
                            // Hiển thị hình ảnh sản phẩm
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: AssetImage(item['image']),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),

                            // Chi tiết sản phẩm (Tên, giá)
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    languageProvider.currentLanguage == 'en'
                                        ? item['name'] // Nếu ngôn ngữ là 'en', hiển thị tên tiếng Anh
                                        : item['name_vi'] ?? item['name'], // Hiển thị tên tiếng Việt nếu có
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? Colors.white : Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '\$${item['price']}',
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Điều khiển số lượng (Thêm/Sửa)
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () {
                                    // Giảm số lượng sản phẩm
                                    if (item['quantity'] > 1) {
                                      cartProvider.updateQuantity(
                                        item,
                                        item['quantity'] - 1,
                                      );
                                    } else {
                                      cartProvider.updateQuantity(item, 0);
                                    }
                                  },
                                ),
                                Text(
                                  '${item['quantity']}',
                                  style: TextStyle(
                                    color: isDark ? Colors.white : Colors.black,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    // Tăng số lượng sản phẩm
                                    cartProvider.updateQuantity(
                                      item,
                                      item['quantity'] + 1,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
          // Hiển thị tổng tiền giỏ hàng và nút thanh toán nếu giỏ hàng không trống
          bottomNavigationBar: items.isEmpty
              ? null
              : Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.black : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            languageProvider.translate('total'), // Tổng tiền
                            style: TextStyle(
                              color: isDark ? Colors.white60 : Colors.black54,
                            ),
                          ),
                          Text(
                            '\$${cartProvider.getTotal().toStringAsFixed(2)}', // Hiển thị tổng tiền của giỏ hàng
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // TODO: Implement checkout (Chức năng thanh toán chưa được triển khai)
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                        ),
                        child: Text(languageProvider.translate('checkout')), // Nút thanh toán
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
