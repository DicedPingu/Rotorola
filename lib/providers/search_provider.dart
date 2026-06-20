import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/item.dart';
import '../core/constants/items_data.dart';

// State provider for the active search query
final searchRepositoryProvider = StateProvider<String>((ref) => '');

// State provider for the selected filter category (null means 'All')
final selectedCategoryProvider = StateProvider<ItemCategory?>((ref) => null);

// Provider that returns the filtered items based on search and category
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
