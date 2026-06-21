# Custom Bootloader (Kaeru) Setup & Abilities

Your Motorola G24 (codename `fogorow`) uses a custom bootloader module (often based on `kaeru` or `chouchou`) to bypass standard restriction checks. This guide explains what the custom bootloader is, why it is essential, and how it is configured.

---

## 1. What is the Custom Bootloader?
On the Motorola G24, the stock bootloader (`lk.img` / Little Kernel) performs strict signature verification of your system, product, vendor, and boot partitions. 

The custom bootloader is a modified `lk` binary compiled to:
* **Disable Android Verified Boot (AVB 2.0)**: Bypasses cryptographic verification of partition integrity.
* **Enable Custom Partition Signature Loading**: Allows the processor to load modified partition files (such as a rooted `boot.img` or custom ROMs).
* **Provide Brick Protection**: Blocks standard `fastboot flashing lock` commands to prevent you from locking the bootloader with unverified partitions (which causes an irreversible hard-brick).

---

## 2. Why Do I Need It?
Without this custom bootloader, any attempt to run a rooted kernel, modify system directories, or flash custom files will trigger the processor's secure boot key check, causing:
1. An immediate bootloop.
2. A red "Red State" verification warning screen.
3. A locked secure boot system that refuses to boot unless completely factory reflashed.

The custom bootloader is the foundation that enables Zygisk, LSPosed, Magisk modules, custom recovery images, and Generic System Image (GSI) custom ROMs to run on your G24.

---

## 3. Initial Setup & Installation
If you are performing a clean install, the custom bootloader is flashed via Fastboot:

1. **Unlock the OEM Bootloader**:
   * Enable *Developer Options* by tapping *Build Number* 7 times in Settings.
   * Toggle **OEM Unlocking** and **USB Debugging** to ON.
   * Reboot to Fastboot: `adb reboot bootloader`.
   * Run the unlock command: `fastboot flashing unlock` (this wipes all user data).

2. **Flash the Custom Bootloader Partition**:
   * Flash the custom `lk` binary to both bootloader slots:
     ```bash
     fastboot flash bootloader lk.img
     fastboot flash lk lk.img
     ```
   * *Note: Flash to both slots to ensure boot stability during OTA updates or slot switches.*

---

## 4. Unlocked Abilities & Features
Once the custom bootloader is active, your Motorola G24 gains these capabilities:

* **Direct Fastbootd Access**: Type `fastboot reboot fastboot` to enter user-space fastbootd mode, allowing you to resize and flash the G24's dynamic partitions (like `system` or `product`).
* **Root Injection**: You can patch your G24's boot image via Magisk or APatch and flash it directly (`fastboot flash boot patched_boot.img`) without boot errors.
* **GSI ROM Compatibility**: Allows you to flash dynamic ROMs (like Pixel Experience or LineageOS) directly over the stock Motorola system partition.
