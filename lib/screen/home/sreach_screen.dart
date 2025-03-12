import 'package:flutter/material.dart';
import 'dart:async';
import '../home/home_screen.dart';
import '../product/product_list_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController(); // Điều khiển cho ô tìm kiếm
  final List<String> recentSearches = ['Áo thun', 'Quần jean', 'Áo thể thao']; // Lịch sử tìm kiếm gần đây
  final List<Map<String, dynamic>> products = ProductList.products; // Danh sách sản phẩm
  List<Map<String, dynamic>> filteredProducts = []; // Danh sách sản phẩm đã lọc
  bool isSearching = false; // Biến kiểm tra trạng thái tìm kiếm (đang tìm kiếm hay không)
  Timer? _debounce; // Biến hẹn giờ để xử lý tìm kiếm theo thời gian thực

  // Phương thức lọc sản phẩm dựa trên truy vấn tìm kiếm
  void filterProducts(String query) {
    // Hủy bỏ timer trước đó nếu có (nếu người dùng tiếp tục gõ)
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    // Tạo timer mới sau khi người dùng gõ xong
    _debounce = Timer(const Duration(milliseconds: 400), () {
      setState(() {
        if (query.isEmpty) {
          filteredProducts = []; // Nếu không có truy vấn, làm rỗng danh sách sản phẩm lọc
          isSearching = false; // Đánh dấu không đang tìm kiếm
        } else {
          isSearching = true; // Đánh dấu đang tìm kiếm
          addToRecentSearches(query); // Thêm truy vấn tìm kiếm vào lịch sử tìm kiếm
          // Lọc sản phẩm dựa trên tên hoặc danh mục sản phẩm có chứa từ khóa tìm kiếm
          filteredProducts = products.where((product) {
            final name = product['name'].toString().toLowerCase(); // Lấy tên sản phẩm và chuyển về chữ thường
            final category = product['category'].toString().toLowerCase(); // Lấy danh mục sản phẩm và chuyển về chữ thường
            final searchQuery = query.toLowerCase(); // Chuyển truy vấn tìm kiếm về chữ thường
            return name.contains(searchQuery) || category.contains(searchQuery); // Kiểm tra nếu tên hoặc danh mục chứa truy vấn tìm kiếm
          }).toList(); // Chuyển kết quả lọc thành một danh sách
        }
      });
    });
  }



  // Thêm một truy vấn tìm kiếm vào lịch sử tìm kiếm nếu nó chưa tồn tại và không rỗng
void addToRecentSearches(String search) {
  if (!recentSearches.contains(search) && search.isNotEmpty) {
    setState(() {
      recentSearches.insert(0, search); // Thêm truy vấn tìm kiếm vào đầu danh sách
      if (recentSearches.length > 5) recentSearches.removeLast(); // Giới hạn lịch sử tìm kiếm chỉ giữ lại 5 mục
    });
  }
}

@override
void dispose() {
  // Hủy bỏ timer debounce khi không cần thiết nữa
  _debounce?.cancel();
  super.dispose();
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.transparent, // Đặt màu nền của AppBar là trong suốt
      elevation: 0, // Không có bóng đổ cho AppBar
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.black), // Biểu tượng "quay lại" ở góc trái
        onPressed: () {
          // Khi người dùng nhấn nút quay lại, điều hướng đến màn hình Home
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
          );
        },
      ),
      title: TextField(
        controller: _searchController, // Điều khiển nội dung ô tìm kiếm
        onChanged: filterProducts, // Gọi phương thức lọc sản phẩm mỗi khi người dùng thay đổi văn bản
        decoration: InputDecoration(
          hintText: 'Search products...', // Văn bản gợi ý cho ô tìm kiếm
          border: InputBorder.none, // Không có đường viền cho ô tìm kiếm
          prefixIcon: const Icon(Icons.search, color: Colors.grey), // Biểu tượng tìm kiếm phía trước
          suffixIcon: isSearching
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey), // Biểu tượng xóa khi đang tìm kiếm
                  onPressed: () {
                    // Xóa nội dung tìm kiếm và làm mới kết quả tìm kiếm
                    _searchController.clear();
                    filterProducts(''); // Lọc lại tất cả sản phẩm
                  },
                )
              : null, // Nếu không tìm kiếm, không có biểu tượng xóa
        ),
      ),
    ),
    // Hiển thị kết quả tìm kiếm hoặc lịch sử tìm kiếm
    body: isSearching ? _buildSearchResults() : _buildRecentSearches(),
  );
}


  // Phương thức xây dựng giao diện lịch sử tìm kiếm
Widget _buildRecentSearches() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start, // Căn trái các phần tử trong cột
    children: [
      // Phần tiêu đề "Tìm kiếm gần đây" và nút "Xóa tất cả" nếu có tìm kiếm gần đây
      Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Căn đều các phần tử trong hàng
          children: [
            const Text(
              'Tìm kiếm gần đây', // Tiêu đề
              style: TextStyle(
                fontSize: 18, // Kích thước chữ
                fontWeight: FontWeight.bold, // Chữ đậm
              ),
            ),
            // Hiển thị nút "Xóa tất cả" khi có lịch sử tìm kiếm
            if (recentSearches.isNotEmpty)
              TextButton(
                onPressed: () {
                  setState(() {
                    recentSearches.clear(); // Xóa tất cả tìm kiếm gần đây
                  });
                },
                child: const Text(
                  'Xóa tất cả', // Nút xóa
                  style: TextStyle(color: Colors.grey), // Màu chữ của nút
                ),
              ),
          ],
        ),
      ),
      // Phần hiển thị danh sách tìm kiếm gần đây
      Expanded(
        child: ListView.builder(
          itemCount: recentSearches.length, // Số lượng mục trong lịch sử tìm kiếm
          itemBuilder: (context, index) {
            // Hiển thị mỗi mục trong danh sách tìm kiếm gần đây
            return ListTile(
              leading: const Icon(Icons.history, color: Colors.grey), // Biểu tượng lịch sử
              title: Text(recentSearches[index]), // Tên tìm kiếm gần đây
              trailing: const Icon(Icons.arrow_forward_ios, size: 16), // Biểu tượng mũi tên
              onTap: () {
                // Khi nhấn vào một mục tìm kiếm gần đây, điền vào ô tìm kiếm và lọc sản phẩm
                _searchController.text = recentSearches[index];
                filterProducts(recentSearches[index]);
              },
            );
          },
        ),
      ),
    ],
  );
}


  // Phương thức để hiển thị kết quả tìm kiếm dưới dạng lưới sản phẩm
Widget _buildSearchResults() {
  return GridView.builder(
    padding: const EdgeInsets.all(16), // Khoảng cách xung quanh lưới
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2, // Số lượng cột trong GridView
      childAspectRatio: 0.7, // Tỉ lệ chiều rộng và chiều cao của mỗi item
      mainAxisSpacing: 16, // Khoảng cách giữa các item theo chiều dọc
      crossAxisSpacing: 16, // Khoảng cách giữa các item theo chiều ngang
    ),
    itemCount: filteredProducts.length, // Số lượng sản phẩm tìm kiếm được
    itemBuilder: (context, index) {
      final product = filteredProducts[index]; // Lấy sản phẩm tại index

      return Container(
        decoration: BoxDecoration(
          color: Colors.white, // Màu nền của từng ô sản phẩm
          borderRadius: BorderRadius.circular(12), // Bo góc cho ô sản phẩm
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05), // Màu bóng
              blurRadius: 10, // Độ mờ của bóng
              offset: const Offset(0, 5), // Vị trí của bóng
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Căn trái các phần tử trong cột
          children: [
            // Ảnh sản phẩm
            Expanded(
              flex: 4, // Tỉ lệ chiều cao của ảnh chiếm 4/6
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12), // Bo góc trên cho ảnh
                  ),
                  image: DecorationImage(
                    image: AssetImage(product['image']), // Tải ảnh từ sản phẩm
                    fit: BoxFit.cover, // Căng ảnh để bao phủ toàn bộ không gian
                  ),
                ),
              ),
            ),
            // Thông tin sản phẩm
            Expanded(
              flex: 2, // Tỉ lệ chiều cao của phần thông tin chiếm 2/6
              child: Padding(
                padding: const EdgeInsets.all(12), // Khoảng cách xung quanh phần thông tin
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Căn trái nội dung trong cột
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Căn đều nội dung dọc
                  children: [
                    // Tên sản phẩm
                    Text(
                      product['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold, // Chữ đậm cho tên sản phẩm
                        fontSize: 13, // Kích thước chữ
                      ),
                      maxLines: 2, // Giới hạn tên sản phẩm chỉ hiển thị tối đa 2 dòng
                      overflow: TextOverflow.ellipsis, // Nếu tên dài, thêm dấu ba chấm ở cuối
                    ),
                    // Giá sản phẩm
                    Text(
                      '\$${product['price']}',
                      style: const TextStyle(
                        fontSize: 8.5, // Kích thước chữ cho giá
                        color: Colors.black87, // Màu sắc của giá sản phẩm
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

}