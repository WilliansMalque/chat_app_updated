import 'package:chat_app_updated/models/usuario.dart';
import 'package:chat_app_updated/services/auth_service.dart';
import 'package:chat_app_updated/services/chat_service.dart';
import 'package:chat_app_updated/services/socket_service.dart';
import 'package:chat_app_updated/services/usuarios_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UsuariosPage extends StatefulWidget {
  @override
  _UsuariosPageState createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  final UsuariosService usuarioService = UsuariosService();

  List<Usuario> usuarios = [];

  @override
  void initState() {
    super.initState();
    _cargarUsuarios();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
    final usuario = authService.usuario;

    return Scaffold(
      appBar: _buildAppBar(usuario, socketService),
      body: Container(
        color: const Color.fromARGB(255, 30, 30, 30), // Fondo oscuro
        child: SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          onRefresh: _cargarUsuarios,
          header: WaterDropHeader(
            complete: Icon(Icons.check, color: Colors.white), // Ícono blanco
            waterDropColor: Colors.grey, // Color del efecto de "WaterDrop"
          ),
          child: _listViewUsuarios(),
        ),
      ),
    );
  }

  AppBar _buildAppBar(Usuario usuario, SocketService socketService) {
    return AppBar(
      title: Text(
        usuario.nombre,
        style: TextStyle(color: Colors.white), // Texto blanco
      ),
      elevation: 1,
      backgroundColor: const Color.fromARGB(255, 49, 50, 78), // Fondo del AppBar
      leading: IconButton(
        icon: Icon(Icons.exit_to_app, color: Colors.white), // Ícono blanco
        onPressed: () {
          socketService.disconnect();
          Navigator.pushReplacementNamed(context, 'login');
          AuthService.deleteToken();
        },
      ),
      actions: <Widget>[
        Container(
          margin: EdgeInsets.only(right: 10),
          child: socketService.serverStatus == ServerStatus.Online
              ? Icon(Icons.check_circle, color: Colors.green) // Indicador verde
              : Icon(Icons.offline_bolt, color: Colors.red), // Indicador rojo
        ),
      ],
    );
  }

  ListView _listViewUsuarios() {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemBuilder: (_, i) => _usuarioListTile(usuarios[i]),
      separatorBuilder: (_, __) => Divider(color: Colors.grey), // Separador gris
      itemCount: usuarios.length,
    );
  }

  ListTile _usuarioListTile(Usuario usuario) {
    return ListTile(
      title: Text(
        usuario.nombre,
        style: TextStyle(color: Colors.white), // Texto blanco
      ),
      subtitle: Text(
        usuario.email,
        style: TextStyle(color: Colors.grey), // Texto gris claro
      ),
      leading: CircleAvatar(
        backgroundColor: Colors.blue[300],
        child: Text(
          usuario.nombre.substring(0, 2),
          style: TextStyle(color: Colors.white), // Texto blanco
        ),
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: usuario.online ? Colors.green : Colors.red, // Indicador de estado
          borderRadius: BorderRadius.circular(100),
        ),
      ),
      onTap: () {
        final chatService = Provider.of<ChatService>(context, listen: false);
        chatService.usuarioPara = usuario;
        Navigator.pushNamed(context, 'chat');
      },
    );
  }

  Future<void> _cargarUsuarios() async {
    try {
      final usuariosCargados = await usuarioService.getUsuarios();
      setState(() {
        usuarios = usuariosCargados;
      });
    } catch (e) {
      print('Error al cargar usuarios: $e');
    } finally {
      _refreshController.refreshCompleted();
    }
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }
}
