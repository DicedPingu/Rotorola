# rooted G24 - Quick Workarounds Cheatsheet

Here are the workarounds for the two most common side-effects of unlocking and rooting: financial app restrictions and software updates.

---

## 1. Bypassing Banking App & Google Wallet Blocks (Play Integrity Fix)
Because your bootloader is unlocked, apps checking Google's Play Integrity API will fail, causing banking apps, Netflix, or Google Wallet to block you.

### How to Bypass:
1. Open the **Magisk** app.
2. Tap the **Settings icon** (top right) and ensure **Zygisk** is turned ON.
3. Turn ON **Enforce DenyList**.
4. Tap **Configure DenyList** and select the banking apps, Google Play Services, and Google Play Store. Ensure you check all sub-processes for those apps.
5. Download the latest **Play Integrity Fix** Magisk Module `.zip` (by chiteroman on GitHub).
6. In Magisk, go to the **Modules** tab, tap **Install from storage**, select the downloaded `.zip` file, and reboot the phone.

---

## 2. Handling System/Firmware Updates (Manual OTA)
Since automatic OTA updates are blocked on rooted devices, you must update the firmware manually:

### How to Update Safely:
1. Download the new official firmware package matching your region (`RETEU`) from lolinet.
2. Extract the package on your computer.
3. Flash the new firmware components via Fastboot **except** for `lk.img` (to prevent locking).
4. Transfer the new stock `boot.img` to your phone and patch it in the Magisk app.
5. Retrieve the new patched boot image and flash it:
   ```bash
   fastboot flash boot magisk_patched.img
   ```
6. Reboot to system.
