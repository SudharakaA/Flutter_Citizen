import 'dart:convert';
import 'package:http/http.dart' as http;

import '../sector.dart';

class SectorService {
  static const String baseUrl =
      "http://220.247.224.226:8401/CCSHubApi/api/MainApi/SectorListRequested"; // <-- replace with real API base URL

  /// Fetches the list of sectors from API using the provided bearer token
  static Future<List<Sector>> getSectors(String bearerToken) async {
    try {
      final response = await http.get(
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
          return data.map((json) => Sector.fromJson(json)).toList();
        } else {
          throw Exception(
              "API request failed: ${jsonResponse['errorMessage'] ?? 'Unknown error'}");
        }
      } else {
        throw Exception(
            "Failed to load sectors. Status: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching sectors: $e");
    }
  }
}
