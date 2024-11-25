import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'detail_movie_screen.dart';
import 'home_screen.dart';
import 'conversion_screen.dart';
import 'suggestions_screen.dart';
import 'profile_screen.dart';

class FavoriteScreen extends StatefulWidget {
  final String userId;

  FavoriteScreen({required this.userId});

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<dynamic> favoriteMovies = [];

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final box = Hive.box('favorites');
    setState(() {
      favoriteMovies = box.keys
          .where((key) => key.toString().startsWith('${widget.userId}_'))
          .map((key) => box.get(key))
          .toList();
    });
  }

  void removeFavorite(String movieKey) {
    final box = Hive.box('favorites');
    box.delete(movieKey);
    loadFavorites();
  }

  void navigateToScreen(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
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
      currentIndex: 1,
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
            navigateToScreen(HomeScreen(userId: widget.userId));
            break;
          case 1:
            break;
          case 2:
            navigateToScreen(ConversionScreen(userId: widget.userId));
            break;
          case 3:
            navigateToScreen(SuggestionsScreen(userId: widget.userId));
            break;
          case 4:
            navigateToScreen(ProfileScreen(userId: widget.userId));
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
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'Favorites',
          style: TextStyle(
            color: Colors.red,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: favoriteMovies.isEmpty
          ? Center(
              child: Text(
                'Belum ada favorit',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: favoriteMovies.length,
              itemBuilder: (context, index) {
                final movie = favoriteMovies[index];
                final movieKey = '${widget.userId}_${movie['title']}';

                return Container(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black54,
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    title: Text(
                      movie['title'] ?? 'No Title',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    leading: movie['poster_path'] != null &&
                            movie['poster_path'].isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                              width: 50,
                              fit: BoxFit.cover,
                            ),
                          )
                        : null,
                    trailing: IconButton(
                      icon: Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () {
                        removeFavorite(movieKey);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${movie['title']} removed')),
                        );
                      },
                    ),
                    onTap: () async {
                      try {
                        final title = movie['title'] ?? 'Unknown Title';
                        final posterPath = movie['poster_path'] ?? '';
                        final backdropPath = movie['backdrop_path'] ?? '';
                        final rating = (movie['rating'] ?? 0).toDouble();
                        final overview = movie['overview'] ?? '';
                        final releaseDate = movie['release_date'] ?? 'N/A';
                        final genre =
                            (movie['genre'] != null && movie['genre'] is List)
                                ? (movie['genre'] as List).join(', ')
                                : movie['genre'] ?? 'N/A';
                        final duration = movie['duration'] ?? 'N/A';
                        final language = movie['language'] ?? 'N/A';
                        final cast =
                            (movie['cast'] != null && movie['cast'] is List)
                                ? (movie['cast'] as List).join(', ')
                                : movie['cast'] ?? 'N/A';
                        final director = movie['director'] ?? 'N/A';

                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailMovieScreen(
                              title: title,
                              posterPath:
                                  posterPath.isNotEmpty ? posterPath : null,
                              backdropPath:
                                  backdropPath.isNotEmpty ? backdropPath : null,
                              rating: rating,
                              overview: overview,
                              userId: widget.userId,
                              releaseDate: releaseDate,
                              genre: genre,
                              duration: duration,
                              language: language,
                              cast: cast,
                              director: director,
                            ),
                          ),
                        );

                        loadFavorites();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Error opening movie details')),
                        );
                      }
                    },
                  ),
                );
              },
            ),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }
}
