import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../home/home_screen.dart';
import '../home/profile_screen.dart';
import '../product/language_setting.dart';
import '../widgets/theme_dark.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  int _selectedIndex = 4;
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  final themeProvider = ThemeProvider();

  Widget _buildSettingSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        ...children,
        const Divider(height: 1),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = context.watch<LanguageProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          languageProvider.translate('settings'),
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark 
                ? Colors.white 
                : Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Theme.of(context).brightness == Brightness.dark 
            ? Colors.black 
            : Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).brightness == Brightness.dark 
                ? Colors.white 
                : Colors.black,
          ),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ProfileScreen()),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildSettingSection(
              languageProvider.translate('account'),
              [
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: Text(languageProvider.translate('profile_info')),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.lock_outline),
                  title: Text(languageProvider.translate('change_password')),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                ),
              ],
            ),
            _buildSettingSection(
              languageProvider.translate('preferences'),
              [
                SwitchListTile(
                  secondary: const Icon(Icons.notifications_none),
                  title: Text(languageProvider.translate('notifications')),
                  value: _notificationsEnabled,
                  activeColor: Colors.white, // Switch thumb color when active
                  activeTrackColor: Colors.green, // Switch track color when active
                  inactiveThumbColor: Colors.white, // Switch thumb color when inactive
                  inactiveTrackColor: Colors.grey[300], 
                  onChanged: (value) => setState(() => _notificationsEnabled = value),
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.dark_mode_outlined),
                  title: Text(languageProvider.translate('dark_mode')),
                  value: context.watch<ThemeProvider>().isDarkMode,
                  activeColor: Colors.white, // Switch thumb color when active
                  activeTrackColor: Colors.green, // Switch track color when active
                  inactiveThumbColor: Colors.white, // Switch thumb color when inactive
                  inactiveTrackColor: Colors.grey[300], 
                  onChanged: (value) {
                    setState(() {
                      context.read<ThemeProvider>().toggleTheme();
                    });
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.language_outlined),
                  title: Text(languageProvider.translate('language')),
                  trailing: DropdownButton<String>(
                    value: languageProvider.currentLanguage,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(value: 'vi', child: Text('Tiếng Việt')),
                      DropdownMenuItem(value: 'en', child: Text('English')),
                    ],
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          context.read<LanguageProvider>().setLanguage(newValue);
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            _buildSettingSection(
              languageProvider.translate('about'),
              [
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: Text(languageProvider.translate('app_version')),
                  trailing: const Text('1.0.0'),
                ),
                ListTile(
                  leading: const Icon(Icons.description_outlined),
                  title: Text(languageProvider.translate('terms')),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: Text(languageProvider.translate('privacy')),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}