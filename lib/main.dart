import 'package:flutter/material.dart';

import 'router/app_router.dart';
import 'theme/app_theme.dart';
import 'theme/tema_app.dart';

/// ManosSeguras — proyecto integrador de SIS048 - Desarrollo de Software
/// II (UAC), alineado al ODS 3 (Salud y bienestar).
///
/// Flujo de navegación (definido íntegramente en lib/router/app_router.dart):
///   /  ->  /establecimiento  ->  /personal  ->  /oportunidades
///   /indicadores  ->  /indicadores/:anio
///
/// Cambio de la Sesión 15-16: la aplicación deja de declarar `home:` y
/// pasa a usar `MaterialApp.router`, delegando TODA la navegación al
/// objeto `appRouter` (go_router). La raíz de la app sigue siendo un
/// StatelessWidget: el estado del tema continúa viviendo en [temaApp]
/// (lib/theme/tema_app.dart).
void main() {
  runApp(const ManosSegurasApp());
}

class ManosSegurasApp extends StatelessWidget {
  const ManosSegurasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: temaApp,
      builder: (BuildContext context, ThemeMode modoActual, Widget? _) {
        return MaterialApp.router(
          title: 'ManosSeguras',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.theme,
          darkTheme: AppTheme.darkTheme,
          themeMode: modoActual,
          // Toda la navegación vive en un único lugar.
          routerConfig: appRouter,
        );
      },
    );
  }
}
