import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/subject_officer_request_model.dart';

class SubjectOfficerService {
  static const String baseUrl = 'http://220.247.224.226:8401/CCSHubApi/api/MainApi';

  /// Fetch subject officer requested types
  /// 
  /// Parameters:
  /// - [username]: The username/NIC (e.g., '901920664V')
  /// - [privilegeConfigurationId]: The privilege configuration ID (e.g., 7)
  /// - [accessToken]: Access token for authentication (required)
  static Future<List<SubjectOfficerRequest>> getSubjectOfficerRequestTypesRequested({
    required String username,
    required int privilegeConfigurationId,
    required String accessToken,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/SubjectOfficerRequestTypesRequested').replace(
        queryParameters: {
          'username': username,
          'privilegeConfigurationId': privilegeConfigurationId.toString(),
        },
      );

      final headers = <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      print('=== API Request Debug ===');
      print('URL: $uri');
      print('Token (first 20 chars): ${accessToken.length > 20 ? accessToken.substring(0, 20) + "..." : accessToken}');
      print('Username: $username');
      print('PrivilegeConfigId: $privilegeConfigurationId');

      final response = await http.get(uri, headers: headers);

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        
        // Check if the response has the expected structure
        if (responseData is Map && responseData.containsKey('isSuccess')) {
          if (responseData['isSuccess'] == true && responseData['dataBundle'] != null) {
            final List<dynamic> jsonData = responseData['dataBundle'] is List 
                ? responseData['dataBundle'] 
                : [];
            return jsonData.map((json) => SubjectOfficerRequest.fromJson(json)).toList();
          } else {
            throw Exception('API Error: ${responseData['errorMessage'] ?? 'Unknown error'}');
          }
        } else if (responseData is List) {
          return responseData.map((json) => SubjectOfficerRequest.fromJson(json)).toList();
        }
        
        return [];
      } else if (response.statusCode == 401) {
        final errorData = json.decode(response.body);
        throw Exception('Authentication failed: ${errorData['errorMessage'] ?? 'Invalid or expired token'}');
      } else {
        throw Exception('Failed to load data: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('=== API Error ===');
      print('Error: $e');
      throw Exception('Error fetching subject officer requests: $e');
    }
  }
}
