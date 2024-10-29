import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:netflix_clone/models/popular_mobvie_model.dart';
import 'package:netflix_clone/models/top_rated_model.dart';
import 'package:netflix_clone/models/tv_series_model.dart';
import 'package:netflix_clone/screens/search_screen.dart';
import 'package:netflix_clone/services/api_service.dart';
import 'package:netflix_clone/widgets/color.dart';
import 'package:netflix_clone/widgets/custom_carousel.dart';
import 'package:netflix_clone/widgets/movie_card.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  late Future<dynamic> upcomingFuture;
  late Future<dynamic> nowplayingFuture;
  late Future<TvSeriesModel> topRatedSeries;
  late Future<PopularMovieModel> popularMovie;
  late Future<TopRatedModel> topRatedMovie;
  bool isConnected = true;
  ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    checkConnectivity();
    if (isConnected) {
      initializeFutures();
    }
  }

  Future<void> checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      isConnected = connectivityResult != ConnectivityResult.none;
    });
    if (isConnected) {
      initializeFutures();
    }
  }

  void initializeFutures() {
    upcomingFuture = getFuturenow();
    nowplayingFuture = apiService.getNowPlayingMovies();
    topRatedSeries = apiService.getTopRatedSeries();
    popularMovie = apiService.getPopularMovie();
    topRatedMovie = apiService.getTopRatedMovies();
  }

  Future<dynamic> getFuturenow() async {
    try {
      return await apiService.getUpcomingMovies();
    } catch (e) {
      print('Error fetching now playing movies: $e');
      await Future.delayed(const Duration(seconds: 10));
      return await apiService.getUpcomingMovies();
    }
  }

  Widget buildFutureWidget(Future<dynamic> future, String errorMessage, Widget Function(dynamic data) buildSuccess) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || !isConnected) {
          return Center(
            child: Text(
              !isConnected ? "No Internet Connection" : errorMessage,
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
          );
        } else if (snapshot.hasData) {
          return buildSuccess(snapshot.data);
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
       appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/logo.png',
              height: 80,
              width: 120,
            ),
          ],
        ),
         actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.download),
              color: MyColor.White,
              iconSize: 25,
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.search),
              color: MyColor.White,
              iconSize: 25,
            ),
            const SizedBox(width: 20)
          ],
      ),
        body: isConnected
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    buildFutureWidget(
                      topRatedSeries,
                      "Could not load top-rated series. Check your internet connection.",
                      (data) => CustomCarousel(data: data),
                    ),
                    const SizedBox(height: 20),
                    buildFutureWidget(
                      nowplayingFuture,
                      "Could not load now-playing movies. Check your internet connection.",
                      (data) => SizedBox(
                        height: 220,
                        child: MovieCard(
                          future: nowplayingFuture,
                          headLineText: "Now Playing Movies",
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    buildFutureWidget(
                      upcomingFuture,
                      "Could not load upcoming movies. Check your internet connection.",
                      (data) => SizedBox(
                        height: 220,
                        child: MovieCard(
                          future: upcomingFuture,
                          headLineText: "Upcoming Movies",
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    buildFutureWidget(
                      popularMovie,
                      "Could not load popular movies. Check your internet connection.",
                      (data) => SizedBox(
                        height: 220,
                        child: MovieCard(
                          future: popularMovie,
                          headLineText: "Popular Movies",
                        ),
                      ),
                    ),
                    buildFutureWidget(
                      topRatedMovie,
                      "Could not load top-rated movies. Check your internet connection.",
                      (data) => SizedBox(
                        height: 220,
                        child: MovieCard(
                          future: topRatedMovie,
                          headLineText: "Top Rated Movies",
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      "No Internet Connection",
                      style: TextStyle(fontSize: 18, color: Colors.red),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
