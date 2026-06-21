import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import 'guide_viewer.dart';

class GuidesPage extends StatelessWidget {
  const GuidesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> cheatsheets = [
      {
        'title': 'Custom Bootloader',
        'subtitle': 'Abilities & Setup Guide',
        'description': 'Understand your device capabilities, Zygisk, system backup, and safe debloating steps.',
        'assetPath': 'assets/guides/01_abilities.md',
        'icon': Icons.integration_instructions_outlined,
        'color': AppTheme.cyanAccent,
      },
      {
        'title': 'Root Warnings',
        'subtitle': 'Disclaimers & Safety Checks',
        'description': 'Critical instructions on avoiding bootloader relocking bricks, OTA failure paths, and recovery routines.',
        'assetPath': 'assets/guides/02_warnings_and_disclaimers.md',
        'icon': Icons.warning_amber_rounded,
        'color': Colors.redAccent,
      },
      {
        'title': 'System Workarounds',
        'subtitle': 'Integrity Fixes & Manual Updates',
        'description': 'How to bypass banking app blocks, configuration of Play Integrity Fix modules, and installing region RETEU updates.',
        'assetPath': 'assets/guides/03_workarounds.md',
        'icon': Icons.build_circle_outlined,
        'color': Colors.amberAccent,
      },
      {
        'title': 'Root Customizations',
        'subtitle': 'Audio Engines & GSI Custom ROMs',
        'description': 'Helio G85 engine control tuning, system-wide equalizers (JamesDSP/Viper4Android), and generic system image flashing guide.',
        'assetPath': 'assets/guides/04_root_customizations.md',
        'icon': Icons.tune,
        'color': Colors.purpleAccent,
      },
      {
        'title': 'Repositories & Modules',
        'subtitle': 'F-Droid & Magisk Repo Setup',
        'description': 'Configure third-party F-Droid sources (IzzyOnDroid) and navigate modern Magisk module stores (MMRL, Magisk-Modules-Alt-Repo).',
        'assetPath': 'assets/guides/05_repositories.md',
        'icon': Icons.source_outlined,
        'color': Colors.tealAccent,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline Cheatsheets'),
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
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          itemCount: cheatsheets.length,
          itemBuilder: (context, index) {
            final sheet = cheatsheets[index];
            final Color color = sheet['color'];

            return Card(
              margin: const EdgeInsets.only(bottom: 16.0),
              color: AppTheme.cardBg,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: color.withOpacity(0.15),
                  width: 1,
                ),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GuideViewer(
                        title: sheet['title'],
                        assetPath: sheet['assetPath'],
                      ),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: color.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          sheet['icon'],
                          color: color,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              sheet['title'],
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              sheet['subtitle'],
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: color.withOpacity(0.8),
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              sheet['description'],
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppTheme.textSecondary.withOpacity(0.9),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Text(
                                  'READ MANUAL',
                                  style: GoogleFonts.outfit(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: color,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 14,
                                  color: color,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
