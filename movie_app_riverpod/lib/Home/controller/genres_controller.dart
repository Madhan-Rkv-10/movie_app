import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movie_app_riverpod/Home/controller/provider/providers.dart';
import 'package:movie_app_riverpod/Home/models/genres_model.dart';

import '../repository/movie_repository.dart';

class GenresController extends StateNotifier<GenresList> {
  GenresController(this.ref) : super(GenresList(genres: [])) {
    repo = ref!.read(repoProvider);
    fetchGenresList();
  }
  final StateNotifierProviderRef? ref;

  late MovieRepository? repo;
  Future<void> fetchGenresList() async {
    final data = await repo?.getGenresList();
    state = data!;
  }

  Future<void> updateOption(int index, bool value) async {
    state = state.copyWith(
        genres: state.genres.map((e) {
      if (e.id == index) {
        return e.copyWith(selected: value);
      } else {
        return e;
      }
    }).toList());
    // state = data;
  }
}
