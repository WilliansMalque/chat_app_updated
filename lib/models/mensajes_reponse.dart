import 'dart:convert';

MensajesResponse mensajesResponseFromJson(String str) =>
    MensajesResponse.fromJson(json.decode(str));

String mensajesResponseToJson(MensajesResponse data) =>
    json.encode(data.toJson());

class MensajesResponse {
  MensajesResponse({
    required this.ok,
    required this.mensajes,
    required this.miId,
    required this.mensajesDe,
  });

  final bool ok;
  final List<Mensaje> mensajes;
  final String miId;
  final String mensajesDe;

  factory MensajesResponse.fromJson(Map<String, dynamic> json) {
    return MensajesResponse(
      ok: json["ok"] ?? false,
      mensajes: (json["mensajes"] as List<dynamic>?)
              ?.map((x) => Mensaje.fromJson(x))
              .toList() ??
          [],
      miId: json["miId"] ?? '',
      mensajesDe: json["mensajesDe"] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "mensajes": mensajes.map((x) => x.toJson()).toList(),
        "miId": miId,
        "mensajesDe": mensajesDe,
      };
}

class Mensaje {
  Mensaje({
    required this.de,
    required this.para,
    required this.mensaje,
    required this.createdAt,
    required this.updatedAt,
  });

  final String de;
  final String para;
  final String mensaje;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory Mensaje.fromJson(Map<String, dynamic> json) {
    return Mensaje(
      de: json["de"] ?? '',
      para: json["para"] ?? '',
      mensaje: json["mensaje"] ?? '',
      createdAt: DateTime.tryParse(json["createdAt"] ?? '') ?? DateTime(1970),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? '') ?? DateTime(1970),
    );
  }

  Map<String, dynamic> toJson() => {
        "de": de,
        "para": para,
        "mensaje": mensaje,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
