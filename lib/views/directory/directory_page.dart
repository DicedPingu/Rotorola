import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../models/item.dart';
import '../../providers/search_provider.dart';
import 'item_detail_page.dart';

class DirectoryPage extends ConsumerStatefulWidget {
  const DirectoryPage({super.key});

  @override
  ConsumerState<DirectoryPage> createState() => _DirectoryPageState();
}

class _DirectoryPageState extends ConsumerState<DirectoryPage> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    // Initialize controller with current provider value
    final initialSearch = ref.read(searchRepositoryProvider);
    _searchController = TextEditingController(text: initialSearch);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Color _getCategoryColor(ItemCategory category) {
    switch (category) {
      case ItemCategory.doImmediately:
        return AppTheme.cyanAccent;
      case ItemCategory.goodToDo:
        return Colors.greenAccent;
      case ItemCategory.avoidOrWrong:
        return Colors.orangeAccent;
      case ItemCategory.destructive:
        return Colors.redAccent;
      case ItemCategory.mindBlowing:
        return Colors.purpleAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredItems = ref.watch(filteredItemsProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);

    final List<Map<String, dynamic>> categoriesList = [
      {'label': 'All', 'value': null, 'color': AppTheme.cyanAccent},
      {'label': 'Do Immediately', 'value': ItemCategory.doImmediately, 'color': AppTheme.cyanAccent},
      {'label': 'Good to Do', 'value': ItemCategory.goodToDo, 'color': Colors.greenAccent},
      {'label': 'Avoid / Wrong', 'value': ItemCategory.avoidOrWrong, 'color': Colors.orangeAccent},
      {'label': 'Destructive', 'value': ItemCategory.destructive, 'color': Colors.redAccent},
      {'label': 'Mind-Blowing', 'value': ItemCategory.mindBlowing, 'color': Colors.purpleAccent},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('The 100 Items'),
        backgroundColor: AppTheme.background,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.background,
              AppTheme.surface,
            ],
          ),
        ),
        child: Column(
          children: [
            // Search Input Field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  ref.read(searchRepositoryProvider.notifier).setQuery(value);
                },
                decoration: InputDecoration(
                  hintText: 'Search items, guides, tools...',
                  prefixIcon: const Icon(Icons.search, color: AppTheme.textSecondary),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: AppTheme.textSecondary),
                          onPressed: () {
                            _searchController.clear();
                            ref.read(searchRepositoryProvider.notifier).setQuery('');
                          },
                        )
                      : null,
                ),
                style: GoogleFonts.outfit(color: AppTheme.textPrimary),
              ),
            ),

            // Horizontal scrolling category chips
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: categoriesList.length,
                itemBuilder: (context, index) {
                  final cat = categoriesList[index];
                  final isSelected = selectedCategory == cat['value'];
                  final Color categoryColor = cat['color'];

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ChoiceChip(
                      label: Text(
                        cat['label'],
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? Colors.black : AppTheme.textPrimary,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: categoryColor,
                      backgroundColor: AppTheme.cardBg,
                      checkmarkColor: Colors.black,
                      showCheckmark: false,
                      side: BorderSide(
                        color: isSelected ? categoryColor : Colors.white.withOpacity(0.05),
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          ref.read(selectedCategoryProvider.notifier).setCategory(cat['value']);
                        }
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),

            // List of items
            Expanded(
              child: filteredItems.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off_outlined, size: 64, color: AppTheme.textSecondary.withOpacity(0.5)),
                          const SizedBox(height: 16),
                          Text(
                            'No items match your search',
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        final categoryColor = _getCategoryColor(item.category);

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12.0),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white.withOpacity(0.06),
                                Colors.white.withOpacity(0.01),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.05),
                              width: 1,
                            ),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                            title: Row(
                              children: [
                                // Item index / id badge
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: categoryColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: categoryColor.withOpacity(0.2),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    '#${item.id}',
                                    style: GoogleFonts.outfit(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: categoryColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    item.title,
                                    style: GoogleFonts.outfit(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.textPrimary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: Text(
                                item.description,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppTheme.textSecondary.withOpacity(0.8),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 16,
                              color: categoryColor.withOpacity(0.8),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ItemDetailPage(item: item),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
