import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:learn_flutter_firebase/widgets/custom_text_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Constants
  static const _primaryPurple = Color.fromARGB(183, 28, 11, 51);
  static const _darkPurple = Color.fromARGB(255, 35, 18, 58);
  static const _textColor = Colors.white;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  // Get user display name or email
  String get _userDisplayText => 
    FirebaseAuth.instance.currentUser?.displayName ?? 
    FirebaseAuth.instance.currentUser?.email ?? 
    'Misafir';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(),
      body: _buildBody(),
      drawer: _buildDrawer(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: _primaryPurple,
      titleSpacing: 0,
      automaticallyImplyLeading: false,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: GestureDetector(
          onTap: () => _scaffoldKey.currentState?.openDrawer(),
          child: _buildUserProfileRow(iconSize: 30),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return const Center(
      child: Text(
        'Welcome to Home Page!', 
        style: TextStyle(fontSize: 24, color: _textColor),
      ),
    );
  }

  Widget _buildUserProfileRow({required double iconSize}) {
    return Row(
      children: [
        Icon(
          Icons.account_circle,
          color: _textColor,
          size: iconSize,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            _userDisplayText,
            style: const TextStyle(
              fontSize: 16,
              color: _textColor,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: _darkPurple,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        children: [
          _buildDrawerHeader(),
          _buildSettingsListTile(),
          _buildLogoutListTile(),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return DrawerHeader(
      decoration: const BoxDecoration(color: _darkPurple),
      child: _buildUserProfileRow(iconSize: 50),
    );
  }

  Widget _buildSettingsListTile() {
    return ListTile(
      leading: const Icon(
        Icons.settings,
        color: _textColor,
      ),
      title: const Text('Ayarlar', style: TextStyle(color: _textColor)),
      onTap: () {
        // Navigate to settings page
        Navigator.pushNamed(context, '/settings');
      },
    );
  }

  Widget _buildLogoutListTile() {
    return ListTile(
      leading: const Icon(Icons.logout, color: _textColor),
      title: const Text('Çıkış Yap', style: TextStyle(color: _textColor)),
      onTap: _handleLogout,
    );
  }

  Future<void> _handleLogout() async {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      Navigator.of(context).pushReplacementNamed('/sign-in');
    }
  }
}