import 'package:flutter/material.dart';
import '../models/event_model.dart';
import 'detail_event_page.dart';
import 'welcome_page.dart'; // pastikan file ini ada

class DaftarEventPage extends StatefulWidget {
  final List<Event> events;
  const DaftarEventPage({super.key, required this.events});

  @override
  State<DaftarEventPage> createState() => _DaftarEventPageState();
}

class _DaftarEventPageState extends State<DaftarEventPage> {
  // fungsi hapus event dengan konfirmasi
  void _hapusEvent(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Event"),
        content: const Text("Apakah Anda yakin ingin menghapus event ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // batal
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                widget.events.removeAt(index); // hapus dari list
              });
              Navigator.pop(context); // tutup dialog
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Hapus", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Event"),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // kembali ke halaman WelcomePage
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const WelcomePage()),
            );
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: widget.events.isEmpty
          ? const Center(
              child: Text(
                "Belum ada event.",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            )
          : ListView.builder(
              itemCount: widget.events.length,
              itemBuilder: (context, index) {
                final event = widget.events[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: ListTile(
                    title: Text(
                      event.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "${event.category}\n${event.dateTime}",
                      style: const TextStyle(color: Colors.black54),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailEventPage(event: event),
                        ),
                      );
                    },
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _hapusEvent(index),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
