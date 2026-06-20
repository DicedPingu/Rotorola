# rooted G24 - Safety Warnings & Disclaimers

Modifying your device bootloader and system partitions carries inherent risks. Here is what you need to know to avoid bootloops and bricks:

---

## ⚠️ Critical Disclaimers

### 1. NEVER Relock the Bootloader with Custom Partitioning
* **The Risk**: If you flash a custom bootloader (`kaeru`/`chouchou`), custom kernels, or GSIs, and run `fastboot flashing lock`, you will **permanently hard-brick the device**. The phone's secure boot key check will fail, and it will refuse to load any partitions, leaving you unable to even access Fastboot mode.
* **Bypass Protection**: The custom `kaeru` bootloader we flashed has a built-in safety net that blocks `fastboot flashing lock` commands automatically to protect you, but never try to bypass this safety check.

### 2. Do Not Flash Stock `lk` (Bootloader) Directly
* **The Risk**: If you download a stock firmware package and flash the official `lk.img` over your custom bootloader, it will immediately lock the bootloader. If your phone contains any modified files (such as a rooted `boot.img` or a custom recovery), it will refuse to boot and trigger a soft-brick.

### 3. Handle OTA Updates Carefully
* **The Risk**: Official over-the-air (OTA) updates require completely unmodified system and boot partitions to check integrity. Running an OTA update on a rooted device will fail at best, or cause a bootloop at worst.

---

## 🛠️ Recovery Checklist (If you get stuck)

If the device gets stuck in a bootloop:

1. **Recovery Mode**: Hold **Power + Volume Up** to enter Recovery Mode and perform a factory reset.
2. **Fastbootd Mode**: Hold **Power + Volume Down** to enter Fastboot. You can flash the stock `boot.img` and `lk.img` backups we saved in `/home/dicedpingu/SPQR/rotorola/backups/` to restore the phone to its original, unrooted state:
   ```bash
   fastboot flash boot boot.img
   fastboot flash bootloader lk.img
   ```
3. **Rescue and Smart Assistant (RSA)**: Download Motorola's official RSA software on a Windows PC to force re-flash your factory ROM over USB if you cannot boot at all.
