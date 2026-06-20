# rooted G24 - Customization & Tuning Cheatsheet

Here is how to optimize your phone's performance, audio hardware, and system architecture:

---

## 1. Performance Tuning (Helio G85 Engine Control)
Since the MT6768 (Helio G85) is a budget CPU, tuning can help optimize battery life or reduce gaming lags:

* **Apps to use**: **SmartPack Kernel Manager** or **Franco Kernel Manager** (FKM).
* **Governor Tweak**: Switch the CPU governor to **Schedutil** or **Interactive** for balanced usage, or **Performance** while gaming.
* **Low Memory Killer (LMK)**: Adjust LMK settings in the app to keep background apps in memory longer or free up RAM aggressively.

---

## 2. Advanced Audio Engine (Viper4Android / JamesDSP)
Install a system-wide equalizer and audio processing engine:

1. Enable **Zygisk** in Magisk settings and reboot.
2. Download and install the **Audio Modification Library** module in Magisk.
3. Install **Viper4Android FX** or **JamesDSP** Magisk module.
4. Open the app to configure convolvers, bass boost, and custom headphone profiles.

---

## 3. Flashing GSIs (Generic System Images / Custom ROMs)
You can flash custom ROMs (like LineageOS or Pixel Experience) to completely replace Motorola's system:

1. Download the ARM64 GSI `.img` file matching your preference.
2. Reboot your phone into **fastbootd** mode:
   ```bash
   adb reboot fastboot
   ```
3. Erase the current system partition:
   ```bash
   fastboot erase system
   ```
4. Flash the custom GSI system image:
   ```bash
   fastboot flash system GSI_IMAGE_NAME.img
   ```
5. Perform a factory reset (mandatory) in Fastboot:
   ```bash
   fastboot -w
   ```
6. Reboot to system:
   ```bash
   fastboot reboot
   ```
