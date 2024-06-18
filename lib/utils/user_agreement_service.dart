import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/user_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserAgreementService {
  UserAgreementService();

  Future<void> saveUserAgreement(
      String agreementVersion, String agreementText) async {
    String userId = await UserService().getCurrentUserId();

    final url = Uri.parse('${Constants.baseUrl}/api/saveAgreement');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'userId': userId,
        'agreementVersion': agreementVersion,
        'agreementText': agreementText,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to save agreement');
    }
  }
}
