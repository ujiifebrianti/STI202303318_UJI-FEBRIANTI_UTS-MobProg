import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class MediaEventPage extends StatefulWidget {
  const MediaEventPage({super.key});

  @override
  State<MediaEventPage> createState() => _MediaEventPageState();
}

class _MediaEventPageState extends State<MediaEventPage> {
  final List<File> _mediaFiles = [];
  final picker = ImagePicker();
  final Map<File, VideoPlayerController> _videoControllers = {};

  // Ambil foto atau video langsung dari kamera 📸
  Future<void> _pickMedia(bool isVideo) async {
    final pickedFile = await (isVideo
        ? picker.pickVideo(source: ImageSource.camera) // kamera video
        : picker.pickImage(source: ImageSource.camera)); // kamera foto

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      setState(() {
        _mediaFiles.add(file);
      });

      // Jika video, buat controller untuk preview
      if (isVideo) {
        final controller = VideoPlayerController.file(file)
          ..initialize().then((_) {
            setState(() {});
          });
        _videoControllers[file] = controller;
      }
    }
  }

  // Hapus media
  void _deleteMedia(int index) {
    final file = _mediaFiles[index];
    if (_videoControllers.containsKey(file)) {
      _videoControllers[file]?.dispose();
      _videoControllers.remove(file);
    }
    setState(() {
      _mediaFiles.removeAt(index);
    });
  }

  @override
  void dispose() {
    for (var controller in _videoControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: () => _pickMedia(false),
              icon: const Icon(Icons.camera_alt),
              label: const Text("Ambil Foto"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () => _pickMedia(true),
              icon: const Icon(Icons.videocam),
              label: const Text("Rekam Video"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Expanded(
          child: _mediaFiles.isEmpty
              ? const Center(child: Text("Belum ada media diunggah."))
              : GridView.builder(
                  padding: const EdgeInsets.all(10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: _mediaFiles.length,
                  itemBuilder: (context, index) {
                    final file = _mediaFiles[index];
                    final isVideo = _videoControllers.containsKey(file);

                    return Stack(
                      children: [
                        Positioned.fill(
                          child: isVideo
                              ? _videoControllers[file]!.value.isInitialized
                                  ? AspectRatio(
                                      aspectRatio: _videoControllers[file]!
                                          .value
                                          .aspectRatio,
                                      child: VideoPlayer(
                                          _videoControllers[file]!),
                                    )
                                  : const Center(
                                      child: CircularProgressIndicator(),
                                    )
                              : Image.file(file, fit: BoxFit.cover),
                        ),
                        Positioned(
                          right: 0,
                          child: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteMedia(index),
                          ),
                        ),
                      ],
                    );
                  },
                ),
        ),
      ],
    );
  }
}
