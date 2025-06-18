import 'package:dio/dio.dart';
import '../model/endemik.dart';
import '../helper/database_helper.dart';

class EndemikService {
  final Dio _dio = Dio();

  Future<bool> isDataAvailable() async {
    final dbHelper = DatabaseHelper();
    final int count = await dbHelper.count();
    return count > 0;
  }

  Future<List<Endemik>> getData() async {
    final dbHelper = DatabaseHelper();

    try {
      bool dataExists = await isDataAvailable();
      if (dataExists) {
        print("Data sudah ada di database, tidak perlu mengambil dari API.");
        final List<Endemik> oldData = await dbHelper.getAll();
        return oldData;
      }

      final response = await _dio
          .get('https://hendroprwk08.github.io/data_endemik/endemik.json');
      final List<dynamic> data = response.data;

      for (var json in data) {
        Endemik model = Endemik(
            id: json["id"],
            nama: json["nama"],
            nama_latin: json["nama_latin"],
            deskripsi: json["deskripsi"],
            asal: json["asal"],
            foto: json["foto"],
            status: json["status"],
            is_favorit: "false" );

        await dbHelper.insert(model);
      }

      return data.map((json) => Endemik.fromJson(json)).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<Endemik>> getFavoritData() async {
    try {
      final db = await DatabaseHelper();
      final List<Endemik> data = await db.getFavoritAll();
      return data;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<void> hapusSemuaFavorit() async {
    final dbHelper = DatabaseHelper();
    await dbHelper.deleteFavoritAll();
  }
}
