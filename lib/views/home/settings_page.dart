import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/settings_provider.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  @override
  void initState() {
    super.initState();
    // Run diagnostics when page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(settingsProvider.notifier).runDiagnostics();
    });
  }

  void _showWarningDialog(BuildContext context, String title, String warning) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.redAccent.withOpacity(0.3), width: 1.5),
        ),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 28),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.outfit(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: Text(
          warning,
          style: GoogleFonts.outfit(color: AppTheme.textPrimary, fontSize: 14, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Acknowledge',
              style: GoogleFonts.outfit(color: AppTheme.cyanAccent, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(
          'ROOT DIAGNOSTICS & SYSTEM',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1),
        ),
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
              // Diagnostic status card
              _buildDiagnosticCard(context, settings),
              const SizedBox(height: 24),

              // Root parameters header
              Text(
                'Root Parameters & Safety',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.cyanAccent,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 12),

              // Interactive toggles
              _buildConfigTile(
                title: 'Zygisk Integration',
                subtitle: 'Enable code injection for root hiding modules',
                value: settings.rootStatus == RootStatus.rooted,
                onChanged: (val) {
                  _showWarningDialog(
                    context,
                    'Zygisk Config',
                    'To enable or disable Zygisk, open the Magisk app on your device, go to Settings (gear icon), scroll to the Zygisk toggle, switch it, and restart your Motorola phone.',
                  );
                },
                icon: Icons.offline_bolt_outlined,
                activeColor: AppTheme.cyanAccent,
              ),
              _buildConfigTile(
                title: 'SELinux Permissive Mode',
                subtitle: 'Reduces kernel sandbox enforcement (RISKY)',
                value: settings.selinuxMode == SelinuxMode.permissive,
                onChanged: (val) {
                  _showWarningDialog(
                    context,
                    'SELinux Warning',
                    'Running SELinux in Permissive mode reduces kernel-level containment and sandbox security. Malicious root apps can fully compromise device secrets. Always keep SELinux Enforcing unless debugging.',
                  );
                },
                icon: Icons.security,
                activeColor: Colors.orangeAccent,
              ),
              _buildConfigTile(
                title: 'Block OTA Updates',
                subtitle: 'Safeguard system files from update overwrite',
                value: true,
                onChanged: (val) {
                  _showWarningDialog(
                    context,
                    'OTA Updates Disabled',
                    'Automatic system updates are blocked to prevent bootloops or loss of root. You must sideload full OTA zips or flash manually if you want to upgrade system versions.',
                  );
                },
                icon: Icons.block,
                activeColor: Colors.greenAccent,
              ),
              const SizedBox(height: 24),

              // Backup & directories
              Text(
                'Directories & Backups',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.cyanAccent,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 12),

              _buildDirectoryTile(
                title: 'PC Workspace Backup',
                path: '/home/dicedpingu/SPQR/rotorola/backups/',
                icon: Icons.computer,
              ),
              _buildDirectoryTile(
                title: 'Local Device Backup',
                path: '/sdcard/Rotorola/backups/',
                icon: Icons.sd_card_outlined,
              ),
              const SizedBox(height: 24),

              // UI styling toggles
              Text(
                'App Interface Tweaks',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.cyanAccent,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 12),

              _buildConfigTile(
                title: 'Premium Neon Glows',
                subtitle: 'Enable custom aesthetic accent overlays',
                value: settings.glowEnabled,
                onChanged: (val) {
                  ref.read(settingsProvider.notifier).toggleGlow();
                },
                icon: Icons.lightbulb_outline,
                activeColor: AppTheme.cyanAccent,
              ),
              _buildConfigTile(
                title: 'Micro-Haptic Feedback',
                subtitle: 'Gentle device vibration on button interactions',
                value: settings.hapticsEnabled,
                onChanged: (val) {
                  ref.read(settingsProvider.notifier).toggleHaptics();
                },
                icon: Icons.vibration,
                activeColor: AppTheme.cyanAccent,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDiagnosticCard(BuildContext context, SettingsState settings) {
    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (settings.rootStatus) {
      case RootStatus.checking:
        statusColor = Colors.orangeAccent;
        statusText = 'RUNNING DIAGNOSTICS...';
        statusIcon = Icons.hourglass_empty;
        break;
      case RootStatus.rooted:
        statusColor = AppTheme.cyanAccent;
        statusText = 'DEVICE ROOTED';
        statusIcon = Icons.check_circle_outline;
        break;
      case RootStatus.notRooted:
        statusColor = Colors.redAccent;
        statusText = 'ROOT NOT DETECTED';
        statusIcon = Icons.error_outline;
        break;
      case RootStatus.unknown:
        statusColor = Colors.grey;
        statusText = 'UNKNOWN STATUS';
        statusIcon = Icons.help_outline;
        break;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: statusColor.withOpacity(0.15),
          width: 1.5,
        ),
        boxShadow: settings.glowEnabled
            ? [
                BoxShadow(
                  color: statusColor.withOpacity(0.08),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ]
            : [],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(statusIcon, color: statusColor, size: 24),
                  const SizedBox(width: 10),
                  Text(
                    statusText,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.refresh, color: AppTheme.textSecondary),
                onPressed: () {
                  ref.read(settingsProvider.notifier).runDiagnostics();
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildInfoRow('SU Binary Path', settings.rootPath),
          const SizedBox(height: 12),
          _buildInfoRow(
            'SELinux Status',
            settings.selinuxMode == SelinuxMode.enforcing
                ? 'Enforcing (Secure)'
                : settings.selinuxMode == SelinuxMode.permissive
                    ? 'Permissive (Vulnerable)'
                    : 'Unknown',
            valueColor: settings.selinuxMode == SelinuxMode.enforcing
                ? Colors.greenAccent
                : Colors.orangeAccent,
          ),
          const SizedBox(height: 12),
          _buildInfoRow('Play Integrity Bypass', settings.playIntegrityStatus),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(fontSize: 13, color: AppTheme.textSecondary),
        ),
        Text(
          value,
          style: GoogleFonts.firaCode(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: valueColor ?? AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildConfigTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required IconData icon,
    required Color activeColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.02), width: 1),
      ),
      child: SwitchListTile(
        activeColor: activeColor,
        activeTrackColor: activeColor.withOpacity(0.2),
        inactiveThumbColor: Colors.grey,
        inactiveTrackColor: Colors.white.withOpacity(0.05),
        title: Row(
          children: [
            Icon(icon, color: value ? activeColor : AppTheme.textSecondary, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(left: 32, top: 4),
          child: Text(
            subtitle,
            style: GoogleFonts.outfit(fontSize: 12, color: AppTheme.textSecondary),
          ),
        ),
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildDirectoryTile({
    required String title,
    required String path,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.02), width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.cyanAccent, size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                SelectableText(
                  path,
                  style: GoogleFonts.firaCode(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
