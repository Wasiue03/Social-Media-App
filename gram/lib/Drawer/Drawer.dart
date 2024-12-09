import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final Function(int) onMenuItemSelected;
  final VoidCallback onLogout;

  CustomDrawer({required this.onMenuItemSelected, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      child: ListView(
        children: [
          DrawerHeader(
            child: Text('Menu', style: TextStyle(color: Colors.white)),
            decoration: BoxDecoration(color: Colors.black),
          ),
          ListTile(
            title: Text('Home', style: TextStyle(color: Colors.white)),
            onTap: () {
              onMenuItemSelected(0); // Notify parent about menu selection
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            title: Text('Settings', style: TextStyle(color: Colors.white)),
            onTap: () {
              onMenuItemSelected(1); // Notify parent about menu selection
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            title: Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () {
              onLogout(); // Call the logout function passed from parent
            },
          ),
        ],
      ),
    );
  }
}
