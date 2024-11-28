import 'package:flutter/material.dart';
import 'package:staygo/Beranda/beranda.dart';
import 'package:staygo/Favorite/favorite.dart';
import 'package:staygo/History/historyPemesanan.dart';
import 'package:staygo/Profile/profilePage.dart';

class BottomNavigation extends StatefulWidget {
  final int customerId;
  final String accessToken;

  const BottomNavigation(
      {Key? key,
      required this.customerId,
      required this.accessToken})
      : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 0;

  late List<Widget> _pages; // Define the pages list as a member variable.

  @override
  void initState() {
    super.initState();
    // Initialize pages with the username for BerandaPage.
    _pages = [
      BerandaPage(customerId: widget.customerId, accessToken: widget.accessToken),
      HistoryPemesanan(),
      FavoritePage(customerId: widget.customerId, accessToken: widget.accessToken),
      Profilepage(
        accessToken: widget.accessToken,
        customerId: widget.customerId,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex], // Show the selected page.
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Change page index.
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border_outlined),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined),
            label: 'Profil',
          ),
        ],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
      ),
    );
  }
}
