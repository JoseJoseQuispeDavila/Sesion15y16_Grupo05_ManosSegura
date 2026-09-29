import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/publicacion.dart';

class PublicacionService {
  PublicacionService({http.Client? cliente})
    : _cliente = cliente ?? http.Client();

  final http.Client _cliente;

  Future<List<Publicacion>> obtenerPublicaciones() async {
    final Uri url = Uri.https(
      'jsonplaceholder.typicode.com',
      '/posts',
      <String, String>{'_limit': '5'},
    );

    final http.Response respuesta = await _cliente
        .get(url)
        .timeout(const Duration(seconds: 8));

    if (respuesta.statusCode != 200) {
      throw Exception('Error HTTP ${respuesta.statusCode}');
    }

    final dynamic decodificado = jsonDecode(
      utf8.decode(respuesta.bodyBytes),
    );

    if (decodificado is! List<dynamic>) {
      throw const FormatException(
        'La respuesta no contiene una lista.',
      );
    }

    return decodificado
        .whereType<Map<String, dynamic>>()
        .map(Publicacion.fromJson)
        .toList();
  }

  void cerrar() {
    _cliente.close();
  }
}
