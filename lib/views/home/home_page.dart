import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/items_data.dart';
import '../../models/item.dart';
import '../guides/guide_viewer.dart';
import 'settings_page.dart';
import '../../providers/search_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Dynamically calculate counts
    final doImmediatelyCount = itemsList.where((i) => i.category == ItemCategory.doImmediately).length;
    final goodToDoCount = itemsList.where((i) => i.category == ItemCategory.goodToDo).length;
    final avoidOrWrongCount = itemsList.where((i) => i.category == ItemCategory.avoidOrWrong).length;
    final destructiveCount = itemsList.where((i) => i.category == ItemCategory.destructive).length;
    final mindBlowingCount = itemsList.where((i) => i.category == ItemCategory.mindBlowing).length;

    return Scaffold(
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
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome / Header section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ROTOROLA HUB',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.cyanAccent,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Welcome, Operator',
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsPage(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppTheme.cyanAccent.withOpacity(0.1),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppTheme.cyanAccent.withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        child: const Icon(
                          Icons.settings,
                          color: AppTheme.cyanAccent,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Device Specs Welcome Card (Glassmorphism design)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.07),
                        Colors.white.withOpacity(0.02),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.developer_mode,
                            color: AppTheme.cyanAccent,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'DEVICE IDENTIFIED',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.cyanAccent,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildSpecItem(context, 'CODENAME', 'fogorow', Icons.label_important_outline),
                          _buildSpecItem(context, 'OS VERSION', 'Android 14', Icons.android),
                          _buildSpecItem(context, 'SOC', 'Helio G85', Icons.memory),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Divider(color: Colors.white.withOpacity(0.1), height: 1),
                      const SizedBox(height: 16),
                      Text(
                        'Your Motorola G24 is fully mapped. Access guides, execute root-level optimizations, and review potential hazards below.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textPrimary.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Quick Launch Cheatsheets Title
                Text(
                  'Quick Launch Cheatsheets',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 14),

                // Cheatsheets horizontal row
                SizedBox(
                  height: 110,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _buildQuickLaunchCard(
                        context: context,
                        title: 'Custom Bootloader',
                        subtitle: 'abilities & setup',
                        assetPath: 'assets/guides/01_abilities.md',
                        icon: Icons.integration_instructions,
                        accentColor: AppTheme.cyanAccent,
                      ),
                      _buildQuickLaunchCard(
                        context: context,
                        title: 'Root Warnings',
                        subtitle: 'disclaimers & safety',
                        assetPath: 'assets/guides/02_warnings_and_disclaimers.md',
                        icon: Icons.warning_amber_rounded,
                        accentColor: Colors.redAccent,
                      ),
                      _buildQuickLaunchCard(
                        context: context,
                        title: 'Workarounds',
                        subtitle: 'play integrity / updates',
                        assetPath: 'assets/guides/03_workarounds.md',
                        icon: Icons.build_circle_outlined,
                        accentColor: Colors.amberAccent,
                      ),
                      _buildQuickLaunchCard(
                        context: context,
                        title: 'Customizations',
                        subtitle: 'audio & GSIs',
                        assetPath: 'assets/guides/04_root_customizations.md',
                        icon: Icons.tune,
                        accentColor: Colors.purpleAccent,
                      ),
                      _buildQuickLaunchCard(
                        context: context,
                        title: 'Repositories',
                        subtitle: 'F-Droid & Magisk repos',
                        assetPath: 'assets/guides/05_repositories.md',
                        icon: Icons.source,
                        accentColor: Colors.tealAccent,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Item categories counters
                Text(
                  'Handbook Index Counters',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 14),

                // Grid of categories
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.45,
                  children: [
                    GestureDetector(
                      onTap: () {
                        ref.read(selectedCategoryProvider.notifier).setCategory(ItemCategory.doImmediately);
                        ref.read(navigationIndexProvider.notifier).setIndex(1);
                      },
                      child: _buildCounterCard(
                        context: context,
                        title: 'Do Immediately',
                        count: doImmediatelyCount,
                        color: AppTheme.cyanAccent,
                        icon: Icons.bolt,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        ref.read(selectedCategoryProvider.notifier).setCategory(ItemCategory.goodToDo);
                        ref.read(navigationIndexProvider.notifier).setIndex(1);
                      },
                      child: _buildCounterCard(
                        context: context,
                        title: 'Good to Do',
                        count: goodToDoCount,
                        color: Colors.greenAccent,
                        icon: Icons.thumb_up_alt_outlined,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        ref.read(selectedCategoryProvider.notifier).setCategory(ItemCategory.avoidOrWrong);
                        ref.read(navigationIndexProvider.notifier).setIndex(1);
                      },
                      child: _buildCounterCard(
                        context: context,
                        title: 'Avoid / Wrong',
                        count: avoidOrWrongCount,
                        color: Colors.orangeAccent,
                        icon: Icons.gpp_bad_outlined,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        ref.read(selectedCategoryProvider.notifier).setCategory(ItemCategory.destructive);
                        ref.read(navigationIndexProvider.notifier).setIndex(1);
                      },
                      child: _buildCounterCard(
                        context: context,
                        title: 'Destructive',
                        count: destructiveCount,
                        color: Colors.redAccent,
                        icon: Icons.dangerous_outlined,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        ref.read(selectedCategoryProvider.notifier).setCategory(ItemCategory.mindBlowing);
                        ref.read(navigationIndexProvider.notifier).setIndex(1);
                      },
                      child: _buildCounterCard(
                        context: context,
                        title: 'Mind-Blowing',
                        count: mindBlowingCount,
                        color: Colors.purpleAccent,
                        icon: Icons.psychology_outlined,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpecItem(BuildContext context, String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: AppTheme.textSecondary),
            const SizedBox(width: 4),
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: AppTheme.textSecondary,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickLaunchCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String assetPath,
    required IconData icon,
    required Color accentColor,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GuideViewer(
              title: title,
              assetPath: assetPath,
            ),
          ),
        );
      },
      child: Container(
        width: 170,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: accentColor.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              icon,
              color: accentColor,
              size: 28,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCounterCard({
    required BuildContext context,
    required String title,
    required int count,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.03),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              Text(
                '$count',
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
