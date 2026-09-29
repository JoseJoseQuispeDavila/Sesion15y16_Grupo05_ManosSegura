import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:manos_seguras/services/higiene_api_service.dart';

void main() {
  test('Future.wait ejecuta las dos consultas en paralelo', () async {
    final HigieneApiService servicio = HigieneApiService(
      cliente: MockClient((http.Request peticion) async {
        await Future<void>.delayed(const Duration(milliseconds: 200));

        if (peticion.url.queryParameters[r'$top'] == '20') {
          expect(
            peticion.url.queryParameters[r'$filter'],
            "TimeDim eq 2024 and SpatialDimType eq 'COUNTRY'",
          );
        }

        return http.Response.bytes(
          utf8.encode(
            '{"value":['
            '{"IndicatorCode":"WSH_HYGIENE_BASIC",'
            '"SpatialDim":"PER","TimeDim":2024,'
            '"NumericValue":72.3}'
            ']}',
          ),
          200,
        );
      }),
    );

    final ComparacionConsultas resultado = await servicio.compararConsultas(
      2024,
    );

    expect(resultado.indicadoresPeru, isNotEmpty);
    expect(resultado.paises, isNotEmpty);
    expect(
      resultado.tiempoParalelo,
      lessThan(resultado.tiempoSecuencial),
    );

    servicio.cerrar();
  });
}
