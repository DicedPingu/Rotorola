import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_theme.dart';

class GuideViewer extends StatelessWidget {
  final String title;
  final String assetPath;

  const GuideViewer({
    super.key,
    required this.title,
    required this.assetPath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(title),
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
        child: FutureBuilder<String>(
          future: DefaultAssetBundle.of(context).loadString(assetPath),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.cyanAccent),
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to load cheatsheet.',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        snapshot.error.toString(),
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          color: AppTheme.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }

            final data = snapshot.data ?? 'No content found.';

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(20.0),
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
                  data: data,
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
                    h1: GoogleFonts.outfit(
                      color: AppTheme.cyanAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      height: 1.4,
                    ),
                    h2: GoogleFonts.outfit(
                      color: AppTheme.cyanAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      height: 1.4,
                    ),
                    h3: GoogleFonts.outfit(
                      color: AppTheme.cyanAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      height: 1.4,
                    ),
                    listBullet: GoogleFonts.outfit(
                      color: AppTheme.cyanAccent,
                      fontSize: 15,
                    ),
                    code: GoogleFonts.firaCode(
                      backgroundColor: Colors.white.withOpacity(0.08),
                      color: AppTheme.cyanAccent,
                      fontSize: 13,
                    ),
                    codeblockPadding: const EdgeInsets.all(14),
                    codeblockDecoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.03),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.07),
                        width: 1,
                      ),
                    ),
                    blockquotePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    blockquoteDecoration: BoxDecoration(
                      color: AppTheme.cyanAccent.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                      border: const Border(
                        left: BorderSide(
                          color: AppTheme.cyanAccent,
                          width: 4,
                        ),
                      ),
                    ),
                    blockquote: GoogleFonts.outfit(
                      color: AppTheme.textPrimary.withOpacity(0.9),
                      fontStyle: FontStyle.italic,
                      fontSize: 14,
                    ),
                    horizontalRuleDecoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Colors.white.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                    ),
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
