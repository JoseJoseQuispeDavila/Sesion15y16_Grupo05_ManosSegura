import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:manos_seguras/services/higiene_api_service.dart';

void main() {
  test('consulta HWWS_1 reutilizando IndicadorHigiene', () async {
    final MockClient cliente = MockClient((http.Request solicitud) async {
      expect(solicitud.url.path, '/api/HWWS_1');
      expect(solicitud.url.queryParameters[r'$filter'], "SpatialDim eq 'PER'");

      return http.Response.bytes(
        utf8.encode(
          jsonEncode({
            'value': [
              {
                'IndicatorCode': 'HWWS_1',
                'SpatialDim': 'PER',
                'TimeDim': 2024,
                'Dim1': 'RESIDENCEAREATYPE_TOTL',
                'NumericValue': 82.5,
              },
            ],
          }),
        ),
        200,
      );
    });
    final HigieneApiService servicio = HigieneApiService(cliente: cliente);

    final indicadores = await servicio.obtenerLavadoDespuesDelInodoroPeru();

    expect(indicadores, hasLength(1));
    expect(indicadores.first.codigoIndicador, 'HWWS_1');
    expect(indicadores.first.anio, 2024);
    expect(indicadores.first.valor, 82.5);
  });
}
