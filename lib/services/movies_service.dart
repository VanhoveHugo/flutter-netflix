import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OmdbProvider with ChangeNotifier {
  final String _apiKey = 'YOUR_API_KEY';
  final String _baseUrl = 'https://www.omdbapi.com/';

  Future<List<dynamic>> fetchByType(String type) async {
    final url = '$_baseUrl?apikey=$_apiKey&s=$type'; // Recherche par type

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['Response'] == 'True') {
          return data['Search'];
        } else {
          return [];
        }
      } else {
        return [];
      }
    } catch (error) {
      return [];
    }
  }

  Future<Map<String, dynamic>> fetchDetails(String imdbID) async {
    final url = '$_baseUrl?apikey=$_apiKey&i=$imdbID'; // Recherche par ID

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['Response'] == 'True') {
          return data;
        } else {
          return {};
        }
      } else {
        return {};
      }
    } catch (error) {
      return {};
    }
  }

  // Fonction pour récupérer les derniers films ou séries
  Future<List<dynamic>> fetchLatestReleases() async {
    final url =
        '$_baseUrl?apikey=$_apiKey&s=2024'; // Recherche par année ou tout autre critère pertinent

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['Response'] == 'True') {
          return data['Search'];
        } else {
          return [];
        }
      } else {
        return [];
      }
    } catch (error) {
      return [];
    }
  }
}
