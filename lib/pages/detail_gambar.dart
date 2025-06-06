import 'package:flutter/material.dart';

class DetailGambarPage extends StatelessWidget {
  const DetailGambarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final imageUrl = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Gambar'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Hero(
          tag: imageUrl,
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.broken_image, size: 100),
          ),
        ),
      ),
    );
  }
}
