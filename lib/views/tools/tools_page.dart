import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/tools_data.dart';

class ToolsPage extends StatelessWidget {
  const ToolsPage({super.key});

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
      case 'delete_forever':
        return Icons.delete_forever_rounded;
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
      case 'Security Testing':
        return Colors.redAccent;
      case 'System Utility':
        return Colors.orangeAccent;
      case 'Backups':
        return Colors.greenAccent;
      case 'Performance':
        return Colors.yellowAccent;
      case 'System Framework':
        return Colors.purpleAccent;
      case 'App Store':
        return Colors.blueAccent;
      case 'PC Tool':
        return Colors.tealAccent;
      default:
        return AppTheme.cyanAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Curated Utilities'),
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
          itemCount: toolsList.length,
          itemBuilder: (context, index) {
            final tool = toolsList[index];
            final Color color = _getCategoryColor(tool.category);
            final IconData icon = _getIconData(tool.iconName);

            return Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              decoration: BoxDecoration(
                color: AppTheme.cardBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.05),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
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
                    // Top header: Icon and Category badge
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: color.withOpacity(0.25),
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            icon,
                            color: color,
                            size: 24,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: color.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            tool.category.toUpperCase(),
                            style: GoogleFonts.outfit(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: color,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Title
                    Text(
                      tool.title,
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Description
                    Text(
                      tool.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary.withOpacity(0.9),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Launch/Download Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.cardBg,
                          foregroundColor: AppTheme.cyanAccent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: AppTheme.cyanAccent.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () async {
                          final uri = Uri.parse(tool.linkUrl);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri, mode: LaunchMode.externalApplication);
                          }
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.download_rounded, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              'GET UTILITY',
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
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
          },
        ),
      ),
    );
  }
}
