import 'package:flutter/material.dart';
import '/model/endemik.dart';
import '/service/endemik_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Endemik> endemik = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    final endemikService = EndemikService();
    final data = await endemikService.getData();
    setState(() {
      endemik = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Endemik DB'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.count(
        crossAxisCount: orientation == Orientation.portrait ? 2 : 4,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        padding: const EdgeInsets.all(8),
        children: List.generate(endemik.length, (index) {
          final item = endemik[index];
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/detail',
                arguments: {
                  'a_tag': 'image $index',
                  'a_id': item.id,
                  'a_nama': item.nama,
                  'a_nama_latin': item.nama_latin,
                  'a_deskripsi': item.deskripsi,
                  'a_asal': item.asal,
                  'a_foto': item.foto,
                  'a_status': item.status,
                },
              );
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
                        tag: 'image $index',
                        child: Image.network(
                          item.foto,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) =>
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
                      style:
                      const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
