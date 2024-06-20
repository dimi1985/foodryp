import 'package:foodryp/utils/contants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ServerMonitorService {
  Future<Map<String, dynamic>> getServerStatus() async {
    final response = await http.get(Uri.parse('${Constants.baseUrl}/api/serverStatus'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load server status');
    }
  }

  Future<Map<String, dynamic>> getDatabaseStatus() async {
    final response = await http.get(Uri.parse('${Constants.baseUrl}/api/databaseStatus'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load database status');
    }
  }

  Future<List<dynamic>> getBackupStatus() async {
    final response = await http.get(Uri.parse('${Constants.baseUrl}/api/backupStatus'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load backup status');
    }
  }
}
