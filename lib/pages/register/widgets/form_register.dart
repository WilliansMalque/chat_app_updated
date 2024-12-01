import 'package:chat_app_updated/helpers/mostrar_alerta.dart';
import 'package:chat_app_updated/services/auth_service.dart';
import 'package:chat_app_updated/services/socket_service.dart';
import 'package:chat_app_updated/widgets/boton_azul.dart';
import 'package:chat_app_updated/widgets/custom_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FormRegister extends StatefulWidget {
  @override
  _FormRegisterState createState() => _FormRegisterState();
}

class _FormRegisterState extends State<FormRegister> {
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(top: 40),
        padding: EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          children: <Widget>[
            CustomInput(
              icon: Icons.perm_identity,
              placeHolder: 'Nombre',
              keyboardType: TextInputType.text,
              textController: nameCtrl,
            ),
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
              texto: 'Crear cuenta',
              onPressed: authService.autenticando
                  ? null
                  : () async {
                      FocusScope.of(context).unfocus();

                      final name = nameCtrl.text.trim();
                      final email = emailCtrl.text.trim();
                      final password = passCtrl.text.trim();

                      if (name.isEmpty || email.isEmpty || password.isEmpty) {
                        mostrarAlerta(context, 'Error', 'Todos los campos son obligatorios');
                        return;
                      }

                      final registerOk = await authService.register(name, email, password);

                      if (registerOk == true) {
                        socketService.connect();
                        Navigator.pushReplacementNamed(context, 'usuarios');
                      } else {
                        mostrarAlerta(context, 'Registro incorrecto', registerOk);
                      }
                    },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Liberar recursos
    nameCtrl.dispose();
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }
}
