import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../home/home_screen.dart';
import '../home/profile_screen.dart';
import '../product/language_setting.dart';
import '../widgets/theme_dark.dart';

class Address {
  String id;
  String name;
  String streetAddress;
  String city;
  String state;
  String zipCode;
  String phone;
  String email;
  bool isDefault;

  Address({
    required this.id,
    required this.name,
    required this.streetAddress,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.phone,
    required this.email,
    this.isDefault = false,
  });
}

class AddressScreen extends StatefulWidget {
  const AddressScreen({Key? key}) : super(key: key);

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  nt _selectedIndex = 4; // Biến này có thể dùng để theo dõi phần tử nào được chọn trong giao diện
  bool isEditing = false; // Biến kiểm tra xem đang ở chế độ chỉnh sửa hay không
  final _formKey = GlobalKey<FormState>(); // Khóa toàn cầu để quản lý trạng thái của biểu mẫu
  final languageProvider = LanguageProvider(); // Khởi tạo provider để hỗ trợ dịch ngôn ngữ
  
  // Các TextEditingController để xử lý dữ liệu người dùng nhập vào
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();

  final List<Address> addresses = [
    Address(
      id: '1',
      name: 'John Doe',
      streetAddress: '123 Main Street',
      city: 'New York',
      state: 'NY',
      zipCode: '10001',
      phone: '(555) 123-4567',
      email: 'john.doe@gmail.com',
      isDefault: true,
    ),
    Address(
      id: '2',
      name: 'John Doe',
      streetAddress: '456 Park Avenue',
      city: 'Los Angeles',
      state: 'CA',
      zipCode: '90001',
      phone: '(555) 987-6543',
      email: 'john.doe@gmail.com',
    ),
  ];

  void _showAddressDialog({Address? addressToEdit}) {
  final isDark = Theme.of(context).brightness == Brightness.dark; // Kiểm tra chế độ tối (dark mode)
  final dialogLanguageProvider = context.read<LanguageProvider>(); // Đọc ngôn ngữ từ provider

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: isDark ? Colors.grey[900] : Colors.white, // Đặt màu nền cho hộp thoại
      title: Text(
        isEditing 
            ? dialogLanguageProvider.translate('edit_address') // Nếu đang chỉnh sửa, hiển thị 'Chỉnh sửa địa chỉ'
            : dialogLanguageProvider.translate('add_new_address'), // Nếu không, hiển thị 'Thêm địa chỉ mới'
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black, // Màu sắc của tiêu đề
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey, // Khóa global cho form
          child: Column(
            mainAxisSize: MainAxisSize.min, // Đảm bảo form không chiếm quá nhiều không gian
            children: [
              // Full Name
              TextFormField(
                controller: _nameController, // Điều khiển trường nhập liệu cho tên
                style: TextStyle(color: isDark ? Colors.white : Colors.black), // Màu văn bản
                decoration: InputDecoration(
                  labelText: dialogLanguageProvider.translate('full_name'), // Dịch label
                  hintText: dialogLanguageProvider.translate('enter_full_name'), // Dịch hint
                  labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.grey[700]),
                  prefixIcon: Icon(Icons.person_outline, color: isDark ? Colors.white70 : Colors.grey[700]), // Biểu tượng trước trường nhập liệu
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8), // Bo góc cho ô nhập liệu
                  ),
                ),
                validator: (value) => value?.isEmpty ?? true 
                    ? dialogLanguageProvider.translate('name_required') // Kiểm tra nếu tên trống
                    : null,
              ),
              const SizedBox(height: 16), // Khoảng cách giữa các trường nhập liệu

              // Phone Number
              TextFormField(
                controller: _phoneController, // Điều khiển trường nhập liệu cho số điện thoại
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                keyboardType: TextInputType.phone, // Chỉ cho phép nhập số điện thoại
                decoration: InputDecoration(
                  labelText: dialogLanguageProvider.translate('phone_number'), // Dịch label
                  hintText: dialogLanguageProvider.translate('enter_phone'), // Dịch hint
                  labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.grey[700]),
                  prefixIcon: Icon(Icons.phone_outlined, color: isDark ? Colors.white70 : Colors.grey[700]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) => value?.isEmpty ?? true 
                    ? dialogLanguageProvider.translate('phone_required') // Kiểm tra nếu số điện thoại trống
                    : null,
              ),
              const SizedBox(height: 16),

              // Email
              TextFormField(
                controller: _emailController, // Điều khiển trường nhập liệu cho email
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                keyboardType: TextInputType.emailAddress, // Chỉ cho phép nhập địa chỉ email
                decoration: InputDecoration(
                  labelText: dialogLanguageProvider.translate('email'), // Dịch label
                  hintText: dialogLanguageProvider.translate('enter_email'), // Dịch hint
                  labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.grey[700]),
                  prefixIcon: Icon(Icons.email_outlined, color: isDark ? Colors.white70 : Colors.grey[700]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) => value?.isEmpty ?? true 
                    ? dialogLanguageProvider.translate('email_required') // Kiểm tra nếu email trống
                    : null,
              ),
              const SizedBox(height: 16),

              // Street Address
              TextFormField(
                controller: _streetController, // Điều khiển trường nhập liệu cho địa chỉ đường phố
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                decoration: InputDecoration(
                  labelText: dialogLanguageProvider.translate('street_address'), // Dịch label
                  hintText: dialogLanguageProvider.translate('enter_street'), // Dịch hint
                  labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.grey[700]),
                  prefixIcon: Icon(Icons.home_outlined, color: isDark ? Colors.white70 : Colors.grey[700]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) => value?.isEmpty ?? true 
                    ? dialogLanguageProvider.translate('address_required') // Kiểm tra nếu địa chỉ trống
                    : null,
              ),
              const SizedBox(height: 16),


              // City/Province
              TextFormField(
                controller: _cityController, // Controller để theo dõi giá trị của trường nhập liệu này
                style: TextStyle(color: isDark ? Colors.white : Colors.black), // Màu chữ sẽ thay đổi tùy theo chế độ sáng/tối
                decoration: InputDecoration(
                  labelText: dialogLanguageProvider.translate('city_province'), // Nhãn của trường nhập liệu, sẽ dịch từ ngôn ngữ hiện tại
                  hintText: dialogLanguageProvider.translate('select_city'), // Hướng dẫn người dùng chọn thành phố
                   labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.grey[700]), // Màu sắc của nhãn
                  prefixIcon: Icon(Icons.location_city_outlined, color: isDark ? Colors.white70 : Colors.grey[700]), // Biểu tượng trước trường nhập liệu (biểu tượng thành phố)
                  border: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(8), // Viền ô nhập liệu có bo góc
                  ),
                ),
                validator: (value) => value?.isEmpty ?? true 
                     ? dialogLanguageProvider.translate('city_required') // Kiểm tra xem người dùng có nhập thành phố chưa
                    : null,
                ),

              const SizedBox(height: 16),

              // District
              TextFormField(
                controller: _stateController, // Controller để theo dõi giá trị của trường nhập liệu này
                style: TextStyle(color: isDark ? Colors.white : Colors.black), // Màu chữ sẽ thay đổi tùy theo chế độ sáng/tối
                decoration: InputDecoration(
                 labelText: dialogLanguageProvider.translate('district'), // Nhãn của trường nhập liệu, sẽ dịch từ ngôn ngữ hiện tại
                 hintText: dialogLanguageProvider.translate('select_district'), // Hướng dẫn người dùng chọn quận/huyện
                 labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.grey[700]), // Màu sắc của nhãn
                 prefixIcon: Icon(Icons.location_on_outlined, color: isDark ? Colors.white70 : Colors.grey[700]), // Biểu tượng trước trường nhập liệu (biểu tượng quận/huyện)
                 border: OutlineInputBorder(
                 borderRadius: BorderRadius.circular(8), // Viền ô nhập liệu có bo góc
                ),
              ),
                validator: (value) => value?.isEmpty ?? true 
               ? dialogLanguageProvider.translate('district_required') // Kiểm tra xem người dùng có nhập quận/huyện chưa
               : null,
              ),

              const SizedBox(height: 16),

              // Ward
              ElevatedButton(
  onPressed: () {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        if (isEditing && addressToEdit != null) {
          // Cập nhật thông tin địa chỉ
          addressToEdit.name = _nameController.text;
          addressToEdit.phone = _phoneController.text;
          addressToEdit.email = _emailController.text;
          addressToEdit.streetAddress = _streetController.text;
          addressToEdit.city = _cityController.text;
          addressToEdit.state = _stateController.text;
          addressToEdit.zipCode = _zipController.text;
        } else {
          // Thêm địa chỉ mới vào danh sách
          addresses.add(
            Address(
              id: DateTime.now().toString(),
              name: _nameController.text,
              phone: _phoneController.text,
              email: _emailController.text,
              streetAddress: _streetController.text,
              city: _cityController.text,
              state: _stateController.text,
              zipCode: _zipController.text,
              isDefault: addresses.isEmpty,
            ),
          );
        }
      });
      Navigator.pop(context); // Đóng hộp thoại sau khi lưu
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEditing 
                ? dialogLanguageProvider.translate('address_updated')
                : dialogLanguageProvider.translate('address_added')
          ),
        ),
      );
    }
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: isDark ? Colors.blue : Theme.of(context).primaryColor,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
  child: Text(dialogLanguageProvider.translate('save')),
        ),
      ],
    ),
  );
}
  

  @override
  Widget build(BuildContext context) {
  // Kiểm tra chế độ sáng/tối của ứng dụng. Nếu ứng dụng đang ở chế độ tối, biến isDark sẽ có giá trị là true.
  final isDark = Theme.of(context).brightness == Brightness.dark;

  // Lấy đối tượng LanguageProvider để hỗ trợ dịch ngôn ngữ cho các chuỗi trong ứng dụng
  final languageProvider = context.watch<LanguageProvider>();

  // Xây dựng Scaffold - widget cơ bản cho giao diện ứng dụng
  return Scaffold(
    // AppBar - thanh tiêu đề của màn hình
    appBar: AppBar(
      title: Text(
        // Sử dụng provider để lấy văn bản đã được dịch theo ngôn ngữ hiện tại (My Addresses)
        languageProvider.translate('my_addresses'),
        style: TextStyle(
          // Điều chỉnh màu sắc văn bản của title dựa trên chế độ sáng/tối
          color: isDark ? Colors.white : Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: isDark ? Colors.black : Colors.white, // Điều chỉnh màu nền của AppBar
      elevation: 0, // Không có bóng đổ
      leading: IconButton(
        // Nút quay lại (back button) khi người dùng bấm vào
        icon: Icon(
          Icons.arrow_back_ios,
          color: isDark ? Colors.white : Colors.black, // Điều chỉnh màu sắc của icon
        ),
        onPressed: () => Navigator.pushReplacement(
          context,
          // Khi bấm vào nút back, ứng dụng sẽ chuyển đến màn hình ProfileScreen
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        ),
      ),
    ),
    
    // Thân chính của màn hình
    body: Container(
      color: isDark ? Colors.black : Colors.grey[50], // Màu nền của container thay đổi theo chế độ sáng/tối
      child: addresses.isEmpty 
          // Nếu không có địa chỉ, hiển thị thông báo "No addresses"
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Căn giữa các phần tử
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 80, // Kích thước của icon
                    color: isDark ? Colors.grey[700] : Colors.grey[300], // Màu sắc của icon
                  ),
                  const SizedBox(height: 16), // Khoảng cách giữa icon và text
                  Text(
                    languageProvider.translate('no_addresses'), // Dịch văn bản "No addresses"
                    style: TextStyle(
                      fontSize: 20,
                      color: isDark ? Colors.grey[400] : Colors.grey[600], // Màu sắc của văn bản
                      fontWeight: FontWeight.w500, // Định dạng độ đậm của văn bản
                    ),
                  ),
                ],
              ),
            )
          // Nếu có địa chỉ, hiển thị danh sách địa chỉ
          : ListView.builder(
              padding: const EdgeInsets.all(16), // Đệm xung quanh ListView
              itemCount: addresses.length, // Đếm số lượng địa chỉ để tạo các item tương ứng
              itemBuilder: (context, index) => 
                  _buildAddressCard(addresses[index]), // Gọi hàm _buildAddressCard để xây dựng mỗi địa chỉ
            ),
    ),
    floatingActionButton: FloatingActionButton(
  // Khi người dùng nhấn vào nút, gọi phương thức _showAddressDialog để mở hộp thoại thêm/sửa địa chỉ
  onPressed: () => _showAddressDialog(),
  
  // Điều chỉnh màu nền của nút FloatingActionButton dựa trên chế độ sáng/tối
  backgroundColor: isDark ? Colors.white : Colors.black,
  
  // Thiết lập icon bên trong nút FloatingActionButton, biểu tượng dấu cộng
  child: Icon(
    Icons.add, // Icon dấu cộng
    // Điều chỉnh màu của icon dựa trên chế độ sáng/tối
    color: isDark ? Colors.black : Colors.white, 
      ),
    ),
  );
}


 Widget _buildAddressCard(Address address) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final languageProvider = context.watch<LanguageProvider>();

  return Card(
    // Điều chỉnh màu sắc của thẻ Card theo chế độ sáng/tối
    color: isDark ? Colors.grey[900] : Colors.white,
    margin: const EdgeInsets.only(bottom: 16), // Khoảng cách phía dưới mỗi thẻ
    child: Padding(
      padding: const EdgeInsets.all(16), // Khoảng cách giữa nội dung thẻ và viền
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Chia đều không gian giữa các phần tử trong hàng
            children: [
              // Hiển thị tên địa chỉ
              Text(
                address.name, 
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black, // Điều chỉnh màu sắc theo chế độ
                ),
              ),
              // Thêm một nút menu để chỉnh sửa hoặc xóa địa chỉ
              PopupMenuButton(
                icon: Icon(
                  Icons.more_vert, // Biểu tượng menu ba chấm
                  color: isDark ? Colors.white70 : Colors.grey[700], // Điều chỉnh màu icon theo chế độ
                ),
                itemBuilder: (context) => [
                  // Mục "Edit" - chỉnh sửa địa chỉ
                  PopupMenuItem(
                    child: Text(languageProvider.translate('edit')), // Dịch từ "edit"
                    onTap: () {
                      isEditing = true; // Đánh dấu là đang chỉnh sửa
                      // Cập nhật các controller với thông tin địa chỉ hiện tại
                      _nameController.text = address.name;
                      _phoneController.text = address.phone;
                      _emailController.text = address.email;
                      _streetController.text = address.streetAddress;
                      _cityController.text = address.city;
                      _stateController.text = address.state;
                      _zipController.text = address.zipCode;
                      // Mở hộp thoại để chỉnh sửa địa chỉ
                      _showAddressDialog(addressToEdit: address);
                    },
                  ),
                  // Mục "Delete" - xóa địa chỉ
                  PopupMenuItem(
                    child: Text(languageProvider.translate('delete')), // Dịch từ "delete"
                    onTap: () {
                      setState(() {
                        addresses.remove(address); // Xóa địa chỉ khỏi danh sách
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
           // Khoảng cách giữa các phần tử trong giao diện
      const SizedBox(height: 8),
// Hiển thị địa chỉ của người nhận
      Text(
        address.streetAddress, // Địa chỉ nhà của người nhận
        style: TextStyle(
        color: isDark ? Colors.white70 : Colors.grey[700], // Chỉnh màu sắc phù hợp với chế độ sáng/tối
        ),
      ),
// Hiển thị thành phố, quận/huyện, mã bưu điện
      Text(
        '${address.city}, ${address.state} ${address.zipCode}', // Thành phố, quận/huyện và mã bưu điện
        style: TextStyle(
        color: isDark ? Colors.white70 : Colors.grey[700], // Chỉnh màu sắc phù hợp với chế độ sáng/tối
       ),
      ),

// Khoảng cách giữa các phần tử trong giao diện
    const SizedBox(height: 8),
// Hiển thị số điện thoại của người nhận
    Text(
      address.phone, // Số điện thoại của người nhận
      style: TextStyle(
      color: isDark ? Colors.white70 : Colors.grey[700], // Chỉnh màu sắc phù hợp với chế độ sáng/tối
      ),
    ),

// Hiển thị email của người nhận
    Text(
      address.email, // Địa chỉ email của người nhận
      style: TextStyle(
      color: isDark ? Colors.white70 : Colors.grey[700], // Chỉnh màu sắc phù hợp với chế độ sáng/tối
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // ...dispose controllers...
    super.dispose();
  }
}