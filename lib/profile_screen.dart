import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Cá nhân',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Khối Thông tin người dùng
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.blue.shade100,
                    child: const Icon(Icons.person, size: 40, color: Colors.blue),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Nguyễn Văn A',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'nguyenvana@example.com',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Danh sách tùy chọn cài đặt
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildMenuItem(Icons.person_outline, 'Thông tin cá nhân', () {}),
                  const Divider(height: 1),
                  _buildMenuItem(Icons.settings_outlined, 'Cài đặt ngân sách', () {}),
                  const Divider(height: 1),
                  _buildMenuItem(Icons.format_list_bulleted, 'Danh mục chi tiêu', () {}),
                  const Divider(height: 1),
                  _buildMenuItem(Icons.cloud_upload_outlined, 'Sao lưu dữ liệu', () {}),
                  const Divider(height: 1),
                  _buildMenuItem(Icons.lock_outline, 'Đổi mật khẩu', () {}),
                  const Divider(height: 1),
                  _buildMenuItem(
                    Icons.logout,
                    'Đăng xuất',
                        () {},
                    textColor: Colors.red,
                    iconColor: Colors.red,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
      IconData icon,
      String title,
      VoidCallback onTap, {
        Color textColor = Colors.black87,
        Color iconColor = Colors.black54,
      }) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(
        title,
        style: TextStyle(
          color: textColor,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: textColor == Colors.red ? Colors.red : Colors.grey,
      ),
      onTap: onTap,
    );
  }
}