import 'package:flutter/material.dart';
import 'package:staygo/Beranda/beranda.dart';
import 'package:staygo/Favorite/favorite.dart';
import 'package:staygo/History/historyPemesanan.dart';
import 'package:staygo/Profile/profilePage.dart';

class BottomNavigation extends StatefulWidget {
  final int customerId;
  final String username;
  final String nama;
  final String email;
  final String noHp;
  final String alamat;
  final String ttl;
  final String image;
  final String accessToken;

  const BottomNavigation(
      {Key? key,
      required this.customerId,
      required this.username,
      required this.nama,
      required this.email,
      required this.noHp,
      required this.alamat,
      required this.ttl,
      required this.image,
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
      BerandaPage(username: widget.username, accessToken: widget.accessToken,),
      HistoryPemesanan(),
      FavoritePage(accessToken: widget.accessToken),
      Profilepage(
        username: widget.username,
        nama: widget.nama,
        email: widget.email,
        noHp: widget.noHp,
        alamat: widget.alamat,
        ttl: widget.ttl,
        image: widget.image,
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
