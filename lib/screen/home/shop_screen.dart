import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../home/home_screen.dart';
import '../home/sreach_screen.dart';
import '../product/product_list_screen.dart';
import '../product/language_setting.dart';
import '../product/cart_provider.dart';
import '../home/cart_screen.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({Key? key}) : super(key: key);

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> with TickerProviderStateMixin {
  late AnimationController _controller; // Controller cho hiệu ứng hoạt ảnh
  late List<Map<String, dynamic>> products; // Danh sách sản phẩm
  bool isLoading = true; // Biến kiểm tra trạng thái tải dữ liệu

  // Các danh mục sản phẩm
  final List<String> categories = [
    'All', // Tất cả sản phẩm
    'T-Shirts', // Áo thun
    'Shirts', // Áo sơ mi
    'Pants', // Quần
    'Shoes' // Giày
  ];
  String selectedCategory = 'All'; // Danh mục hiện tại được chọn (mặc định là 'All')

  @override
  void initState() {
    super.initState();
    _initializeData(); // Gọi phương thức khởi tạo dữ liệu
  }

  // Phương thức khởi tạo dữ liệu sản phẩm
  Future<void> _initializeData() async {
    // Tải sản phẩm từ ProductList
    products = List<Map<String, dynamic>>.from(ProductList.products);
    print('Loaded ${products.length} products'); // In số lượng sản phẩm đã tải

    // Khởi tạo controller cho animation
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300), // Thời gian của hiệu ứng
      vsync: this, // Cung cấp "vsync" cho animation
    );

    // Sau khi khởi tạo xong, tiến hành chạy hiệu ứng
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        isLoading = false; // Cập nhật lại trạng thái khi dữ liệu đã tải xong
      });
      _controller.forward(); // Bắt đầu hiệu ứng animation
    });
  }

  // Phương thức trợ giúp lấy biểu tượng theo danh mục
  IconData getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'all': // Nếu danh mục là "All"
        return Icons.dashboard_outlined; // Biểu tượng cho tất cả sản phẩm
      case 't-shirts': // Nếu danh mục là "T-Shirts"
        return Icons.checkroom_outlined; // Biểu tượng cho áo thun
      case 'shirts': // Nếu danh mục là "Shirts"
        return Icons.dry_cleaning_outlined; // Biểu tượng cho áo sơ mi
      case 'pants': // Nếu danh mục là "Pants"
        return Icons.recent_actors_outlined; // Biểu tượng cho quần
      case 'shoes': // Nếu danh mục là "Shoes"
        return Icons.shopping_bag_outlined; // Biểu tượng cho giày
      default: // Nếu không khớp với bất kỳ danh mục nào
        return Icons.category_outlined; // Biểu tượng mặc định cho danh mục
    }
  }
}


  // Phương thức lọc sản phẩm theo danh mục đã chọn
List<Map<String, dynamic>> getFilteredProducts() {
  if (products.isEmpty) {
    print('No products loaded'); // In thông báo nếu không có sản phẩm
    return []; // Trả về danh sách rỗng nếu không có sản phẩm
  }

  // Nếu danh mục được chọn là 'All', hiển thị tất cả sản phẩm
  // Nếu không, lọc các sản phẩm theo danh mục đã chọn
  final filtered = selectedCategory == 'All'
      ? products // Hiển thị tất cả sản phẩm
      : products
          .where((product) => product['category'] == selectedCategory) // Lọc theo danh mục
          .toList();

  print('Filtered ${filtered.length} products for $selectedCategory'); // In số sản phẩm sau khi lọc
  return filtered; // Trả về danh sách sản phẩm đã lọc
}

// Phương thức hiển thị sao đánh giá của sản phẩm
Widget buildRatingStars(int rating) {
  return Row(
    children: List.generate(
      5, // Tạo ra 5 sao
      (index) => Icon(
        index < rating ? Icons.star : Icons.star_border, // Nếu chỉ số sao nhỏ hơn rating, hiển thị sao đầy, nếu không hiển thị sao trống
        color: Colors.amber, // Màu vàng cho sao
        size: 14, // Kích thước sao
      ),
    ),
  );
}

// Phương thức hiển thị nút thêm vào giỏ hàng
Widget buildCartButton(bool isDark, Map<String, dynamic> product) {
  return Consumer<CartProvider>( // Lắng nghe sự thay đổi trong giỏ hàng
    builder: (context, cart, child) => InkWell( // InkWell dùng để nhận sự kiện nhấn
      onTap: () {
        cart.addItem(product); // Thêm sản phẩm vào giỏ hàng
        // Hiển thị thông báo khi thêm sản phẩm vào giỏ
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.shopping_cart, color: Colors.white), // Biểu tượng giỏ hàng
                const SizedBox(width: 12),
                Text('Đã thêm ${product['name']} vào giỏ hàng'), // Thông báo tên sản phẩm đã thêm vào giỏ
              ],
            ),
            backgroundColor: Colors.green, // Màu nền thông báo
            duration: const Duration(seconds: 1), // Thời gian hiển thị thông báo
            behavior: SnackBarBehavior.floating, // Hành vi của thông báo
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDark ? Colors.white : Colors.black, // Màu nền nút
          borderRadius: BorderRadius.circular(8), // Bo tròn góc nút
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.2)
                  : Colors.grey.withOpacity(0.2), // Màu bóng đổ cho nút
              blurRadius: 4, // Độ mờ của bóng
              offset: const Offset(0, 2), // Vị trí bóng
            ),
          ],
        ),
        child: Icon(
          Icons.add_shopping_cart, // Biểu tượng giỏ hàng
          size: 20, // Kích thước biểu tượng
          color: isDark ? Colors.black : Colors.white, // Màu biểu tượng
        ),
      ),
    ),
  );
}

// Phương thức hiển thị nhãn (badge) cho sản phẩm
Widget buildBadge(String text, Color color) {
  return Positioned(
    top: 8,
    left: 8,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color, // Màu nền của nhãn
        borderRadius: BorderRadius.circular(12), // Bo tròn góc nhãn
      ),
      child: Text(
        text.toUpperCase(), // Hiển thị chữ in hoa
        style: const TextStyle(
          color: Colors.white, // Màu chữ
          fontSize: 10, // Kích thước chữ
          fontWeight: FontWeight.bold, // Định dạng chữ đậm
        ),
      ),
    ),
  );
}

// Phương thức hiển thị nút yêu thích (thêm hoặc xóa khỏi danh sách yêu thích)
Widget buildFavoriteButton(Map<String, dynamic> product, bool isDark) {
  return Positioned(
    top: 8,
    right: 8,
    child: GestureDetector( // Lắng nghe sự kiện nhấn vào nút yêu thích
      onTap: () {
        setState(() {
          product['isFavorite'] = !(product['isFavorite'] ?? false); // Lật trạng thái yêu thích
        });

        // Hiển thị thông báo khi thay đổi trạng thái yêu thích
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  product['isFavorite'] ? Icons.favorite : Icons.favorite_border, // Biểu tượng yêu thích
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  product['isFavorite']
                      ? 'Đã thêm vào danh sách yêu thích' // Thông báo đã thêm
                      : 'Đã xóa khỏi danh sách yêu thích', // Thông báo đã xóa
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
            backgroundColor: product['isFavorite'] ? Colors.green : Colors.red, // Màu nền của thông báo
            duration: const Duration(seconds: 1), // Thời gian hiển thị thông báo
            behavior: SnackBarBehavior.floating, // Hành vi của thông báo
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Bo tròn góc của thông báo
            ),
          ),
        );
      },
      child: Icon(
        product['isFavorite'] == true
            ? Icons.favorite
            : Icons.favorite_outline, // Biểu tượng yêu thích
        color: product['isFavorite'] == true
            ? Colors.red
            : isDark
                ? Colors.black
                : Colors.white, // Màu sắc của biểu tượng
        size: 24,
      ),
    ),
  );
}


 // Phương thức hiển thị thông tin sản phẩm dưới dạng card
Widget buildProductCard(Map<String, dynamic> product, bool isDark,
    LanguageProvider languageProvider) {
  return Container(
    decoration: BoxDecoration(
      color: isDark ? Colors.grey[900] : Colors.white, // Màu nền của card, phụ thuộc vào chủ đề
      borderRadius: BorderRadius.circular(12), // Bo tròn các góc của card
      border: Border.all(
        color: isDark ? Colors.white10 : Colors.black12, // Màu viền của card
      ),
      boxShadow: [
        BoxShadow(
          color: isDark
              ? Colors.black.withOpacity(0.3) // Màu bóng đổ khi chủ đề là tối
              : Colors.black.withOpacity(0.1), // Màu bóng đổ khi chủ đề là sáng
          blurRadius: 15, // Độ mờ của bóng đổ
          offset: const Offset(0, 5), // Vị trí của bóng đổ
        ),
      ],
    ),
    child: Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Căn trái nội dung trong card
          children: [
            // Phần hình ảnh sản phẩm
            Expanded(
              flex: 2, // Chiếm 2 phần trong tổng cộng 4 phần
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12), // Bo tròn góc trên của hình ảnh
                      ),
                      image: DecorationImage(
                        image: AssetImage(product['image']), // Hình ảnh sản phẩm
                        fit: BoxFit.cover, // Làm cho hình ảnh vừa với không gian mà không bị méo
                        onError: (exception, stackTrace) {
                          print('Error loading image: ${product['image']}');
                        },
                      ),
                    ),
                  ),
                  // Hiển thị nhãn "Mới" nếu sản phẩm mới
                  if (product['isNew'] ?? false)
                    buildBadge('new', Colors.green),
                  // Hiển thị nhãn giảm giá nếu có
                  if (product['discount'] != null)
                    buildBadge('${product['discount']}% OFF', Colors.red),
                ],
              ),
            ),

            // Phần thông tin sản phẩm (Tên, đánh giá, giá)
            Expanded(
              flex: 2, // Chiếm 2 phần trong tổng cộng 4 phần
              child: Padding(
                padding: const EdgeInsets.all(12), // Khoảng cách giữa các phần tử
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      // Kiểm tra ngôn ngữ hiện tại và hiển thị tên sản phẩm tương ứng
                      languageProvider.currentLanguage == 'en'
                          ? product['name'] ?? 'Product Name'
                          : product['name_vi'] ??
                              product['name'] ??
                              'Tên sản phẩm',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, // Định dạng chữ đậm
                        fontSize: 14, // Kích thước chữ
                        color: isDark ? Colors.white : Colors.black, // Màu chữ tùy vào chủ đề
                      ),
                      maxLines: 2, // Giới hạn số dòng hiển thị
                      overflow: TextOverflow.ellipsis, // Thêm dấu "..." khi tên dài
                    ),
                    buildRatingStars(product['rating'] ?? 0), // Hiển thị sao đánh giá sản phẩm
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Căn đều các phần tử trong hàng
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start, // Căn trái các phần tử
                          children: [
                            Text(
                              '\$${product['price']}', // Hiển thị giá sản phẩm
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.red, // Màu chữ cho giá tiền
                              ),
                            ),
                            // Hiển thị giá cũ nếu có
                            if (product['oldPrice'] != null)
                              Text(
                                '\$${product['oldPrice']}',
                                style: TextStyle(
                                  fontSize: 10, // Kích thước nhỏ cho giá cũ
                                  decoration: TextDecoration.lineThrough, // Gạch ngang giá cũ
                                  color: isDark
                                      ? Colors.grey[400] // Màu cho chủ đề tối
                                      : Colors.grey[500], // Màu cho chủ đề sáng
                                ),
                              ),
                          ],
                        ),
                        buildCartButton(isDark, product), // Nút thêm vào giỏ hàng
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        buildFavoriteButton(product, isDark), // Nút yêu thích nằm trên cùng
      ],
    ),
  );
}
@override
  Widget build(BuildContext context) {
  // Kiểm tra chủ đề hiện tại (tối hoặc sáng)
  final isDark = Theme.of(context).brightness == Brightness.dark;
  
  // Lấy đối tượng LanguageProvider để hỗ trợ dịch ngôn ngữ trong ứng dụng
  final languageProvider = context.watch<LanguageProvider>();

  // Lọc các sản phẩm theo danh mục đã chọn
  final filteredProducts = getFilteredProducts();

  // Hiển thị màn hình loading nếu dữ liệu vẫn đang tải
  if (isLoading) {
    return const Center(child: CircularProgressIndicator());
  }

  return Scaffold(
    backgroundColor: isDark ? Colors.black : Colors.white, // Màu nền của Scaffold tùy thuộc vào chủ đề
    appBar: AppBar(
      backgroundColor: isDark ? Colors.black : Colors.white, // Màu nền của AppBar tùy thuộc vào chủ đề
      elevation: 0, // Bỏ hiệu ứng đổ bóng dưới AppBar
      scrolledUnderElevation: 0, // Không có bóng đổ khi cuộn xuống
      surfaceTintColor: Colors.transparent, // Không có màu sắc nền khi cuộn
      shadowColor: Colors.transparent, // Không có bóng đổ
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios,
            color: isDark ? Colors.white : Colors.black), // Màu sắc của biểu tượng "back" phụ thuộc vào chủ đề
        onPressed: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()), // Quay lại màn hình Home
        ),
      ),
      title: Text(
        languageProvider.translate('shop'), // Dịch từ khóa 'shop' tùy thuộc vào ngôn ngữ hiện tại
        style: TextStyle(
            color: isDark ? Colors.white : Colors.black, // Màu chữ tùy thuộc vào chủ đề
            fontWeight: FontWeight.bold),
      ),
      actions: [
        // Nút tìm kiếm
        IconButton(
          icon: Icon(Icons.search, color: isDark ? Colors.white : Colors.black),
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SearchScreen())),
        ),
        // Nút lọc sản phẩm (hiện tại chưa có chức năng)
        IconButton(
          icon: Icon(Icons.filter_list,
              color: isDark ? Colors.white : Colors.black),
          onPressed: () {},
        ),
      ],
    ),
    body: Column(
      children: [
        // Phần hiển thị các danh mục sản phẩm
        Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView.builder(
            scrollDirection: Axis.horizontal, // Danh sách cuộn ngang
            itemCount: categories.length, // Số lượng danh mục
            itemBuilder: (context, index) {
              // Tạo giao diện cho mỗi danh mục
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300), // Thời gian cho hiệu ứng chuyển đổi
                margin: const EdgeInsets.only(right: 16),
                child: Material(
                  color: Colors.transparent, // Màu nền của item trong ListView
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        selectedCategory = categories[index]; // Cập nhật danh mục khi người dùng chọn
                      });
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                        // Thay đổi màu nền và viền của danh mục khi được chọn
                        color: selectedCategory == categories[index]
                            ? (isDark ? Colors.white : Colors.black)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: selectedCategory == categories[index]
                              ? (isDark ? Colors.white : Colors.black)
                              : (isDark ? Colors.white60 : Colors.grey),
                        ),
                        boxShadow: selectedCategory == categories[index]
                            ? [
                                BoxShadow(
                                  color: isDark
                                      ? Colors.white.withOpacity(0.1)
                                      : Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        children: [
                          // Biểu tượng của danh mục
                          Icon(
                            getCategoryIcon(categories[index]), // Lấy biểu tượng của danh mục
                            color: selectedCategory == categories[index]
                                ? (isDark ? Colors.black : Colors.white)
                                : (isDark ? Colors.white : Colors.black),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          // Tên danh mục
                          Text(
                            languageProvider
                                .translate(categories[index].toLowerCase()), // Dịch tên danh mục
                            style: TextStyle(
                              color: selectedCategory == categories[index]
                                  ? (isDark ? Colors.black : Colors.white)
                                  : (isDark ? Colors.white : Colors.black),
                              fontWeight: selectedCategory == categories[index]
                                  ? FontWeight.bold
                                  : FontWeight.normal, // Đổi trọng số font khi được chọn
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}

          // Products Grid
          Expanded(
  child: filteredProducts.isEmpty
      // Nếu không có sản phẩm nào sau khi lọc, hiển thị thông báo "No products found"
      ? Center(
          child: Text(
            'No products found', // Thông báo không tìm thấy sản phẩm
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black, // Màu chữ tùy thuộc vào chủ đề
            ),
          ),
        )
      // Nếu có sản phẩm, hiển thị GridView
      : GridView.builder(
          padding: const EdgeInsets.all(16), // Khoảng cách xung quanh GridView
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Số cột trong GridView
            childAspectRatio: 0.7, // Tỉ lệ chiều rộng và chiều cao của mỗi item
            mainAxisSpacing: 16, // Khoảng cách giữa các item theo chiều dọc
            crossAxisSpacing: 16, // Khoảng cách giữa các item theo chiều ngang
          ),
          itemCount: filteredProducts.length, // Số lượng sản phẩm sau khi lọc
          itemBuilder: (context, index) {
            final product = filteredProducts[index]; // Lấy sản phẩm ở chỉ số index
            return AnimatedBuilder(
              animation: _controller, // Gắn animation controller vào widget
              builder: (context, child) {
                // Áp dụng hiệu ứng di chuyển (translate) và độ mờ (opacity) cho mỗi sản phẩm
                return Transform.translate(
                  offset: Offset(0, index * 10 * (1 - _controller.value)), // Di chuyển các sản phẩm theo trục Y
                  child: Opacity(
                    opacity: _controller.value, // Độ mờ của sản phẩm tùy thuộc vào giá trị của _controller
                    child: GestureDetector(
                      onTap: () {
                        // TODO: Navigate to product detail
                        // Thực hiện điều hướng đến chi tiết sản phẩm khi nhấn vào sản phẩm
                      },
                      child: buildProductCard(
                        product, isDark, languageProvider, // Hiển thị card sản phẩm
                                ),
                              ),
                            );
                          });
                    },
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
