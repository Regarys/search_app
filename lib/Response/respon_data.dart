import 'package:tugas_pencarian/Model/model_makanan.dart';

class ResponseMakanan {
  List<ModelMakanan> listMakanan = [];

  ResponseMakanan.fromJson(List<dynamic> json) {
    listMakanan = json.map((item) => ModelMakanan.fromJson(item)).toList();
  }
}
