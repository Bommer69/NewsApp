import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/gnews_config.dart';

class GNewsService {
  Future<List<Map<String, dynamic>>> topHeadlines({
    String lang = 'vi',
    String country = 'vn',
    String? topic,
    int max = 20,
  }) async {
    final uri = Uri.parse('${GNewsConfig.baseUrl}/top-headlines').replace(
      queryParameters: {
        'token': GNewsConfig.apiKey,
        'lang': lang,
        'country': country,
        if (topic != null) 'topic': topic,
        'max': '$max',
      },
    );

    final res = await http.get(uri);
    final data = jsonDecode(res.body);
    return List<Map<String, dynamic>>.from(data['articles'] ?? []);
  }

  Future<List<Map<String, dynamic>>> search(String query) async {
    final uri = Uri.parse('${GNewsConfig.baseUrl}/search').replace(
      queryParameters: {
        'token': GNewsConfig.apiKey,
        'q': query,
        'lang': 'vi',
        'country': 'vn',
        'max': '30',
      },
    );

    final res = await http.get(uri);
    final data = jsonDecode(res.body);
    return List<Map<String, dynamic>>.from(data['articles'] ?? []);
  }
}
