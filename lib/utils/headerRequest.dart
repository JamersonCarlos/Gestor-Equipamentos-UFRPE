import 'package:gestor_uso_projetores_ufrpe/services/auth_service.dart';



Future<Map<String, String>> getHeaders() async {
  final token = await AuthService(baseUrl: "http://localhost:8000").getToken();
  return {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  };
}