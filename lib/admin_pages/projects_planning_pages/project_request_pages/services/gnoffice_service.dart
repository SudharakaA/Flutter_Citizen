import 'dart:convert';
import 'package:http/http.dart' as http;

import '../gnoffice.dart';

class GnofficeService {
  static const String baseUrl =
      "http://220.247.224.226:8401/CCSHubApi/api/MainApi/GNOfficeListRequested?"; // <-- replace with real API base URL

  /// Fetches the list of Gn Offices from API using the provided bearer token
  static Future<List<Gnoffice>> getGnOffices(
      String bearerToken, String divisionId) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}dsDivisionId=$divisionId'),
        headers: {
          'Authorization': 'Bearer $bearerToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        if (jsonResponse['isSuccess'] == true) {
          final List<dynamic> data = jsonResponse['dataBundle'];
          return data.map((json) => Gnoffice.fromJson(json)).toList();
        } else {
          throw Exception(
              "API request failed: ${jsonResponse['errorMessage'] ?? 'Unknown error'}");
        }
      } else {
        throw Exception(
            "Failed to load Gn Offices. Status: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching Gn Offices: $e");
    }
  }
}
