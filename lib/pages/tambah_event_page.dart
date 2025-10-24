import 'package:flutter/material.dart';
import '../models/event_model.dart';
import 'package:intl/intl.dart';

class TambahEventPage extends StatefulWidget {
  const TambahEventPage({super.key});

  @override
  State<TambahEventPage> createState() => _TambahEventPageState();
}

class _TambahEventPageState extends State<TambahEventPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final List<String> _categories = ['Umum', 'Pendidikan', 'Olahraga'];
  String? _selectedCategory;
  DateTime _selectedDateTime = DateTime.now();

  // --- pilih tanggal dan waktu ---
  Future<void> _pickDateTime() async {
    final today = DateTime.now();

    // Pilih tanggal (tidak bisa tanggal yang sudah lewat)
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime.isBefore(today)
          ? today
          : _selectedDateTime,
      firstDate: today,
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      // Pilih jam
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      );

      if (pickedTime != null) {
        final selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        // Cek apakah waktu yang dipilih sudah lewat
        if (selectedDateTime.isBefore(today)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Tidak bisa memilih waktu yang sudah lewat!"),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        setState(() {
          _selectedDateTime = selectedDateTime;
        });
      }
    }
  }

  // --- simpan event dan kembali ke daftar ---
  void _saveEvent() {
    if (_formKey.currentState!.validate()) {
      final now = DateTime.now();

      // Validasi agar waktu event tidak di masa lalu
      if (_selectedDateTime.isBefore(now)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Waktu event tidak boleh di masa lalu!"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final newEvent = Event(
        title: _titleController.text,
        category: _selectedCategory ?? 'Umum',
        dateTime: _selectedDateTime,
      );

      // kirim data balik ke halaman sebelumnya
      Navigator.pop(context, newEvent);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        DateFormat('dd MMM yyyy, HH:mm').format(_selectedDateTime);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Tambah Event"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "Judul Event",
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v!.isEmpty ? "Judul tidak boleh kosong" : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: "Kategori",
                  border: OutlineInputBorder(),
                ),
                items: _categories
                    .map((e) =>
                        DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedCategory = v),
                validator: (v) => v == null ? "Pilih kategori" : null,
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text("Tanggal & Waktu"),
                subtitle: Text(formattedDate),
                trailing: ElevatedButton.icon(
                  onPressed: _pickDateTime,
                  icon: const Icon(Icons.calendar_today, color: Colors.white),
                  label: const Text("Pilih",
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _saveEvent,
                icon: const Icon(Icons.save, color: Colors.white),
                label: const Text("Simpan Event",
                    style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
