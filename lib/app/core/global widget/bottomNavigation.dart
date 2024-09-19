import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final String currentScreen; // Indicator of the current active screen
  final Function(String) onMenuTap;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentScreen,
    required this.onMenuTap,
  }) : super(key: key);

  @override
  _CustomBottomNavigationBarState createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> with SingleTickerProviderStateMixin {
  bool isMenuOpen = false;

  // Build Floating Action Button (FAB) for the animated menu
  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        setState(() {
          isMenuOpen = !isMenuOpen; // Toggle the menu
        });
      },
      backgroundColor: Colors.blue,
      child: Icon(isMenuOpen ? Icons.close : Icons.menu),
    );
  }

  // Build individual bottom nav item
  Widget _buildBottomNavItem({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isSelected ? Colors.blue : Colors.grey),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.blue : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build the bottom navigation bar
  Widget _buildBottomNavBar() {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 8.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildBottomNavItem(
            title: 'Home',
            icon: Icons.home,
            isSelected: widget.currentScreen == 'Home',
            onTap: () {
              widget.onMenuTap('Home');
            },
          ),
          _buildBottomNavItem(
            title: 'Client',
            icon: Icons.person,
            isSelected: widget.currentScreen == 'Client',
            onTap: () {
              widget.onMenuTap('Client');
            },
          ),
        ],
      ),
    );
  }

  // Build the animated menu that expands in the middle
  Widget _buildAnimatedMenu() {
    if (!isMenuOpen) return Container();

    return Positioned(
      bottom: 80,
      left: MediaQuery.of(context).size.width / 2 - 75,
      child: Row(
        children: [
          _buildMenuAction(icon: Icons.list, label: 'Commande', onTap: () {
            widget.onMenuTap('Commande');
            setState(() {
              isMenuOpen = false; // Close menu when item is selected
            });
          }),
          const SizedBox(width: 16),
          _buildMenuAction(icon: Icons.insert_drive_file, label: 'Quote', onTap: () {
            widget.onMenuTap('Quote');
            setState(() {
              isMenuOpen = false; // Close menu when item is selected
            });
          }),
          const SizedBox(width: 16),
          _buildMenuAction(icon: Icons.history, label: 'History', onTap: () {
            widget.onMenuTap('History');
            setState(() {
              isMenuOpen = false; // Close menu when item is selected
            });
          }),
        ],
      ),
    );
  }

  // Build individual menu action
  Widget _buildMenuAction({required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.blueAccent,
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Stack(
        children: [
          _buildBottomNavBar(),
          _buildAnimatedMenu(), // Overlay the animated menu on top of the bottom bar
        ],
      ),
    );
  }
}
