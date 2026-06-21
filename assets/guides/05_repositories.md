# F-Droid & Magisk Repositories Guide

To get the most out of your rooted Motorola G24, you need to understand how to add, sync, and maintain third-party package repositories. Since the official Magisk module store was retired, custom repository managers are now required to update root modules.

---

## 1. F-Droid Custom Repositories
F-Droid is an installer for Free and Open Source Software (FOSS). By default, it only queries the official F-Droid repository. However, many advanced rooted apps are hosted in custom community repositories.

### Recommended Repositories
1. **IzzyOnDroid**
   * **What it is**: The largest and most trusted unofficial F-Droid repository. It hosts developers' official binaries directly from their GitHub release assets.
   * **Repository URL**: `https://apt.izzysoft.de/fdroid/index/apk`
   * **Signing Key fingerprint**: `30:CF:62:3C:99:A5:EB:EF:3A:E1:92:43:48:ED:F5:4A:2A:42:0D:39:D5:78:BE:2C:9E:C5:15:37:A6:CF:C0:00`

2. **Guardian Project Repo**
   * **What it is**: Repos for privacy-focused tools like Tor Browser, Orbot, and secure messaging.
   * **Repository URL**: `https://guardianproject.info/fdroid/repo`

### How to Add a Repository (Neo Store or F-Droid Client)
1. Open your repository client (e.g., **Neo Store**).
2. Go to **Settings** > **Repositories** (or Sources).
3. Tap the **+** (Add) button in the top right.
4. Paste the Repository URL. The client will automatically fetch the key fingerprint.
5. Tap **Add** / **Save** and wait for the database to sync.

---

## 2. Magisk Modules & Custom Repos
Magisk modules allow systemless modification of system files. Since Magisk v24, the built-in module download section has been removed. You must now manage modules manually or use a module repository manager.

### The Successor: Magisk-Modules-Alt-Repo
To replace the old system, the community created **Magisk-Modules-Alt-Repo**, a curated list of active modules maintained on GitHub.

### Modern Module Managers (App Stores for Modules)
To avoid downloading zip files manually from GitHub every time there is an update, you can install dedicated manager clients that hook directly into Alt-Repo:

1. **MMRL (Magisk Module Repo Loader)**
   * **What it is**: A premium, highly customizable app store for Magisk, KernelSU, and APatch modules.
   * **Features**:
     * Multi-repo support: add any custom repository JSON link.
     * Automated update notifications for modules.
     * Module conflict and dependency checking before installing.
     * Built-in root explorer to manually disable bootlooping modules.
   * **Homepage**: [GitHub - MMRL](https://github.com/Goooler/MMRL)

2. **MModule**
   * **What it is**: A lightweight, minimal app designed specifically to browse and download modules from the Alt-Repo source list.
   * **Homepage**: [GitHub - MModule](https://github.com/SimplicityDev/MModule)

### How to Configure MMRL with Custom Repos
1. Download and install **MMRL** from GitHub or IzzyOnDroid.
2. Grant MMRL **Superuser permissions** upon opening.
3. Go to the **Settings** or **Repositories** section inside the app.
4. Add the default community repository URL:
   * `https://raw.githubusercontent.com/magisk-modules-alt-repo/submission/main/db.json`
5. Save the configuration. You can now browse hundreds of modules, click install, and receive update notifications just like standard Google Play applications.
