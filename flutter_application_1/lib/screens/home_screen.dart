import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'detail_movie_screen.dart';
import 'favorite_screen.dart';
import 'conversion_screen.dart';
import 'suggestions_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userId;

  HomeScreen({required this.userId});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> popularMovies = [];
  List<dynamic> nowPlayingMovies = [];
  List<dynamic> upcomingMovies = [];
  List<dynamic> topRatedMovies = [];
  List<dynamic> searchResults = [];
  bool isLoading = true;
  bool isSearching = false;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    const String apiKey = '998adf42c8c7773fab52b88ac01838c7';

    try {
      final responses = await Future.wait([
        http.get(Uri.parse(
            'https://api.themoviedb.org/3/movie/popular?api_key=$apiKey')),
        http.get(Uri.parse(
            'https://api.themoviedb.org/3/movie/now_playing?api_key=$apiKey')),
        http.get(Uri.parse(
            'https://api.themoviedb.org/3/movie/upcoming?api_key=$apiKey')),
        http.get(Uri.parse(
            'https://api.themoviedb.org/3/movie/top_rated?api_key=$apiKey')),
      ]);

      setState(() {
        popularMovies = json.decode(responses[0].body)['results'];
        nowPlayingMovies = json.decode(responses[1].body)['results'];
        upcomingMovies = json.decode(responses[2].body)['results'];
        topRatedMovies = json.decode(responses[3].body)['results'];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        print('Error fetching movies: $e');
      });
    }
  }

  Future<void> searchMovies(String query) async {
    const String apiKey = '998adf42c8c7773fab52b88ac01838c7';

    try {
      final response = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/search/movie?api_key=$apiKey&query=$query'));

      if (response.statusCode == 200) {
        setState(() {
          searchResults = json.decode(response.body)['results'];
          isSearching = true;
        });
      }
    } catch (e) {
      print('Error searching movies: $e');
    }
  }

  Widget buildMovieList(List<dynamic> movies) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return GestureDetector(
            onTap: () => navigateToDetailMovie(movie),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              width: 120,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                      fit: BoxFit.cover,
                      height: 150,
                      width: 120,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    movie['title'] ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> navigateToDetailMovie(dynamic movie) async {
    final String apiKey = '998adf42c8c7773fab52b88ac01838c7';
    int movieId = movie['id'];

    final responseDetails = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/$movieId?api_key=$apiKey'));

    if (responseDetails.statusCode == 200) {
      final movieDetails = json.decode(responseDetails.body);

      final responseCredits = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/movie/$movieId/credits?api_key=$apiKey'));

      String cast = '';
      String director = '';

      if (responseCredits.statusCode == 200) {
        final credits = json.decode(responseCredits.body);
        cast = credits['cast'] != null
            ? credits['cast'].map((c) => c['name']).take(5).join(', ')
            : '';
        director = credits['crew'] != null
            ? credits['crew'].firstWhere((c) => c['job'] == 'Director')['name']
            : '';
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailMovieScreen(
            title: movieDetails['title'] ?? '',
            posterPath: movieDetails['poster_path'] ?? '',
            backdropPath: movieDetails['backdrop_path'] ?? '',
            rating: (movieDetails['vote_average'] ?? 0).toDouble(),
            overview: movieDetails['overview'] ?? '',
            userId: widget.userId,
            releaseDate: movieDetails['release_date'] ?? '',
            genre: (movieDetails['genres'] != null &&
                    movieDetails['genres'].isNotEmpty)
                ? movieDetails['genres'].map((g) => g['name']).join(', ')
                : '',
            duration: movieDetails['runtime'] != null
                ? '${movieDetails['runtime']} minutes'
                : '',
            language: movieDetails['original_language'] ?? '',
            cast: cast,
            director: director,
          ),
        ),
      );
    } else {
      print('Failed to load movie details');
    }
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

  Widget buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            'assets/images/logo.png',
            height: 40,
          ),
          const SizedBox(width: 10),
          const Text(
            'ZOOMFLIX',
            style: TextStyle(
              color: Colors.red,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.black,
      selectedItemColor: Colors.red,
      unselectedItemColor: Colors.white70,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_filled, size: 30),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border, size: 30),
          label: 'Favorites',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.swap_horiz, size: 30),
          label: 'Convert',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.lightbulb_outline, size: 30),
          label: 'Suggestions',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline, size: 30),
          label: 'Profile',
        ),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FavoriteScreen(userId: widget.userId)),
            );
            break;
          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ConversionScreen(userId: widget.userId)),
            );
            break;
          case 3:
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      SuggestionsScreen(userId: widget.userId)),
            );
            break;
          case 4:
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfileScreen(userId: widget.userId)),
            );
            break;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: buildTopBar(),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.red))
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildSearchField(),
                  if (isSearching)
                    buildMovieList(searchResults)
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
                    buildMovieList(popularMovies),
                    const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'Now Playing',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    buildMovieList(nowPlayingMovies),
                    const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'Upcoming Movies',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    buildMovieList(upcomingMovies),
                    const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'Top Rated Movies',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    buildMovieList(topRatedMovies),
                  ],
                ],
              ),
            ),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }
}
