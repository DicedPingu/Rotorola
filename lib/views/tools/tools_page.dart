import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/root_apps_data.dart';
import '../../models/root_app.dart';

class ToolsPage extends StatefulWidget {
  const ToolsPage({super.key});

  @override
  State<ToolsPage> createState() => _ToolsPageState();
}

class _ToolsPageState extends State<ToolsPage> {
  String _searchQuery = '';
  String _selectedCategory = 'All';
  bool _sortByAscending = true;
  bool _groupByCategory = false;

  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  IconData _getIconData(String name) {
    switch (name) {
      case 'terminal':
        return Icons.terminal_rounded;
      case 'security':
        return Icons.security_rounded;
      case 'build':
        return Icons.build_rounded;
      case 'block':
        return Icons.block_rounded;
      case 'backup':
        return Icons.backup_rounded;
      case 'settings_suggest':
        return Icons.settings_suggest_rounded;
      case 'extension':
        return Icons.extension_rounded;
      case 'shop':
        return Icons.storefront_rounded;
      case 'folder':
        return Icons.folder_shared_rounded;
      case 'palette':
        return Icons.palette_rounded;
      case 'computer':
        return Icons.computer_rounded;
      default:
        return Icons.construction_rounded;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Terminal & CLI':
        return AppTheme.cyanAccent;
      case 'Security & Privacy':
        return Colors.redAccent;
      case 'System Utilities':
        return Colors.orangeAccent;
      case 'Backups':
        return Colors.greenAccent;
      case 'Performance Tuning':
        return Colors.yellowAccent;
      case 'System Framework':
        return Colors.purpleAccent;
      case 'Package Managers':
        return Colors.blueAccent;
      case 'UI Customization':
        return Colors.pinkAccent;
      default:
        return AppTheme.cyanAccent;
    }
  }

  List<RootApp> _getFilteredAndSortedApps() {
    List<RootApp> list = rootAppsList.where((app) {
      final matchesSearch = app.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          app.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          app.whatIsIt.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          app.whyRoot.toLowerCase().contains(_searchQuery.toLowerCase());
      
      final matchesCategory = _selectedCategory == 'All' || app.category == _selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();

    // Sort
    list.sort((a, b) {
      int cmp = a.title.compareTo(b.title);
      return _sortByAscending ? cmp : -cmp;
    });

    return list;
  }

  @override
  Widget build(BuildContext context) {
    final filteredApps = _getFilteredAndSortedApps();
    
    // Extract unique categories for filter chips
    final Set<String> categories = {'All', ...rootAppsList.map((app) => app.category)};

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Root Apps Database'),
        backgroundColor: AppTheme.background,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              _sortByAscending ? Icons.sort_by_alpha : Icons.sort_by_alpha_outlined,
              color: AppTheme.cyanAccent,
            ),
            tooltip: _sortByAscending ? 'Sort Z-A' : 'Sort A-Z',
            onPressed: () {
              setState(() {
                _sortByAscending = !_sortByAscending;
              });
            },
          ),
          IconButton(
            icon: Icon(
              _groupByCategory ? Icons.grid_view : Icons.view_headline,
              color: AppTheme.cyanAccent,
            ),
            tooltip: _groupByCategory ? 'Disable Grouping' : 'Group by Category',
            onPressed: () {
              setState(() {
                _groupByCategory = !_groupByCategory;
              });
            },
          ),
        ],
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
            // Search field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search root apps, modules, CLI...',
                  prefixIcon: const Icon(Icons.search, color: AppTheme.textSecondary),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: AppTheme.textSecondary),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                ),
                style: GoogleFonts.outfit(color: AppTheme.textPrimary),
              ),
            ),

            // Horizontal categories filter
            SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: categories.map((cat) {
                  final isSelected = _selectedCategory == cat;
                  final color = cat == 'All' ? AppTheme.cyanAccent : _getCategoryColor(cat);

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ChoiceChip(
                      label: Text(
                        cat,
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? Colors.black : AppTheme.textPrimary,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: color,
                      backgroundColor: AppTheme.cardBg,
                      checkmarkColor: Colors.black,
                      showCheckmark: false,
                      side: BorderSide(
                        color: isSelected ? color : Colors.white.withOpacity(0.05),
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedCategory = cat;
                          });
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 10),

            // Main Catalog display
            Expanded(
              child: filteredApps.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off_outlined, size: 64, color: AppTheme.textSecondary.withOpacity(0.5)),
                          const SizedBox(height: 16),
                          Text(
                            'No apps match your criteria',
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    )
                  : _groupByCategory
                      ? _buildGroupedList(filteredApps)
                      : _buildUngroupedList(filteredApps),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUngroupedList(List<RootApp> apps) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      itemCount: apps.length,
      itemBuilder: (context, index) {
        return _buildAppCard(apps[index]);
      },
    );
  }

  Widget _buildGroupedList(List<RootApp> apps) {
    // Group apps by category
    final Map<String, List<RootApp>> grouped = {};
    for (var app in apps) {
      grouped.putIfAbsent(app.category, () => []).add(app);
    }

    final List<String> sortedCategories = grouped.keys.toList()..sort();

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      itemCount: sortedCategories.length,
      itemBuilder: (context, catIndex) {
        final category = sortedCategories[catIndex];
        final categoryApps = grouped[category]!;
        final Color catColor = _getCategoryColor(category);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 10.0, left: 4.0),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 16,
                    decoration: BoxDecoration(
                      color: catColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    category.toUpperCase(),
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: catColor,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '(${categoryApps.length})',
                    style: GoogleFonts.firaCode(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            ...categoryApps.map((app) => _buildAppCard(app)),
          ],
        );
      },
    );
  }

  Widget _buildAppCard(RootApp app) {
    final Color color = _getCategoryColor(app.category);
    final IconData icon = _getIconData(app.iconName);

    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.04),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        icon,
                        color: color,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      app.title,
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: color.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    app.category.toUpperCase(),
                    style: GoogleFonts.outfit(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: color,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Description
            Text(
              app.description,
              style: GoogleFonts.outfit(
                fontSize: 14,
                color: AppTheme.textSecondary.withOpacity(0.9),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 14),

            // Detailed information cards
            _buildDetailSubSection('WHAT IS IT?', app.whatIsIt, color, Icons.help_outline),
            const SizedBox(height: 10),
            _buildDetailSubSection('WHY DOES IT NEED ROOT?', app.whyRoot, color, Icons.vpn_key_outlined),
            const SizedBox(height: 10),
            _buildDetailSubSection('COMMUNITY REVIEW', app.communityPraise, color, Icons.thumb_up_alt_outlined),
            const SizedBox(height: 16),

            // Link Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.02),
                  foregroundColor: AppTheme.cyanAccent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: AppTheme.cyanAccent.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () async {
                  final uri = Uri.parse(app.linkUrl);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.open_in_new_rounded, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'VISIT HOMEPAGE / GITHUB',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSubSection(String title, String content, Color accentColor, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: accentColor, size: 15),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: accentColor,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                content,
                style: GoogleFonts.outfit(
                  fontSize: 12.5,
                  color: AppTheme.textPrimary.withOpacity(0.85),
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
