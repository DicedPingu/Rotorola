import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/item.dart';
import '../core/constants/items_data.dart';

class NavigationIndex extends Notifier<int> {
  @override
  int build() => 0;
  void setIndex(int index) => state = index;
}

final navigationIndexProvider = NotifierProvider<NavigationIndex, int>(NavigationIndex.new);

class SearchRepository extends Notifier<String> {
  @override
  String build() => '';
  void setQuery(String query) => state = query;
}

final searchRepositoryProvider = NotifierProvider<SearchRepository, String>(SearchRepository.new);

class SelectedCategory extends Notifier<ItemCategory?> {
  @override
  ItemCategory? build() => null;
  void setCategory(ItemCategory? category) => state = category;
}

final selectedCategoryProvider = NotifierProvider<SelectedCategory, ItemCategory?>(SelectedCategory.new);

final filteredItemsProvider = Provider<List<Item>>((ref) {
  final query = ref.watch(searchRepositoryProvider).toLowerCase();
  final category = ref.watch(selectedCategoryProvider);

  return itemsList.where((item) {
    final matchesSearch = item.title.toLowerCase().contains(query) ||
        item.description.toLowerCase().contains(query) ||
        item.guide.toLowerCase().contains(query);

    final matchesCategory = category == null || item.category == category;

    return matchesSearch && matchesCategory;
  }).toList();
});
