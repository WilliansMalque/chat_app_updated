
import 'package:chat_app_updated/pages/chat/chat_page.dart';
import 'package:chat_app_updated/pages/loading/loading_page.dart';
import 'package:chat_app_updated/pages/login/login_page.dart';
import 'package:chat_app_updated/pages/register/register_page.dart';
import 'package:chat_app_updated/pages/usuarios/usuarios_page.dart';
import 'package:flutter/material.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  'usuarios': (_) => UsuariosPage(),
  'chat': (_) => ChatPage(),
  'login': (_) => LoginPage(),
  'register': (_) => RegisterPage(),
  'loading': (_) => LoadingPage(),
};

// Map<String, WidgetBuilder> getApplicationRoutes() {
//   return <String, WidgetBuilder>{
//     'usuarios': (_) => UsuariosPage(),
//     'chat': (_) => ChatPage(),
//     'login': (_) => LoginPage(),
//     'register': (_) => RegisterPage(),
//     'loading': (_) => LoadingPage(),
//   };
// }
