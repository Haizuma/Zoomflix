import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class DetailMovieScreen extends StatelessWidget {
  final String title;
  final String? posterPath;
  final String? backdropPath;
  final double rating;
  final String overview;
  final String userId;
  final String releaseDate;
  final String genre;
  final String duration;
  final String language;
  final String cast;
  final String director;

  DetailMovieScreen({
    required this.title,
    this.posterPath,
    this.backdropPath,
    required this.rating,
    required this.overview,
    required this.userId,
    required this.releaseDate,
    required this.genre,
    required this.duration,
    required this.language,
    required this.cast,
    required this.director,
  });

  void toggleFavorite(BuildContext context) {
    final box = Hive.box('favorites');
    final movieKey = '${userId}_$title';

    if (box.containsKey(movieKey)) {
      box.delete(movieKey);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$title removed from favorites')),
      );
    } else {
      box.put(movieKey, {
        'poster_path': posterPath ?? '',
        'backdrop_path': backdropPath ?? '',
        'rating': rating,
        'overview': overview,
        'title': title,
        'release_date': releaseDate,
        'genre': genre,
        'duration': duration,
        'language': language,
        'cast': cast,
        'director': director,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$title added to favorites')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('favorites');
    final movieKey = '${userId}_$title';
    bool isFavorite = box.containsKey(movieKey);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.white,
            ),
            onPressed: () {
              toggleFavorite(context);
              (context as Element).markNeedsBuild();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (backdropPath != null)
              Stack(
                children: [
                  Image.network(
                    'https://image.tmdb.org/t/p/w500$backdropPath',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 220,
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.8),
                            Colors.transparent
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Row(
                children: [
                  if (posterPath != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        'https://image.tmdb.org/t/p/w500$posterPath',
                        width: 100,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.star,
                                color: Colors.yellow[600], size: 18),
                            SizedBox(width: 5),
                            Text(
                              '$rating',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          '$genre · $duration · $releaseDate',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Language: $language',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(color: Colors.white24),
                  SizedBox(height: 16),
                  Text(
                    'Overview',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    overview,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 16),
                  Divider(color: Colors.white24),
                  SizedBox(height: 16),
                  Text(
                    'Cast',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    cast,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Director',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    director,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
