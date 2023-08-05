# ESPHome Device Configuration

## KMC Smart Tap

Flashing can be done with another computer and OS version, but this is what _eventually_ worked for me.

### Steps to flash using a Raspberry Pi

0. In ESPHome, create a device based on the package `packages/kmc-smart-outlet.yaml` in this repository. Compile and download the firmware binary.
1. Install the [last Raspberry Pi OS based on Debian Buster](http://downloads.raspberrypi.org/raspios_armhf/images/raspios_armhf-2021-05-28/2021-05-07-raspios-buster-armhf.zip).
2. Don't update the packages/system.
3. Download/clone [tuya-convert](https://github.com/ct-Open-Source/tuya-convert).
4. Optionally, in `scripts/hostapd.conf`, update `channel` to a less congested channel such as `6`.
5. Copy the ESPHome firmware bin to `/files`.
6. Run `./install_prereq.sh`.
7. Run `./start_flash.sh`.
8. Respond `yes`/`y` to the prompts.
9. Connect to the WiFi network `vtrust-flash` from a computer or phone. There is a captive portal that needs to be exited on iOS/macOS for the device to connect.
10. Plug in the outlet then hold down the power button for five seconds until the button starts blinking fast at a regular interval.
11. Press enter.
12. Wait for the script to run. If successful, it will prompt to install the firmware.
13. Select the firmware file that was copied to `/files`.
14. Wait for the firmware to install. If successful, the outlet will reboot and connect to the ESPHome dashboard.
