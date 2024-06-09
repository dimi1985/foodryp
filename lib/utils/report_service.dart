import 'dart:convert';
import 'package:foodryp/models/report.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/user_service.dart';
import 'package:http/http.dart' as http;

class ReportService {
  static Future<bool> reportComment(String commentId, String reason) async {
    try {
      String reporterId = await UserService().getCurrentUserId();

      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/api/createReport'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'commentId': commentId,
          'reason': reason,
          'reporterId': reporterId,
        }),
      );

      if (response.statusCode == 201) {
        // Report submitted successfully
        return true;
      } else {
        // Handle other status codes
        return false;
      }
    } catch (e) {
      // Handle exceptions
      return false;
    }
  }

  static Future<bool> deleteReport(String reportId) async {
  try {
    final response = await http.delete(
      Uri.parse('${Constants.baseUrl}/api/deleteReport/$reportId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      // Report deleted successfully
      return true;
    } else {
      // Handle other status codes
      return false;
    }
  } catch (e) {
    // Handle exceptions
    return false;
  }
}

 static Future<List<Report>> fetchAllReports() async {
    try {
      final response = await http.get(Uri.parse('${Constants.baseUrl}/api/getAllReports'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        // Convert the dynamic list to a list of Report objects
        List<Report> reports = data.map((report) => Report.fromJson(report)).toList();
        return reports;
      } else {
        throw Exception('Failed to fetch reports');
      }
    } catch (e) {
      throw Exception('Failed to fetch reports: $e');
    }
  }

}
