import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class DetailGambarPage extends StatelessWidget {
  const DetailGambarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final imageUrl = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Gambar'),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Hero(
          tag: imageUrl,
          child: ClipRect(
            child: PhotoView(
              imageProvider: NetworkImage(imageUrl),
              errorBuilder: (context, error, stackTrace) =>
              const Center(child: Icon(Icons.broken_image, size: 100)),
              backgroundDecoration: const BoxDecoration(
                color: Colors.black,
              ),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 3.0,
              initialScale: PhotoViewComputedScale.contained,
              enableRotation: false,
            ),
          ),
        ),
      ),
    );
  }
}
