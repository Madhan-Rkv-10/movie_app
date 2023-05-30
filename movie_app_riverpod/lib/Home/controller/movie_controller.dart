import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movie_app_riverpod/Home/controller/provider/providers.dart';
import 'package:movie_app_riverpod/Home/models/movie_model.dart';
import 'package:movie_app_riverpod/Home/presentation/filters.dart';
import 'package:movie_app_riverpod/Home/repository/movie_repository.dart';

class MovieController extends StateNotifier<Movies?> {
  MovieController(this.ref) : super(null) {
    repo = ref!.read(repoProvider);
    fetchMovies();
  }
  late MovieRepository? repo;
  final StateNotifierProviderRef? ref;
  Future<void> fetchMovies({String filterValue = ''}) async {
    final isSearched = ref!.watch(appliedFilter);
    // print(isSearched);
    if (isSearched == true) {
      final filter = ref!.watch(movieFilterProvider);
      final sets = ref!.watch(selectedGenresListProvider);
      final value = await repo?.loadData(filterValue, filterType: filter.value);
      final filteredData = sets.isEmpty
          ? value?.item.toList()
          : value?.item
              .where(
                (element) => Set.of(element.genrId!)
                    .containsAll(sets.map((e) => e.id).toList()),
              )
              .toList();
      if (!mounted) {
        return;
      } else {
        state = sets.isEmpty
            ? value!
            : Movies(
                item: filteredData!,
              );
      }
    } else {
      final filter = ref!.watch(movieFilterProvider);
      final value = await repo?.loadData(filterValue, filterType: filter.value);
      if (!mounted) {
        return;
      } else {
        state = value!;
      }
    }
  }
}
