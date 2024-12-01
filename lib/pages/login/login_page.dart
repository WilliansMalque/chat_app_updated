import 'package:flutter/material.dart';

import 'package:chat_app_updated/pages/login/widgets/form_login.dart';
import 'package:chat_app_updated/widgets/labels.dart';
import 'package:chat_app_updated/widgets/logo.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 153, 162, 180), // Fondo blanco
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.85,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Logo(
                  titulo: 'Sense-Sport-chat', // Título actualizado
                ),
                FormLogin(),
                Labels(
                  ruta: 'register',
                  texto1: '¿No tienes cuenta?',
                  texto2: 'Crea una ahora!',
                ),
                Text(
                  'Términos y condiciones de uso',
                  style: TextStyle(
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
