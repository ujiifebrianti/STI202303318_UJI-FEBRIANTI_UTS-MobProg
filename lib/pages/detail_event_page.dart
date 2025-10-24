import 'package:flutter/material.dart';
import '../models/event_model.dart';
import 'package:intl/intl.dart';

class DetailEventPage extends StatelessWidget {
  final Event event;
  const DetailEventPage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    // Format tanggal & waktu agar tampil tanpa .000
    String formattedDateTime =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(event.dateTime);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Event"),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Judul Event
            Text(
              event.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),

            // Kategori Event
            Row(
              children: [
                const Icon(Icons.category, color: Colors.blueAccent),
                const SizedBox(width: 8),
                Text(
                  "Kategori: ${event.category}",
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Tanggal & Waktu Event (tanpa overflow dan tanpa .000)
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.blueAccent),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Tanggal & Waktu: $formattedDateTime",
                    style: const TextStyle(fontSize: 16),
                    overflow: TextOverflow.ellipsis, // cegah overflow
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Tombol kembali
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text("Kembali"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
