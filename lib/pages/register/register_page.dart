
import 'package:flutter/material.dart';
import 'package:chat_app_updated/pages/register/widgets/form_register.dart';

import 'package:chat_app_updated/widgets/labels.dart';
import 'package:chat_app_updated/widgets/logo.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color.fromARGB(255, 153, 162, 180),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.90,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Logo(
                  titulo: 'Registrarse',
                ),
                FormRegister(),
                Labels(
                    ruta: 'login',
                    texto1: 'Ya tienes cuenta?',
                    texto2: 'Ingresa ahora!'),
                Text('Términos y condiciones de uso',
                    style: TextStyle(fontWeight: FontWeight.w200))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
