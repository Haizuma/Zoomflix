import 'dart:convert';
import 'package:http/http.dart' as http;

class TMDBService {
  final String apiKey = '998adf42c8c7773fab52b88ac01838c7';
  final String baseUrl = 'https://api.themoviedb.org/3';

  Future<List<dynamic>> fetchMoviesByType(String type) async {
    final url = '$baseUrl/movie/$type?api_key=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'] as List<dynamic>;
    } else {
      throw Exception('Failed to load $type movies');
    }
  }

  Future<List<dynamic>> fetchGenres() async {
    final url = '$baseUrl/genre/movie/list?api_key=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['genres'] as List<dynamic>;
    } else {
      throw Exception('Failed to load genres');
    }
  }

  Future<Map<String, List<dynamic>>> fetchAllMovies() async {
    final urls = {
      'popular': '$baseUrl/movie/popular?api_key=$apiKey',
      'now_playing': '$baseUrl/movie/now_playing?api_key=$apiKey',
      'top_rated': '$baseUrl/movie/top_rated?api_key=$apiKey',
    };

    List<Future<http.Response>> requests =
        urls.values.map((url) => http.get(Uri.parse(url))).toList();

    List<http.Response> responses = await Future.wait(requests);

    for (var response in responses) {
      if (response.statusCode != 200) {
        throw Exception('Failed to load movies');
      }
    }

    Map<String, List<dynamic>> moviesByCategory = {};
    int index = 0;
    for (var category in urls.keys) {
      final data = json.decode(responses[index].body);
      moviesByCategory[category] = data['results'];
      index++;
    }

    return moviesByCategory;
  }

  Future<List<dynamic>> fetchMovieTrailers(int movieId) async {
    final url = '$baseUrl/movie/$movieId/videos?api_key=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final trailers = (data['results'] as List<dynamic>)
          .where((video) =>
              video['type'] == 'Trailer' && video['site'] == 'YouTube')
          .toList();
      return trailers;
    } else {
      throw Exception('Failed to load trailers');
    }
  }
}
