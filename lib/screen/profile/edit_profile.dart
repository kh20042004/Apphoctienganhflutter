import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../home/profile_screen.dart';
import '../product/language_setting.dart';
import '../product/user_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Khóa của form để xác thực và lưu trữ trạng thái của form
  final _formKey = GlobalKey<FormState>();

  // Biến lưu trữ ảnh người dùng chọn
  File? _image;

  // Các controller để quản lý các trường nhập liệu
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  // Biến kiểm tra xem người dùng có đang chọn ảnh hay không
  bool _isPickingImage = false;

  // Hàm chọn ảnh từ thư viện
  Future<void> _pickImage() async {
    // Nếu đang trong quá trình chọn ảnh, không thực hiện thao tác mới
    if (_isPickingImage) return;
    
    try {
      // Đánh dấu là đang chọn ảnh
      setState(() => _isPickingImage = true);
      
      // Khởi tạo ImagePicker để chọn ảnh từ thư viện
      final imagePicker = ImagePicker();
      // Chọn ảnh từ thư viện (Gallery)
      final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
      
      // Nếu người dùng chọn ảnh thành công, lưu ảnh vào biến _image
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path); // Chuyển đường dẫn ảnh thành đối tượng File
        });
      }
    } catch (e) {
      // Nếu có lỗi trong quá trình chọn ảnh, hiển thị thông báo lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    } finally {
      // Đánh dấu hoàn thành việc chọn ảnh
      setState(() => _isPickingImage = false);
    }
  }

  // Hàm lưu thay đổi khi người dùng nhấn nút lưu
  void _saveChanges() async {
    // Kiểm tra tính hợp lệ của form
    if (_formKey.currentState!.validate()) {
      // Hiển thị vòng tròn loading trong khi xử lý lưu thay đổi
      showDialog(
        context: context,
        barrierDismissible: false, // Không thể đóng khi bấm ra ngoài vòng tròn loading
        builder: (BuildContext context) => const Center(
          child: CircularProgressIndicator(), // Vòng tròn loading
        ),
      );
// Cập nhật hồ sơ người dùng với dữ liệu từ các trường nhập liệu và ảnh
      context.read<UserProvider>().updateProfile(
     name: _nameController.text,  // Lấy tên người dùng từ TextEditingController
     email: _emailController.text,  // Lấy email người dùng từ TextEditingController
    phone: _phoneController.text,  // Lấy số điện thoại người dùng từ TextEditingController
    imagePath: _image?.path,  // Lấy đường dẫn của ảnh nếu có
    );

// Mô phỏng thời gian chờ (ví dụ: thời gian xử lý cập nhật hồ sơ)
await Future.delayed(const Duration(seconds: 2));

// Đóng dialog loading sau khi quá trình cập nhật hoàn tất
Navigator.pop(context); 

// Hiển thị thông báo thành công
ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  content: Text(context.read<LanguageProvider>().translate('profile_updated')),  // Dịch thông báo thành công
));

// Chuyển hướng người dùng đến màn hình Profile sau khi cập nhật thành công
Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => const ProfileScreen()),  // Chuyển đến màn hình Profile
      );
    }
  }

  @override
  Widget build(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark; // Kiểm tra chế độ tối hoặc sáng của theme hiện tại
  final languageProvider = context.watch<LanguageProvider>(); // Lấy đối tượng LanguageProvider để dịch các chuỗi ngôn ngữ

  return Scaffold(
    // AppBar: Chứa tiêu đề và nút quay lại
    appBar: AppBar(
      backgroundColor: isDark ? Colors.black : Colors.white, // Thay đổi màu nền appBar tùy theo theme
      elevation: 0, // Không có bóng cho appBar
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios, 
          color: isDark ? Colors.white : Colors.black, // Màu sắc của icon "quay lại" tùy vào theme
        ),
        onPressed: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()), // Điều hướng về màn hình ProfileScreen
        ),
      ),
      title: Text(
        languageProvider.translate('edit_profile'), // Tiêu đề appBar được dịch thông qua LanguageProvider
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black,
          fontWeight: FontWeight.w600, // Đặt font-weight cho tiêu đề appBar
        ),
      ),
    ),
    // Nội dung màn hình chỉnh sửa hồ sơ
    body: Container(
      color: isDark ? Colors.black : Colors.grey[50], // Màu nền của body tùy vào theme
      child: SingleChildScrollView( // Dùng SingleChildScrollView để màn hình có thể cuộn được nếu cần thiết
        padding: const EdgeInsets.all(16), // Padding xung quanh form
        child: Form(
          key: _formKey, // GlobalKey cho form để kiểm tra validate
          child: Column(
            children: [
              Stack(
                children: [
                  // Ảnh đại diện người dùng
                  CircleAvatar(
                    radius: 60, // Kích thước ảnh đại diện
                    backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200], // Màu nền của ảnh đại diện
                    backgroundImage: _image != null ? FileImage(_image!) : null, // Nếu có ảnh thì hiển thị, nếu không hiển thị icon mặc định
                    child: _image == null
                        ? Icon(
                            Icons.person, // Icon mặc định nếu chưa có ảnh
                            size: 60,
                            color: isDark ? Colors.grey[600] : Colors.grey[400], // Màu sắc của icon tùy theo theme
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0, // Đặt vị trí của button chụp ảnh tại góc dưới bên phải ảnh đại diện
                    right: 0,
                    child: CircleAvatar(
                      backgroundColor: isDark ? Colors.white : Colors.black, // Màu nền cho nút chụp ảnh
                      radius: 18, // Kích thước của nút chụp ảnh
                      child: IconButton(
                        icon: Icon(
                          Icons.camera_alt, // Icon camera
                          size: 18, // Kích thước icon
                          color: isDark ? Colors.black : Colors.white, // Màu sắc của icon tùy vào theme
                        ),
                        onPressed: _pickImage, // Khi người dùng bấm vào sẽ gọi hàm _pickImage để chọn ảnh
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                TextFormField(
                   controller: _nameController, // Kết nối controller để quản lý nội dung nhập vào trường này
                    style: TextStyle(
                   color: isDark ? Colors.white : Colors.black, // Màu chữ thay đổi theo theme (tối hoặc sáng)
                  ),
                    decoration: InputDecoration(
                   labelText: languageProvider.translate('full_name'), // Nhãn cho trường nhập (dùng dịch ngôn ngữ từ LanguageProvider)
                   hintText: languageProvider.translate('enter_full_name'), // Gợi ý khi trường nhập trống (dùng dịch ngôn ngữ từ LanguageProvider)
                   border: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(8), // Đặt bo tròn cho viền của trường nhập
                  ),
                 prefixIcon: Icon(
                 Icons.person_outline, // Icon ở đầu trường nhập (biểu tượng hình người)
                 color: isDark ? Colors.white70 : Colors.grey[700], // Màu của icon thay đổi theo theme (tối hoặc sáng)
                  ),
                 labelStyle: TextStyle(
                color: isDark ? Colors.white70 : Colors.grey[700], // Màu của label thay đổi theo theme (tối hoặc sáng)
                ),
              ),
              validator: (value) => value?.isEmpty ?? true // Kiểm tra xem người dùng có nhập dữ liệu vào trường này không
             ? languageProvider.translate('name_required') // Nếu trống, hiển thị thông báo yêu cầu nhập tên
                  : null, // Nếu có nhập, không làm gì
                ),
                const SizedBox(height: 16),

                TextFormField(
  controller: _emailController, // Kết nối controller để quản lý nội dung nhập vào trường email
  style: TextStyle(
    color: isDark ? Colors.white : Colors.black, // Màu chữ thay đổi theo theme (tối hoặc sáng)
  ),
  decoration: InputDecoration(
    labelText: languageProvider.translate('email'), // Nhãn cho trường nhập email (dùng dịch ngôn ngữ từ LanguageProvider)
    hintText: languageProvider.translate('enter_email'), // Gợi ý khi trường nhập trống (dùng dịch ngôn ngữ từ LanguageProvider)
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8), // Đặt bo tròn cho viền của trường nhập
    ),
    prefixIcon: Icon(
      Icons.email_outlined, // Icon ở đầu trường nhập (biểu tượng email)
      color: isDark ? Colors.white70 : Colors.grey[700], // Màu của icon thay đổi theo theme (tối hoặc sáng)
    ),
    labelStyle: TextStyle(
      color: isDark ? Colors.white70 : Colors.grey[700], // Màu của label thay đổi theo theme (tối hoặc sáng)
    ),
  ),
  validator: (value) {
    // Kiểm tra tính hợp lệ của email
    if (value?.isEmpty ?? true) {
      return languageProvider.translate('email_required'); // Nếu trống, hiển thị thông báo yêu cầu nhập email
    }
    if (!value!.contains('@')) {
      return languageProvider.translate('invalid_email'); // Kiểm tra xem email có chứa dấu '@' không
    }
    return null; // Nếu hợp lệ, không làm gì
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
  controller: _phoneController, // Controller giúp quản lý giá trị nhập vào
  style: TextStyle(
    color: isDark ? Colors.white : Colors.black, // Màu chữ thay đổi theo theme (tối hoặc sáng)
  ),
  decoration: InputDecoration(
    labelText: languageProvider.translate('phone_number'), // Nhãn của trường nhập (dùng dịch ngôn ngữ từ LanguageProvider)
    hintText: languageProvider.translate('enter_phone'), // Gợi ý cho trường nhập trống (dùng dịch ngôn ngữ từ LanguageProvider)
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8), // Bo tròn viền trường nhập
    ),
    prefixIcon: Icon(
      Icons.phone_outlined, // Biểu tượng điện thoại trước trường nhập
      color: isDark ? Colors.white70 : Colors.grey[700], // Màu của icon thay đổi theo theme
    ),
    labelStyle: TextStyle(
      color: isDark ? Colors.white70 : Colors.grey[700], // Màu của label thay đổi theo theme
    ),
  ),
  validator: (value) => value?.isEmpty ?? true 
      ? languageProvider.translate('phone_required') // Kiểm tra nếu trống sẽ hiển thị thông báo yêu cầu nhập số điện thoại
      : null, // Nếu không trống thì không có lỗi
                ),
                const SizedBox(height: 32),

                SizedBox(
  width: double.infinity, // Button chiếm toàn bộ chiều rộng của bố cục
  child: ElevatedButton(
    onPressed: _saveChanges, // Gọi hàm _saveChanges khi người dùng bấm vào button
    style: ElevatedButton.styleFrom(
      backgroundColor: isDark ? Colors.white : Colors.black, // Màu nền button thay đổi theo theme
      padding: const EdgeInsets.symmetric(vertical: 16), // Padding cho button
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Bo tròn các góc của button
      ),
    ),
    child: Text(
      languageProvider.translate('save_changes'), // Nút hiển thị "Lưu thay đổi", dịch theo ngôn ngữ
      style: TextStyle(
        fontSize: 16, // Kích thước font chữ
        color: isDark ? Colors.black : Colors.white, // Màu chữ thay đổi theo theme
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}