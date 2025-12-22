import 'dart:convert';
import 'package:http/http.dart' as http;

import '../location.dart';

class LocationService {
  static const String baseUrl =
      "http://220.247.224.226:8401/CCSHubApi/api/MainApi/PrivilegedLocationsRequested?username=901920664V&viewName=proposalsubmission"; // <-- replace with real API base URL

  /// Fetches the list of locations from API using the provided bearer token
  static Future<List<Location>> getLocations(String bearerToken) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $bearerToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        if (jsonResponse['isSuccess'] == true) {
          final List<dynamic> data = jsonResponse['dataBundle'];
          return data.map((json) => Location.fromJson(json)).toList();
        } else {
          throw Exception(
              "API request failed: ${jsonResponse['errorMessage'] ?? 'Unknown error'}");
        }
      } else {
        throw Exception(
            "Failed to load locations. Status: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching locations: $e");
    }
  }
}
