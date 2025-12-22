// Project Delete Service Class
import 'dart:convert';

import 'package:http/http.dart' as http;

class ProjectDeleteService {
  static Future<Map<String, dynamic>> deleteProject({
    required String accessToken,
    required String username,
    required String callingName,
    required dynamic basicDataId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(
            'http://220.247.224.226:8401/CCSHubApi/api/MainApi/PlanItemDeleted'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'username': username,
          'callingName': callingName,
          'basicDataId': basicDataId,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'isSuccess': false,
          'errorMessage':
              'Failed to connect to server. Status code: ${response.statusCode}'
        };
      }
    } catch (e) {
      return {
        'isSuccess': false,
        'errorMessage': 'Network error: ${e.toString()}'
      };
    }
  }
}
