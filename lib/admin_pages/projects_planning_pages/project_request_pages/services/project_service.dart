import 'dart:convert';
import 'package:http/http.dart' as http;

class ProjectService {
  static const String baseUrl =
      'http://220.247.224.226:8401/CCSHubApi/api/MainApi/NewPlanAdded'; // Replace with your actual API base URL

  static Future<Map<String, dynamic>> submitProject({
    required String accessToken,
    required String dsLocationId,
    required String gnLocationId,
    required String sectorLocationId,
    required String projectType,
    required String planPriority,
    required String projectTitle,
    required String estimatedCost,
    required String estimatedOutput,
    required String planDescription,
    required String username,
    required String callingName,
    required List<String> sgdGoalList,
  }) async {
    try {
      final url = Uri.parse(baseUrl); // Replace with your actual endpoint

      final requestBody = {
        "DS_LOCATION_ID": dsLocationId,
        "GN_LOCATION_ID": gnLocationId,
        "SECTOR_LOCATION_ID": sectorLocationId,
        "PROJECT_TYPE": projectType,
        "PLAN_PRIORITY": planPriority,
        "PROJECT_TITLE": projectTitle,
        "ESTIMATED_COST": estimatedCost,
        "ESTIMATED_OUTPUT": estimatedOutput,
        "PLAN_DESCRIPTION": planDescription,
        "CURRENT_STATUS": "Proposal Submitted",
        "USERNAME": username,
        "CALLINGNAME": callingName,
        "sgdGoalList": sgdGoalList,
      };

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        return responseData;
      } else {
        throw Exception(
            'Failed to submit project: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error submitting project: $e');
    }
  }
}
