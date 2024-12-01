import 'dart:io';

class Environment {
  static String apiUrl = Platform.isAndroid
      ? 'http://18.189.44.64:3000/api/'  // Elastic IP para Android
      : 'http://18.189.44.64:3000/api/'; // Elastic IP para desarrollo en web o escritorio

  static String socketUrl = Platform.isAndroid
      ? 'http://18.189.44.64:3000'       // Elastic IP para Android
      : 'http://18.189.44.64:3000';      // Elastic IP para desarrollo en web o escritorio
}
