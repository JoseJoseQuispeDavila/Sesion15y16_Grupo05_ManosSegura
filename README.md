# ManosSeguras — Solución de referencia de las Sesiones 15 y 16

Proyecto Flutter de **SIS048 – Desarrollo de Software II** (Universidad Andina
del Cusco, 2026-II) que implementa el contenido teórico **1.4. Navegación,
Asincronía y Consumo de APIs**:

| Temática | Sesión | Qué se implementa aquí |
|---|---|---|
| 1.4.1 Navigator / go_router, Future y async/await | 15 | Toda la navegación migrada a `go_router` (`lib/router/app_router.dart`), incluida una ruta con parámetro (`/indicadores/:anio`), `errorBuilder` y estados asíncronos con `FutureBuilder`. |
| 1.4.2 Conexión API con el paquete `http` | 16 | Consumo del API REST público del Observatorio Mundial de la Salud (OMS), modelo con `fromJson`, servicio con manejo de errores y lista renderizada con `ListView.builder`. |

Complementa a la guía `Sesion15-16_Navegacion_Asincronia_ConsumoAPIs.docx`,
que explica paso a paso cómo llegar a este código.

## Servicio consumido

```
GET https://ghoapi.azureedge.net/api/WSH_HYGIENE_BASIC?$filter=SpatialDim eq 'PER'
```

Indicador `WSH_HYGIENE_BASIC` — *Población con instalaciones básicas de lavado
de manos en el hogar (%)*. No requiere API key. Al momento de elaborar la guía
devuelve **16 registros** (2009–2024) y el valor pasa de 47,0 % a 72,3 %.

> Nota: ese servicio **no envía cabeceras CORS**, por lo que debe ejecutarse en
> Android, iOS, Windows, Linux o macOS (no en Flutter Web). Para la variante Web
> la guía propone en su Anexo B servicios alternativos que sí las envían
> (JSONPlaceholder, DummyJSON, Open-Meteo, Banco Mundial).

## Qué agrega respecto del proyecto de las sesiones anteriores

| Archivo | Contenido |
|---|---|
| `lib/router/app_router.dart` | Todas las rutas del aplicativo, la ruta hija `/indicadores/:anio` y `PantallaRutaInvalida` como respaldo. |
| `lib/models/indicador_higiene.dart` | Modelo de dominio con `factory fromJson` defensivo y campo `valor` nullable. |
| `lib/services/higiene_api_service.dart` | Petición `http` con `timeout`, verificación de `statusCode`, `utf8.decode`, orden por año y traducción de errores a `ApiException`. |
| `lib/datos/datos_respaldo.dart` | 16 registros reales capturados del API, como **plan B sin Internet** (`HigieneApiService(usarRespaldoLocal: true)`). |
| `lib/widgets/estados_vista.dart` | `EstadoCarga`, `EstadoError` (con reintento) y `EstadoVacio`. |
| `lib/widgets/tarjeta_indicador.dart` | Tarjeta reutilizable de un registro anual, con `LinearProgressIndicator`. |
| `lib/screens/pantalla_indicadores.dart` | `FutureBuilder` con los tres estados, `RefreshIndicator` y navegación al detalle con `context.push`. |
| `lib/screens/pantalla_indicador_detalle.dart` | Detalle por parámetro de ruta, con `state.extra` y consulta propia si se abre por URL. |
| `lib/main.dart` | `MaterialApp.router` con `routerConfig: appRouter`, conservando el `ValueListenableBuilder` del tema (Sesión 11). |
| `test/indicador_higiene_test.dart` | 11 pruebas de la capa de datos con `MockClient` (sin Internet). |
| `test/pantalla_indicadores_test.dart` | Pruebas de widget de la lista y del estado de error, con el servicio inyectado. |

Todo el código de las sesiones anteriores (modelos, tema, `AppLayout`,
`TarjetaBase`, `IndicadorEstado`, `EtiquetasMomentos`) se conserva y se
reutiliza; los tres botones de navegación existentes se migraron de
`Navigator.of(context).push(MaterialPageRoute(...))` a `context.go('/ruta')`.

## Cómo ejecutarlo

```bash
flutter --version      # verificado con Flutter 3.41.1 / Dart 3.11.0
flutter pub get
flutter run
```

Dependencias añadidas: `go_router: ^17.5.0` y `http: ^1.5.0`.
Si su SDK es Flutter **3.44 o superior**, puede subir `go_router` a `^18.0.1`;
si es **anterior a 3.38**, use `go_router: ^16.3.0`.

## Cómo verificarlo

```bash
flutter analyze        # sin hallazgos
flutter test           # pruebas de datos y de widget
```

Las pruebas de la capa de datos usan `MockClient`, por lo que **no requieren
conexión a Internet**. Para trabajar sin red en toda la aplicación, cambie en
`lib/services/higiene_api_service.dart` (o en la pantalla) el uso del servicio
por `HigieneApiService(usarRespaldoLocal: true)`.

## Flujo de navegación resultante

```
/                      PantallaBienvenida
/establecimiento       PantallaEstablecimiento
/personal              PantallaPersonal
/oportunidades         PantallaOportunidades
/indicadores           PantallaIndicadores        ← lista desde el API (OMS)
/indicadores/:anio     PantallaIndicadorDetalle   ← detalle por año
```

## Nota para el docente

Este proyecto es la **solución de referencia**: se distribuye después de la
sesión de laboratorio, no antes. Los estudiantes parten del proyecto de las
sesiones anteriores (sin `go_router`, sin `http` y sin las pantallas de
indicadores) y construyen estas piezas siguiendo los pasos 0 a 12 de la guía.
