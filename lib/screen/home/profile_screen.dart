import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../home/home_screen.dart';
import '../profile/edit_profile.dart';
import '../profile/my_order.dart';
import '../profile/adress.dart';
import '../profile/wish_list.dart';
import '../profile/setting.dart';
import '../product/language_setting.dart';
import '../widgets/theme_dark.dart';
import '../product/user_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 4; // Chỉ số của mục đang chọn trong danh sách các lựa chọn profile

  // Hàm xây dựng một mục trong profile (ví dụ: "Edit Profile", "My Orders", ...)
  Widget _buildProfileOption({
    required IconData icon, // Biểu tượng của mục
    required String title, // Tiêu đề của mục
    required VoidCallback onTap, // Hàm gọi khi người dùng nhấn vào mục
    bool showDivider = true, // Cờ cho biết có hiển thị phân cách sau mỗi mục hay không
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark; // Kiểm tra chế độ sáng/tối

    return Column(
      children: [
        ListTile(
          leading: Icon(
            icon,
            color: isDark ? Colors.white70 : Colors.black87, // Màu biểu tượng thay đổi theo chế độ sáng/tối
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: isDark ? Colors.white : Colors.black87, // Màu văn bản thay đổi theo chế độ sáng/tối
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios, // Biểu tượng mũi tên chỉ hướng bên phải
            size: 16,
            color: isDark ? Colors.white54 : Colors.black54, // Màu mũi tên thay đổi theo chế độ sáng/tối
          ),
          onTap: onTap, // Hàm gọi khi nhấn vào mục
        ),
        if (showDivider)
          Divider(
            color: isDark ? Colors.white12 : Colors.black12, // Màu của divider thay đổi theo chế độ sáng/tối
            height: 1,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark; // Kiểm tra chế độ sáng/tối
    final languageProvider = context.watch<LanguageProvider>(); // Đối tượng cung cấp ngôn ngữ
    final user = context.watch<UserProvider>(); // Đối tượng cung cấp thông tin người dùng

    return Scaffold(
      appBar: AppBar(
        title: Text(
          languageProvider.translate('profile'), // Tiêu đề "Profile"
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black, // Màu văn bản của app bar
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: isDark ? Colors.black : Colors.white, // Màu nền của app bar
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: isDark ? Colors.white : Colors.black, // Màu nút quay lại
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeScreen(), // Quay lại màn hình chính
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hiển thị thông tin người dùng (ảnh đại diện và tên)
            Container(
              padding: const EdgeInsets.all(20),
              color: isDark ? Colors.grey[900] : Colors.white, // Màu nền cho phần thông tin người dùng
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40, // Kích thước vòng tròn ảnh đại diện
                    backgroundColor:
                        isDark ? Colors.grey[800] : Colors.grey[200],
                    backgroundImage:
                        context.watch<UserProvider>().imagePath != null
                            ? FileImage(
                                File(context.watch<UserProvider>().imagePath!))
                            : null,
                    child: context.watch<UserProvider>().imagePath == null
                        ? Icon(
                            Icons.person_outline, // Biểu tượng người dùng nếu không có ảnh
                            size: 40,
                            color: isDark ? Colors.white70 : Colors.black54,
                          )
                        : null,
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Căn lề trái cho văn bản
                    children: [
                      Text(
                        user.name, // Tên người dùng
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.email, // Email người dùng
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.white70 : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Các lựa chọn trong profile (chỉnh sửa, đơn hàng, yêu thích, ...)
            Container(
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[900] : Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  _buildProfileOption(
                    icon: Icons.person_outline,
                    title: languageProvider.translate('edit_profile'), // "Chỉnh sửa profile"
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EditProfileScreen()),
                    ),
                  ),
                  _buildProfileOption(
                    icon: Icons.shopping_bag_outlined,
                    title: languageProvider.translate('my_orders'), // "Đơn hàng của tôi"
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MyOrderScreen()),
                    ),
                  ),
                  _buildProfileOption(
                    icon: Icons.favorite_outline,
                    title: languageProvider.translate('my_wishlist'), // "Danh sách yêu thích"
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const WishlistScreen()),
                    ),
                  ),
                  _buildProfileOption(
                    icon: Icons.location_on_outlined,
                    title: languageProvider.translate('my_addresses'), // "Địa chỉ của tôi"
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddressScreen()),
                    ),
                  ),
                  _buildProfileOption(
                    icon: Icons.settings_outlined,
                    title: languageProvider.translate('settings'), // "Cài đặt"
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SettingScreen()),
                    ),
                  ),
                  _buildProfileOption(
                    icon: Icons.exit_to_app,
                    title: languageProvider.translate('logout'), // "Đăng xuất"
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
