import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // bạn có thể mở rộng: nhập URL JSON mới, đổi hiệu ứng rơi, bật ngôn ngữ EN/VI...
    return Scaffold(
      appBar: AppBar(title: const Text('Cài đặt')),
      body: ListView(
        children: const [
          ListTile(
            title: Text('Hiệu ứng rơi'),
            subtitle: Text('Giữ lâu nút tròn ở Home để bật/tắt nhanh'),
          ),
          ListTile(
            title: Text('Nguồn dữ liệu'),
            subtitle: Text('Đang đọc từ JSON công khai (GitHub Pages)'),
          ),
        ],
      ),
    );
  }
}
