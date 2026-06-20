import '../../models/tool.dart';

const List<Tool> toolsList = [
  Tool(
    title: 'Termux',
    description: 'A powerful terminal emulator and Linux environment for Android. Access standard command-line tools, shell scripts, and package managers without root, and unlock full power with root privileges.',
    category: 'Terminal & CLI',
    linkUrl: 'https://github.com/termux/termux-app/releases',
    iconName: 'terminal',
  ),
  Tool(
    title: 'Kali NetHunter',
    description: 'An open-source penetration testing platform for Android devices. Access the Kali toolset (nmap, Metasploit, Wifite, etc.) directly on your phone.',
    category: 'Security Testing',
    linkUrl: 'https://www.kali.org/docs/nethunter/',
    iconName: 'security',
  ),
  Tool(
    title: 'Tool-X',
    description: 'An automated installer for over 370 hacking tools in Termux. Perfect for quickly setting up security testing utilities on a clean terminal.',
    category: 'Security Testing',
    linkUrl: 'https://github.com/Rajkumarsidus/Tool-X',
    iconName: 'build',
  ),
  Tool(
    title: 'AdAway',
    description: 'A system-wide open-source ad blocker that uses the hosts file to block ads in all apps and browsers. Lightweight and uses zero battery.',
    category: 'System Utility',
    linkUrl: 'https://adaway.org/',
    iconName: 'block',
  ),
  Tool(
    title: 'Swift Backup',
    description: 'A premium-tier backup manager that backs up your APKs, user data, app configs, Wi-Fi networks, and SMS messages. Highly recommended for rooted systems.',
    category: 'Backups',
    linkUrl: 'https://play.google.com/store/apps/details?id=parts.swift.backup',
    iconName: 'backup',
  ),
  Tool(
    title: 'SmartPack Kernel Manager',
    description: 'An advanced kernel manager that lets you tune CPU and GPU governors, manage memory (low memory killer), monitor performance, and control battery charging limits.',
    category: 'Performance',
    linkUrl: 'https://github.com/SmartPack/SmartPack-Kernel-Manager/releases',
    iconName: 'settings_suggest',
  ),
  Tool(
    title: 'LSPosed (Zygisk)',
    description: 'A modern Xposed framework implementation built on top of Zygisk. Allows you to hook into system methods to tweak device UI and behaviors without modifying system files.',
    category: 'System Framework',
    linkUrl: 'https://github.com/LSPosed/LSPosed/releases',
    iconName: 'extension',
  ),
  Tool(
    title: 'Neo Store',
    description: 'A modern, beautiful, and secure F-Droid client for downloading open-source Android apps. Provides clean UI and automatic background updates.',
    category: 'App Store',
    linkUrl: 'https://github.com/NeoApplications/Neo-Store/releases',
    iconName: 'shop',
  ),
  Tool(
    title: 'Canta',
    description: 'An open-source uninstaller app that uses Shizuku to uninstall any system app and bloatware without root, but runs even faster with root permissions.',
    category: 'System Utility',
    linkUrl: 'https://github.com/samolego/Canta/releases',
    iconName: 'delete_forever',
  ),
  Tool(
    title: 'MTKClient',
    description: 'A powerful tool to bypass bootloader security and read/write partitions on MediaTek devices at the BootROM level. Keep this on your PC for emergency recovery.',
    category: 'PC Tool',
    linkUrl: 'https://github.com/bkerler/mtkclient',
    iconName: 'computer',
  ),
];
