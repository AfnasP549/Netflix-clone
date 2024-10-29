import 'dart:convert';

import 'package:netflix_clone/common/utils.dart';
import 'package:netflix_clone/models/movie_detailed_model.dart';
import 'package:netflix_clone/models/movie_recommendation_model';
import 'package:netflix_clone/models/popular_mobvie_model.dart';
import 'package:netflix_clone/models/search_model.dart';
import 'package:netflix_clone/models/top_rated_model.dart';
import 'package:netflix_clone/models/tv_series_model.dart';
import 'package:netflix_clone/models/upcoming_model.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';

const baseUrl="https://api.themoviedb.org/3/";
var key="?api_key=$apiKey";
late String endpoint;

class ApiService{
  Future<UpcomingMovieModel> getUpcomingMovies() async{
    endpoint="movie/upcoming";
    final url="$baseUrl$endpoint$key";

    log(url);
    final response=await http.get(Uri.parse(url)).timeout(Duration(seconds: 30));

    if(response.statusCode==200){
      log("success");
    return UpcomingMovieModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to load Upcoming Movies");
  }
    //HomeScreen
   Future<UpcomingMovieModel> getNowPlayingMovies() async{
    endpoint="movie/now_playing";
    final url="$baseUrl$endpoint$key";

    log(url);
    final response=await http.get(Uri.parse(url)).timeout(Duration(seconds: 30));

    if(response.statusCode==200){
      log("success");
    return UpcomingMovieModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to load NowPlaying Movies");
  }


   Future<TopRatedModel> getTopRatedMovies() async{
    endpoint="movie/top_rated";
    final url="$baseUrl$endpoint$key";

    log(url);
    final response=await http.get(Uri.parse(url)).timeout(Duration(seconds: 30));

    if(response.statusCode==200){
      log("success");
    return TopRatedModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to load Top rated Movies");
  }



Future<TvSeriesModel> getTopRatedSeries() async{
    endpoint="tv/top_rated";
    final url="$baseUrl$endpoint$key";

    log(url);
    final response=await http.get(Uri.parse(url)).timeout(Duration(seconds: 30));

    if(response.statusCode==200){
      log("success");
    return TvSeriesModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to load Top rated Tv Series");
  }

Future<MovieRecommendationModel> getMovieRecommendation() async{
    endpoint="movie/popular";
    final url="$baseUrl$endpoint$key";

    log(url);
    final response=await http.get(Uri.parse(url)).timeout(Duration(seconds: 30));

    if(response.statusCode==200){
      log("success");
    return MovieRecommendationModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to load Movie Recommentation");
  }




  Future<PopularMovieModel> getPopularMovie() async{
    endpoint="movie/popular";
    final url="$baseUrl$endpoint$key";

    log(url);
    final response=await http.get(Uri.parse(url)).timeout(Duration(seconds: 30));

    if(response.statusCode==200){
      log("success");
    return PopularMovieModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to load Popular Movies");
  }
  
  
  //Search

  Future<SearchModel> getSearchMovie(String searchText) async{
    endpoint="search/movie?query=$searchText";
    final url="$baseUrl$endpoint";

    print("search url is $url");
    final response=await http.get(Uri.parse(url),headers: {
      'Authorization':
           'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3NTAyYjhjMDMxYzc5NzkwZmU1YzBiNGY5NGZkNzcwZCIsInN1YiI6IjYzMmMxYjAyYmE0ODAyMDA4MTcyNjM5NSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.N1SoB26LWgsA33c-5X0DT5haVOD4CfWfRhwpDu9eGkc'
    });
    log(response.statusCode.toString());
    if(response.statusCode==200){
      log("success");
    return SearchModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to load Searched Movie");
  }
  

  //Details
  Future<MovieDetailModel> getMovieDetail(int movieId) async{
    endpoint='movie/$movieId';
    final url="$baseUrl$endpoint$key";

    print("movie details url is $url");
    final response=await http.get(Uri.parse(url),);
    log(response.statusCode.toString());
    if(response.statusCode==200){
      log("success");
    return MovieDetailModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to load Movie Details");
  }


   Future<MovieRecommendationModel> getRecommendations(int movieId) async{
    endpoint='movie/$movieId/recommendations';
    final url="$baseUrl$endpoint$key";

    print("recommendations url is $url");
    final response=await http.get(Uri.parse(url),);
    log(response.statusCode.toString());
    if(response.statusCode==200){
      log("success");
    return MovieRecommendationModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to load more like this");
  }


}