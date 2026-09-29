# ManosSeguras

## Resolución del Grupo 05

Aplicación desarrollada en Flutter para la **Guía de Aplicación N.° 05** del curso Desarrollo de Software II.

El proyecto implementa navegación con `go_router`, programación asíncrona con `Future` y consumo de una API REST pública de la OMS para mostrar indicadores de higiene de manos del Perú.

### Funcionalidades

- Navegación declarativa y rutas con parámetros.
- Consulta de datos mediante el paquete `http`.
- Conversión defensiva de JSON con `fromJson`.
- Estados de carga, error, lista vacía y datos disponibles.
- Lista de indicadores con filtro desde el año 2015.
- Pantalla de detalle para cada año.
- Consultas en paralelo con `Future.wait`.
- Pruebas automatizadas con `MockClient`.

### Ejecución

```bash
flutter pub get
flutter run -d windows
```

### Verificación

```bash
flutter analyze
flutter test
```

Resultados obtenidos:

```text
No issues found!
All tests passed!
```

### Tecnologías

`Flutter` · `Dart` · `go_router` · `http` · `FutureBuilder` · `MockClient`

---

**Grupo 05 — Desarrollo de Software II**
