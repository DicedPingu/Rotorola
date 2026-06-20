import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_theme.dart';
import '../../models/item.dart';

class ItemDetailPage extends StatelessWidget {
  final Item item;

  const ItemDetailPage({
    super.key,
    required this.item,
  });

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
    final Color accentColor = _getCategoryColor(item.category);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text('Item #${item.id}'),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: accentColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  item.categoryName.toUpperCase(),
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: accentColor,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Text(
                item.title,
                style: GoogleFonts.outfit(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 12),

              // Description
              Text(
                item.description,
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  color: AppTheme.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),

              Divider(color: Colors.white.withOpacity(0.1), height: 1),
              const SizedBox(height: 20),

              // WHAT IS IT? Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.02),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.04),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.help_outline_rounded, color: accentColor, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'WHAT IS IT?',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: accentColor,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.whatIsIt,
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        color: AppTheme.textPrimary.withOpacity(0.9),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // WHY DO I WANT THIS? Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: accentColor.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.psychology_outlined, color: accentColor, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'WHY DO I WANT THIS?',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: accentColor,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.whyDoIWantIt,
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        color: AppTheme.textPrimary.withOpacity(0.95),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Divider(color: Colors.white.withOpacity(0.1), height: 1),
              const SizedBox(height: 24),

              // Instructions Header
              Row(
                children: [
                  Icon(Icons.terminal_outlined, color: accentColor, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'INSTRUCTIONS & GUIDE',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: accentColor,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Detailed markdown code panel
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
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
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: MarkdownBody(
                  data: item.guide,
                  selectable: true,
                  onTapLink: (text, href, title) async {
                    if (href != null) {
                      final uri = Uri.parse(href);
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri, mode: LaunchMode.externalApplication);
                      }
                    }
                  },
                  styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                    p: GoogleFonts.outfit(
                      color: AppTheme.textPrimary,
                      fontSize: 15,
                      height: 1.6,
                    ),
                    code: GoogleFonts.firaCode(
                      backgroundColor: Colors.white.withOpacity(0.08),
                      color: AppTheme.cyanAccent,
                      fontSize: 13.5,
                    ),
                    codeblockPadding: const EdgeInsets.all(12),
                    codeblockDecoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.03),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.06),
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
