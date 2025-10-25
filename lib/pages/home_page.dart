import 'package:flutter/material.dart';
import '../models/event_model.dart';
import 'daftar_event_page.dart';
import 'tambah_event_page.dart';
import 'media_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<Event> _events = []; // simpan semua event di sini

  final List<String> _titles = [
    "My Event Planner",
    "Tambah Event",
    "Media Event",
  ];

  @override
  Widget build(BuildContext context) {
    // halaman ditentukan dinamis
    final pages = [
      DaftarEventPage(events: _events),
      const TambahEventPage(),
      const MediaEventPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        backgroundColor: Colors.blue,
        leading: _selectedIndex == 0
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => setState(() => _selectedIndex = 0),
              ),
      ),
      backgroundColor: Colors.white,
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: (index) async {
          if (index == 1) {
            final newEvent = await Navigator.push<Event>(
              context,
              MaterialPageRoute(builder: (_) => const TambahEventPage()),
            );

            if (newEvent != null && mounted) {
              setState(() {
                _events.add(newEvent); // tambahkan ke list utama
                _selectedIndex = 0; // kembali ke daftar event
              });
            }
          } else {
            setState(() => _selectedIndex = index);
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Daftar'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: 'Tambah'),
          BottomNavigationBarItem(icon: Icon(Icons.perm_media), label: 'Media'),
        ],
      ),
    );
  }
}
