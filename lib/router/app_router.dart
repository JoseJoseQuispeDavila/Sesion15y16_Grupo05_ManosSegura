import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/indicador_higiene.dart';
import '../screens/pantalla_bienvenida.dart';
import '../screens/pantalla_establecimiento.dart';
import '../screens/pantalla_indicador_detalle.dart';
import '../screens/pantalla_indicadores.dart';
import '../screens/pantalla_oportunidades.dart';
import '../screens/pantalla_personal.dart';

/// Configuración central de la navegación de ManosSeguras con
/// `go_router` (temática 1.4.1).
///
/// Ventajas frente a `Navigator` con rutas nombradas:
///  * todas las rutas del aplicativo se leen en un solo archivo;
///  * cada ruta se puede abrir desde una URL (web y deep links);
///  * los parámetros de ruta (`:anio`) se validan en un único lugar.
///
/// El flujo conserva la secuencia construida en las sesiones anteriores:
///   /  →  /establecimiento  →  /personal  →  /oportunidades
/// y agrega la rama nueva de la sesión:
///   /indicadores  →  /indicadores/:anio
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      name: 'bienvenida',
      builder: (BuildContext context, GoRouterState state) =>
          const PantallaBienvenida(),
    ),
    GoRoute(
      path: '/establecimiento',
      name: 'establecimiento',
      builder: (BuildContext context, GoRouterState state) =>
          const PantallaEstablecimiento(),
    ),
    GoRoute(
      path: '/personal',
      name: 'personal',
      builder: (BuildContext context, GoRouterState state) =>
          const PantallaPersonal(),
    ),
    GoRoute(
      path: '/oportunidades',
      name: 'oportunidades',
      builder: (BuildContext context, GoRouterState state) =>
          const PantallaOportunidades(),
    ),
    GoRoute(
      path: '/indicadores',
      name: 'indicadores',
      builder: (BuildContext context, GoRouterState state) =>
          const PantallaIndicadores(),
      // Ruta anidada: su ruta completa es /indicadores/:anio
      routes: <RouteBase>[
        GoRoute(
          path: ':anio',
          name: 'indicadorDetalle',
          builder: (BuildContext context, GoRouterState state) {
            // 1. Parámetro de ruta: siempre llega como String y debe
            //    convertirse y validarse antes de usarse.
            final int? anio = int.tryParse(state.pathParameters['anio'] ?? '');

            if (anio == null) {
              return const PantallaRutaInvalida(
                mensaje: 'El año solicitado no es un número válido.',
              );
            }

            // 2. `extra` transporta el objeto completo ya descargado, para
            //    no repetir la petición HTTP al abrir el detalle. Cuando la
            //    ruta se abre directamente por URL (deep link), extra es
            //    null y la pantalla de detalle consulta el API por su cuenta.
            final IndicadorHigiene? indicador = state.extra is IndicadorHigiene
                ? state.extra as IndicadorHigiene
                : null;

            return PantallaIndicadorDetalle(
              anio: anio,
              indicadorInicial: indicador,
            );
          },
        ),
      ],
    ),
  ],
  // Se ejecuta cuando la URL solicitada no coincide con ninguna ruta.
  errorBuilder: (BuildContext context, GoRouterState state) =>
      PantallaRutaInvalida(
        mensaje: 'No existe la ruta solicitada: ${state.uri}',
      ),
);

/// Pantalla de respaldo para rutas inexistentes o parámetros inválidos.
class PantallaRutaInvalida extends StatelessWidget {
  final String mensaje;

  const PantallaRutaInvalida({super.key, required this.mensaje});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ruta no disponible')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(Icons.wrong_location_outlined, size: 56),
              const SizedBox(height: 16),
              Text(mensaje, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go('/'),
                child: const Text('Volver al inicio'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
