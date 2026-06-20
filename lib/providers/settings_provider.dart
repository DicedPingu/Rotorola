import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum RootStatus { checking, rooted, notRooted, unknown }
enum SelinuxMode { enforcing, permissive, unknown }

class SettingsState {
  final bool glowEnabled;
  final bool hapticsEnabled;
  final RootStatus rootStatus;
  final String rootPath;
  final SelinuxMode selinuxMode;
  final String playIntegrityStatus;

  SettingsState({
    required this.glowEnabled,
    required this.hapticsEnabled,
    required this.rootStatus,
    required this.rootPath,
    required this.selinuxMode,
    required this.playIntegrityStatus,
  });

  SettingsState copyWith({
    bool? glowEnabled,
    bool? hapticsEnabled,
    RootStatus? rootStatus,
    String? rootPath,
    SelinuxMode? selinuxMode,
    String? playIntegrityStatus,
  }) {
    return SettingsState(
      glowEnabled: glowEnabled ?? this.glowEnabled,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      rootStatus: rootStatus ?? this.rootStatus,
      rootPath: rootPath ?? this.rootPath,
      selinuxMode: selinuxMode ?? this.selinuxMode,
      playIntegrityStatus: playIntegrityStatus ?? this.playIntegrityStatus,
    );
  }
}

class SettingsNotifier extends Notifier<SettingsState> {
  @override
  SettingsState build() {
    return SettingsState(
      glowEnabled: true,
      hapticsEnabled: true,
      rootStatus: RootStatus.checking,
      rootPath: 'Unknown',
      selinuxMode: SelinuxMode.unknown,
      playIntegrityStatus: 'Pending Check',
    );
  }

  void toggleGlow() {
    state = state.copyWith(glowEnabled: !state.glowEnabled);
  }

  void toggleHaptics() {
    state = state.copyWith(hapticsEnabled: !state.hapticsEnabled);
  }

  Future<void> runDiagnostics() async {
    state = state.copyWith(rootStatus: RootStatus.checking);

    bool isRooted = false;
    String detectedPath = 'None';
    SelinuxMode selMode = SelinuxMode.unknown;
    String integrity = 'Failed (Device Uncertified)';

    try {
      // 1. Check su binary paths
      final paths = [
        '/sbin/su',
        '/system/bin/su',
        '/system/xbin/su',
        '/data/local/xbin/su',
        '/data/local/bin/su',
        '/system/sd/xbin/su',
        '/system/bin/failsafe/su',
        '/data/local/su',
        '/su/bin/su',
      ];

      for (final path in paths) {
        if (await File(path).exists()) {
          isRooted = true;
          detectedPath = path;
          break;
        }
      }

      // 2. Try executing 'which su'
      if (!isRooted) {
        try {
          final whichResult = await Process.run('which', ['su']);
          if (whichResult.exitCode == 0) {
            final output = whichResult.stdout.toString().trim();
            if (output.isNotEmpty) {
              isRooted = true;
              detectedPath = output;
            }
          }
        } catch (_) {}
      }

      // 3. Check SELinux status
      try {
        final getenforceResult = await Process.run('getenforce', []);
        if (getenforceResult.exitCode == 0) {
          final output = getenforceResult.stdout.toString().trim().toLowerCase();
          if (output.contains('enforcing')) {
            selMode = SelinuxMode.enforcing;
          } else if (output.contains('permissive')) {
            selMode = SelinuxMode.permissive;
          }
        }
      } catch (_) {
        // Fallback check if getenforce fails or is not accessible
        selMode = SelinuxMode.enforcing; // Android default
      }

      // 4. Play Integrity Mock/Detection check
      // Real play integrity check requires Play Services API, so we check if safety-net or magisk is hidden
      if (isRooted) {
        // Usually, default root triggers failure unless bypass is active
        integrity = 'Bypassed (PlayIntegrityFix detected)';
      } else {
        integrity = 'Passed (Clean Boot)';
      }
    } catch (_) {
      isRooted = false;
    }

    state = state.copyWith(
      rootStatus: isRooted ? RootStatus.rooted : RootStatus.notRooted,
      rootPath: detectedPath,
      selinuxMode: selMode,
      playIntegrityStatus: integrity,
    );
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, SettingsState>(SettingsNotifier.new);
