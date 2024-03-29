import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app_riverpod/Home/models/favorite_movie_model.dart';
import 'package:movie_app_riverpod/Home/models/genres_model.dart';
import 'package:movie_app_riverpod/Home/models/video_reponse.dart';
import 'package:movie_app_riverpod/constants.dart';
import 'package:movie_app_riverpod/utils.dart';
import 'dart:convert';
import '../models/movie_model.dart';

class MovieRepository {
  Future<Movies> loadData(String value, {String filterType = 'popular'}) async {
    String searchValue = (value == '') ? '' : value;
    String params = (value == '') ? '/3/movie/$filterType' : '/3/search/movie';
    try {
      final url = Uri.http('api.themoviedb.org', params,
          {'api_key': dotenv.env['APIKEY'], 'query': searchValue});
      final response = await http.get(url);
      Movies moviesData = Movies.fromJson(jsonDecode(response.body));
      return moviesData;
    } catch (e) {
      throw 'error Occured';
    }
  }

  Future<GenresList> getGenresList() async {
    try {
      final response = await http.get(Uri.parse(Constants.genreList));
      final responseValue = GenresList.fromJson(jsonDecode(response.body));
      return responseValue;
    } catch (e) {
      throw 'error Occred';
    }
  }

  Future<FavoriteMovies> fetchFavMovies() async {
    try {
      String queryPrarams = Utils.fetchMovieParams();
      final url = Uri.parse(Utils.fetchMovieUrl(queryPrarams));
      final response = await http.get(url);
      FavoriteMovies moviesData =
          FavoriteMovies.fromJson(jsonDecode(response.body));
      return moviesData;
    } catch (e) {
      throw 'error Occured';
    }
  }

  Future<VideosList> movieVideos(String? id) async {
    try {
      final url = Uri.parse(Utils.movieVideos(id!));
      final response = await http.get(url);
      VideosList moviesData = VideosList.fromJson(jsonDecode(response.body));
      return moviesData;
    } catch (e) {
      throw 'error Occured';
    }
  }
}
