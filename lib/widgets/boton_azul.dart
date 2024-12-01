import 'package:flutter/material.dart';

class BotonAzul extends StatelessWidget {
  final String texto;
  final VoidCallback? onPressed;

  const BotonAzul({
    required this.texto,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 2,
        shape: const StadiumBorder(),
        backgroundColor: const Color.fromARGB(255, 5, 57, 92), // Color de fondo del botón
        foregroundColor: Colors.white, // Color del texto
        minimumSize: const Size(double.infinity, 55), // Tamaño mínimo
      ),
      child: Center(
        child: Text(
          texto,
          style: const TextStyle(color: Colors.white, fontSize: 17),
        ),
      ),
    );
  }
}
