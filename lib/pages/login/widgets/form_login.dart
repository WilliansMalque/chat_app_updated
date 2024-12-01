import 'package:chat_app_updated/helpers/mostrar_alerta.dart';
import 'package:chat_app_updated/services/auth_service.dart';
import 'package:chat_app_updated/services/socket_service.dart';
import 'package:chat_app_updated/widgets/boton_azul.dart';
import 'package:chat_app_updated/widgets/custom_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FormLogin extends StatefulWidget {
  @override
  _FormLoginState createState() => _FormLoginState();
}

class _FormLoginState extends State<FormLogin> {
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 40),
          padding: EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            children: <Widget>[
              CustomInput(
                icon: Icons.mail_outline,
                placeHolder: 'Correo',
                keyboardType: TextInputType.emailAddress,
                textController: emailCtrl,
              ),
              CustomInput(
                icon: Icons.lock_outline,
                placeHolder: 'Contraseña',
                textController: passCtrl,
                isPassword: true,
              ),
              BotonAzul(
                texto: 'Ingresa',
                onPressed: authService.autenticando
                    ? null
                    : () async {
                        FocusScope.of(context).unfocus();

                        final email = emailCtrl.text.trim();
                        final password = passCtrl.text.trim();

                        if (email.isEmpty || password.isEmpty) {
                          mostrarAlerta(context, 'Error', 'Todos los campos son obligatorios');
                          return;
                        }

                        final loginOk = await authService.login(email, password);

                        if (loginOk) {
                          socketService.connect();
                          Navigator.pushReplacementNamed(context, 'usuarios');
                        } else {
                          mostrarAlerta(
                            context,
                            'Login incorrecto',
                            'Revise sus credenciales nuevamente',
                          );
                        }
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }
}