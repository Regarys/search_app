import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tugas_pencarian/Response/respon_data.dart';

final dio = Dio();

class ApiService {
  Future<ResponseMakanan> getapi() async {
    try {
      final response = await dio.get('http://10.0.2.2:8000/makanan/');
      if (response.statusCode == 200) {
        // debugPrint('GET Product : ${response.data['makanan']}');
        return ResponseMakanan.fromJson(response.data['makanan']);
      } else {
        throw Exception('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Failed to load data');
    }
  }
}
