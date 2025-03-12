import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../home/profile_screen.dart';
import '../home/cart_screen.dart';
import '../home/shop_screen.dart';
import '../home/sreach_screen.dart';
import '../product/product_list_screen.dart';
import '../product/language_setting.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _selectedIndex = 2; // Chỉ số của mục đang được chọn trong thanh điều hướng
  int _selectedInrun = 0; // Mục chọn khi nhấn vào một biểu tượng
  bool _hasInteracted = false; // Kiểm tra xem người dùng đã tương tác hay chưa
  late AnimationController _controller; // Bộ điều khiển hoạt ảnh
  late bool isDark; // Kiểm tra chế độ tối (dark mode)
  late LanguageProvider languageProvider; // Để quản lý ngôn ngữ

  // Các biểu tượng trong thanh điều hướng
  final List<IconData> items = [
    Icons.home_outlined,
    Icons.shop,
    Icons.shopping_bag_outlined,
    Icons.search,
    Icons.person_outline,
  ];

  // Danh sách các màn hình tương ứng với các mục điều hướng
  final List<Widget> _screens = [
    const HomeScreen(),
    const ShopScreen(),
    const CartScreen(),
    const SearchScreen(),
    const ProfileScreen(),
  ];

  // Danh sách sản phẩm
  final List<Map<String, dynamic>> products = ProductList.products;

  // Khởi tạo các giá trị khi màn hình được tạo
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300), // Thời gian của hoạt ảnh
      vsync: this,
    );
  }

  // Đảm bảo giải phóng tài nguyên khi màn hình bị hủy
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Kiểm tra chế độ sáng/tối của ứng dụng
    isDark = Theme.of(context).brightness == Brightness.dark;
    languageProvider = context.watch<LanguageProvider>(); // Lấy đối tượng quản lý ngôn ngữ

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white, // Màu nền của ứng dụng
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.white,
        elevation: 0, // Không có độ cao cho app bar
        scrolledUnderElevation: 0, // Không có độ cao khi cuộn xuống
        surfaceTintColor: Colors.transparent, // Không có màu nền cho app bar
        shadowColor: Colors.transparent, // Không có bóng cho app bar
        title: Text(
          languageProvider.translate('home'), // Tiêu đề "Trang chủ"
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () {}, // Hàm xử lý khi nhấn vào nút menu (chưa triển khai)
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.shopping_bag_outlined,
              color: isDark ? Colors.white : Colors.black,
            ),
            onPressed: () {
              // Chuyển hướng đến màn hình giỏ hàng khi nhấn nút
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const CartScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Thanh tìm kiếm
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: isDark ? Colors.black : Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: GestureDetector(
                onTap: () {
                  // Chuyển hướng đến màn hình tìm kiếm khi nhấn vào thanh tìm kiếm
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SearchScreen()),
                  );
                },
                child: TextField(
                  enabled: false, // Không cho phép chỉnh sửa
                  decoration: InputDecoration(
                    hintText: languageProvider.translate('search_hint'), // Gợi ý tìm kiếm
                    prefixIcon: Icon(Icons.search,
                        color: isDark ? Colors.grey[400] : Colors.grey[600]),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    hintStyle: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.grey[600]),
                  ),
                ),
              ),
            ),
          ),

          // Nội dung chính
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 180,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal, // Cuộn ngang
                      itemCount: 4, // Số lượng phần tử hiển thị
                      itemBuilder: (context, index) {
                        return Container(
                          width: MediaQuery.of(context).size.width - 32,
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.grey[900] : Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: isDark
                                    ? Colors.black.withOpacity(0.3)
                                    : Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: isDark
                                          ? Colors.white24
                                          : Colors.black12,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        languageProvider
                                            .translate('product_title'), // Tiêu đề sản phẩm
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: isDark
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        languageProvider
                                            .translate('product_description'), // Mô tả sản phẩm
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: isDark
                                              ? Colors.grey[400]
                                              : Colors.grey[600],
                                        ),
                                        maxLines: 2,
                                      ),
                                      const SizedBox(height: 10),
                                      ElevatedButton(
                                        onPressed: () {
                                          // Chuyển hướng đến màn hình cửa hàng
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const ShopScreen(),
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: isDark
                                              ? Colors.white
                                              : Colors.black,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          minimumSize: const Size(100, 30),
                                        ),
                                        child: Text(
                                          languageProvider
                                              .translate('shop_now'), // "Mua ngay" button
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: isDark
                                                ? Colors.black
                                                : Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.horizontal(
                                      right: Radius.circular(12),
                                    ),
                                    image: DecorationImage(
                                      image: AssetImage(
                                          products[index]['booking']),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  // Mới nhất
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          languageProvider.translate('new_arrivals'), // "Mới nhất"
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Chuyển hướng đến màn hình cửa hàng
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ShopScreen(),
                              ),
                            );
                          },
                          child: Text(
                            languageProvider.translate('view_all'), // "Xem tất cả"
                            style: TextStyle(
                              color: isDark ? Colors.white70 : Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Danh sách sản phẩm mới
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      height: 500, // Chiều cao của khung sản phẩm
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal, // Lướt ngang
                        itemCount: products.length, // Số lượng sản phẩm
                        itemBuilder: (context, index) {
                          final product = products[index]; // Dữ liệu sản phẩm
                          return GestureDetector(
                            onTap: () {
                              print('Selected product: ${product['name']}');
                            },
                            child: Container(
  width: MediaQuery.of(context).size.width - 85, // Chiều rộng của container được tính theo chiều rộng màn hình trừ đi 85
  margin: const EdgeInsets.symmetric(horizontal: 8), // Căn lề trái và phải 8 đơn vị
  decoration: BoxDecoration(
    color: isDark ? Colors.grey[900] : Colors.white, // Màu nền thay đổi theo chế độ sáng/tối
    borderRadius: BorderRadius.circular(12), // Bo tròn góc của container
    border: Border.all(
      color: isDark ? Colors.white24 : Colors.black12, // Màu viền thay đổi theo chế độ sáng/tối
      width: 1, // Độ dày của viền
    ),
    boxShadow: [
      BoxShadow(
        color: isDark
            ? Colors.black.withOpacity(0.3) // Bóng đổ khi chế độ tối
            : Colors.grey.withOpacity(0.3), // Bóng đổ khi chế độ sáng
        spreadRadius: 1, // Độ lan rộng của bóng
        blurRadius: 3, // Độ mờ của bóng
        offset: const Offset(0, 2), // Vị trí bóng
      ),
    ],
  ),
  child: Stack( // Stack cho phép các phần tử chồng lên nhau
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch, // Căn lề cho các phần tử trong cột
        children: [
          Expanded(
            flex: 5, // Chiếm 5 phần trong tổng số 6 phần của Column
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)), // Bo tròn góc trên của ảnh
              child: Image.asset(
                product['image'], // Hiển thị ảnh sản phẩm từ asset
                fit: BoxFit.cover, // Ảnh sẽ phủ đầy khu vực chứa mà không bị méo
              ),
            ),
          ),
          Expanded(
            flex: 1, // Chiếm 1 phần trong tổng số 6 phần của Column
            child: Padding(
              padding: const EdgeInsets.all(8), // Padding xung quanh phần tử này
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Căn lề trái cho các phần tử
                children: [
                  Text(
                    product['name'], // Hiển thị tên sản phẩm
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold, // Chữ in đậm
                    ),
                    maxLines: 1, // Giới hạn số dòng của text là 1
                    overflow: TextOverflow.ellipsis, // Thêm dấu "..." nếu văn bản dài
                  ),
                  const SizedBox(height: 1),
                  Row(
                    children: [
                      Text(
                        '\$${product['price']}', // Hiển thị giá sản phẩm
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.red, // Màu đỏ cho giá
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '\$${product['oldPrice']}', // Hiển thị giá cũ
                        style: TextStyle(
                          fontSize: 12,
                          decoration: TextDecoration.lineThrough, // Gạch ngang giá cũ
                          color: Colors.grey[500], // Màu xám cho giá cũ
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // Nút yêu thích (thêm hoặc xóa sản phẩm khỏi danh sách yêu thích)
      Positioned(
        top: 8,
        right: 8,
        child: GestureDetector(
          onTap: () {
            setState(() {
              // Chuyển trạng thái yêu thích của sản phẩm
              product['isFavorite'] = !(product['isFavorite'] ?? fals

                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
  height: 70, // Chiều cao của bottom navigation bar
  decoration: BoxDecoration(
    color: isDark ? Colors.grey[900] : Colors.white, // Màu nền thay đổi theo chế độ sáng/tối
    borderRadius: const BorderRadius.only(
      topLeft: Radius.circular(30), // Bo tròn góc trái
      topRight: Radius.circular(30), // Bo tròn góc phải
    ),
    boxShadow: [
      BoxShadow(
        color: isDark
            ? Colors.black.withOpacity(0.3) // Bóng đổ khi ở chế độ tối
            : Colors.grey.withOpacity(0.2), // Bóng đổ khi ở chế độ sáng
        blurRadius: 10, // Độ mờ của bóng đổ
        spreadRadius: 2, // Độ lan rộng của bóng đổ
        offset: const Offset(0, -3), // Vị trí bóng đổ
      ),
    ],
  ),
  child: Stack( // Dùng Stack để đặt các phần tử chồng lên nhau
    clipBehavior: Clip.none, // Không cắt các phần tử bên ngoài
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround, // Căn chỉnh các mục trong hàng
        children: List.generate(items.length, (index) { // Lặp qua danh sách biểu tượng
          bool isSelected = _selectedIndex == index; // Kiểm tra mục được chọn

          return GestureDetector( // Phát hiện sự kiện chạm vào mục
            onTap: () {
              setState(() {
                _selectedIndex = index; // Cập nhật mục đã chọn
                _selectedInrun = index; // Cập nhật chỉ số màn hình tương ứng
                _hasInteracted = true; // Đánh dấu rằng người dùng đã tương tác
              });

              if (_selectedInrun < _screens.length && _selectedInrun != 0) {
                // Chuyển đến màn hình tương ứng khi mục được chọn
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    transitionDuration: Duration.zero, // Không có hoạt ảnh chuyển tiếp
                    pageBuilder: (_, __, ___) => _screens[_selectedInrun],
                    transitionsBuilder: (_, __, ___, child) => child, // Không có hiệu ứng chuyển tiếp
                  ),
                );
              }
            },
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                // Hoạt ảnh mở rộng khi người dùng nhấn vào mục
                if (_hasInteracted)
                  TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0, end: isSelected ? 1 : 0),
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOutCubic,
                    builder: (context, double value, child) {
                      return Container(
                        width: 50 + (20 * value), // Điều chỉnh kích thước khi chọn
                        height: 50 + (20 * value), // Điều chỉnh kích thước khi chọn
                        decoration: BoxDecoration(
                          color: isDark ? Colors.grey[900] : Colors.white,
                          shape: BoxShape.circle, // Hình tròn
                          boxShadow: [
                            BoxShadow(
                              color: isDark
                                  ? Colors.black.withOpacity(0.3 * value)
                                  : Colors.white.withOpacity(0.3 * value),
                              blurRadius: 15 * value, // Độ mờ của bóng đổ
                              spreadRadius: 5 * value, // Độ lan rộng của bóng đổ
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                // Hoạt ảnh nâng lên khi mục được chọn
                if (isSelected)
                  TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOutBack,
                    builder: (context, double value, child) {
                      return Transform.translate(
                        offset: Offset(0, -30 * value), // Di chuyển lên khi chọn
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.grey[900]
                                : Colors.white.withOpacity(1.0),
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    },
                  ),
                // Hiệu ứng mở rộng cho biểu tượng
                TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: isSelected ? 1 : 0),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOutBack,
                  builder: (context, double value, child) {
                    return Transform.translate(
                      offset: Offset(0, -34 * value), // Di chuyển lên khi chọn
                      child: Container(
                        width: 40 + (15 * value),
                        height: 60,
                        decoration: BoxDecoration(
                          color: isDark
                              ? Color.lerp(Colors.grey[900], Colors.white, value)
                              : Color.lerp(Colors.white, Colors.black, value),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark
                                ? Color.lerp(Colors.grey[900], Colors.white, value)!
                                : Color.lerp(Colors.white, Colors.black, value)!,
                            width: 2 + value,
                          ),
                        ),
                        child: Icon(
                          items[index], // Biểu tượng của mục
                          color: isDark
                              ? Color.lerp(Colors.grey[400], Colors.black, value)
                              : Color.lerp(Colors.grey, Colors.white, value),
                          size: 24 + (6 * value), // Kích thước biểu tượng
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        }),
      ),
    ],
  ),
),
