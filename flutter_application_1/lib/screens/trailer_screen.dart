import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class TrailerScreen extends StatefulWidget {
  final String userId;

  TrailerScreen({required this.userId});

  @override
  _TrailerScreenState createState() => _TrailerScreenState();
}

class _TrailerScreenState extends State<TrailerScreen> {
  List<dynamic> popularMovies = [];
  List<dynamic> searchResults = [];
  bool isLoading = true;
  bool isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchPopularMovies();
  }

  Future<void> fetchPopularMovies() async {
    const String apiKey = '998adf42c8c7773fab52b88ac01838c7';

    try {
      final response = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/movie/popular?api_key=$apiKey'));

      if (response.statusCode == 200) {
        setState(() {
          popularMovies = json.decode(response.body)['results'] ?? [];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch popular movies');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching popular movies: $e');
    }
  }

  Future<void> searchMovies(String query) async {
    const String apiKey = '998adf42c8c7773fab52b88ac01838c7';

    try {
      final response = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/search/movie?api_key=$apiKey&query=$query'));

      if (response.statusCode == 200) {
        setState(() {
          searchResults = json.decode(response.body)['results'] ?? [];
          isSearching = true;
        });
      } else {
        throw Exception('Failed to search movies');
      }
    } catch (e) {
      print('Error searching movies: $e');
    }
  }

  Future<void> showTrailer(dynamic movie) async {
    const String apiKey = '998adf42c8c7773fab52b88ac01838c7';
    int movieId = movie['id'];

    try {
      final response = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/movie/$movieId/videos?api_key=$apiKey'));

      if (response.statusCode == 200) {
        final trailers = (json.decode(response.body)['results'] as List)
            .where((video) =>
                video['type'] == 'Trailer' && video['site'] == 'YouTube')
            .toList();

        if (trailers.isNotEmpty) {
          final trailerKey = trailers[0]['key'];
          final trailerUrl = 'https://www.youtube.com/watch?v=$trailerKey';

          if (await canLaunch(trailerUrl)) {
            await launch(trailerUrl);
          } else {
            throw 'Could not launch $trailerUrl';
          }
        } else {
          showErrorSnackbar('No trailers available for this movie');
        }
      } else {
        throw Exception('Failed to fetch trailer');
      }
    } catch (e) {
      showErrorSnackbar('Error fetching trailer: $e');
    }
  }

  void showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget buildPopularMovies(List<dynamic> movies) {
    return Column(
      children: movies.map((movie) {
        return GestureDetector(
          onTap: () => showTrailer(movie),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    movie['poster_path'] != null
                        ? 'https://image.tmdb.org/t/p/w500${movie['poster_path']}'
                        : 'https://via.placeholder.com/150',
                    height: 100,
                    width: 70,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    movie['title'] ?? 'Unknown Title',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget buildSearchField() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search Movies...',
          filled: true,
          fillColor: Colors.white10,
          prefixIcon: const Icon(Icons.search, color: Colors.red),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
        style: const TextStyle(color: Colors.white),
        onChanged: (query) {
          if (query.isNotEmpty) {
            searchMovies(query);
          } else {
            setState(() {
              isSearching = false;
              searchResults = [];
            });
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: true,
        title: const Text(
          'Trailers',
          style: TextStyle(
            color: Colors.red,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.red))
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildSearchField(),
                  if (isSearching)
                    buildPopularMovies(searchResults)
                  else ...[
                    const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'Popular Movies',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    buildPopularMovies(popularMovies),
                  ],
                ],
              ),
            ),
    );
  }
}
