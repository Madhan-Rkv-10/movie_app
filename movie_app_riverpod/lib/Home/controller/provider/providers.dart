import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movie_app_riverpod/Home/controller/genres_controller.dart';
import 'package:movie_app_riverpod/Home/models/favorite_movie_model.dart';
import 'package:movie_app_riverpod/Home/models/genres_model.dart';
import 'package:movie_app_riverpod/Home/models/video_reponse.dart';

import '../../models/movie_model.dart';
import '../../presentation/filters.dart';
import '../../repository/movie_repository.dart';
import '../movie_controller.dart';

final movieFilterProvider = StateProvider((ref) => MovieType.popular);
final repoProvider = Provider((ref) => MovieRepository());
final movieControllerProvider =
    StateNotifierProvider.autoDispose<MovieController, Movies?>((ref) {
  return MovieController(ref);
});
final genresListProvider =
    StateNotifierProvider<GenresController, GenresList>((ref) {
  return GenresController(ref);
});
final fav = FutureProvider<FavoriteMovies>((ref) {
  final data = ref.watch(repoProvider);
  return data.fetchFavMovies();
});

final selectedGenresListProvider = StateProvider<Iterable<Genres>>((ref) {
  final res = ref
      .watch(genresListProvider)
      .genres
      .where((element) => element.selected == true);
  return res;
});
final isLoadingProvider = StateProvider<bool>((ref) => false);
final appliedFilter = StateProvider<bool>((ref) => false);
final themeProvider = StateProvider<bool>((ref) => false);
final videoProvider = FutureProvider.family<VideosList, String>(
  (ref, arg) {
    final provider = ref.watch(repoProvider);
    return provider.movieVideos(arg);
  },
);
