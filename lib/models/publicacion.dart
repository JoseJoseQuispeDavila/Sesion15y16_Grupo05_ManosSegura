class Publicacion {
  final int userId;
  final int id;
  final String titulo;
  final String cuerpo;

  const Publicacion({
    required this.userId,
    required this.id,
    required this.titulo,
    required this.cuerpo,
  });

  factory Publicacion.fromJson(Map<String, dynamic> json) {
    return Publicacion(
      userId: _aEntero(json['userId']),
      id: _aEntero(json['id']),
      titulo: json['title'] as String? ?? 'Sin título',
      cuerpo: json['body'] as String? ?? 'Sin contenido',
    );
  }

  static int _aEntero(dynamic valor) {
    if (valor is int) return valor;
    if (valor is num) return valor.toInt();
    if (valor is String) return int.tryParse(valor) ?? 0;
    return 0;
  }
}
