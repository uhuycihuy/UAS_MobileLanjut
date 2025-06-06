import 'package:flutter/material.dart';
import '../model/endemik.dart';
import '../service/endemik_service.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<Endemik> favoritList = [];
  bool isLoading = true;
  final EndemikService _endemikService = EndemikService();

  @override
  void initState() {
    super.initState();
    _getFavoritData();
  }

  void _getFavoritData() async {
    final data = await _endemikService.getFavoritData();
    setState(() {
      favoritList = data;
      isLoading = false;
    });
  }

  Future<void> _hapusSemuaFavorit() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Yakin ingin menghapus semua favorit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        isLoading = true;
      });
      await _endemikService.hapusSemuaFavorit();
      _getFavoritData();
    }
  }

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Favorit'),
        backgroundColor: Colors.green,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : favoritList.isEmpty
          ? const Center(child: Text('Belum ada data favorit'))
          : GridView.count(
        crossAxisCount: orientation == Orientation.portrait ? 2 : 4,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        padding: const EdgeInsets.all(8),
        children: List.generate(favoritList.length, (index) {
          final item = favoritList[index];
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/detail',
                arguments: {
                  'a_tag': 'fav_image $index',
                  'a_id': item.id,
                  'a_nama': item.nama,
                  'a_nama_latin': item.nama_latin,
                  'a_deskripsi': item.deskripsi,
                  'a_asal': item.asal,
                  'a_foto': item.foto,
                  'a_status': item.status,
                },
              ).then((_) {
                // Reload data favorite saat kembali
                setState(() {
                  isLoading = true;
                });
                _getFavoritData();
              });
            },
            child: Card(
              color: Colors.white70,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5),
                      ),
                      child: Hero(
                        tag: 'fav_image $index',
                        child: Image.network(
                          item.foto,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder:
                              (context, error, stackTrace) =>
                          const Icon(Icons.broken_image),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      item.nama.length >= 20
                          ? '${item.nama.substring(0, 20)}...'
                          : item.nama,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
      floatingActionButton: favoritList.isNotEmpty
          ? FloatingActionButton.extended(
        onPressed: _hapusSemuaFavorit,
        icon: const Icon(Icons.delete),
        label: const Text('Hapus'),
        backgroundColor: Colors.red,
      )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
