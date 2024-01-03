# ESPHome Device Configuration

This uses ESPHome [packages](https://esphome.io/guides/configuration-types#packages) and [sharing](https://esphome.io/guides/creators).

## Home Assistant ESPHome Add-on

_Note: This only applies to ESPHome installations via the [Home Assistant ESPHome Add-on](https://esphome.io/guides/getting_started_hassio)._

When there are remote package updates, ESPHome should detect them and update the local files. However, this doesn't seem to work. Previously the workaround was to delete the local checked out files at `/config/esphome/build/packages` available in Home Assistant add-ons such as [Studio Code Server](https://github.com/hassio-addons/addon-vscode), [Terminal & SSH](https://github.com/home-assistant/addons/tree/master/ssh), etc.

Starting with ESPHome version [2023.9.0](https://github.com/esphome/home-assistant-addon/releases/tag/2023.9.0) which contains this [pull-request](https://github.com/esphome/esphome/pull/5374), the `build` directory is no longer in the Home Assistant `/config/esphome` directory. [There does not seem to be the desire to change this](https://github.com/esphome/issues/issues/4951). [There is a pull-request](https://github.com/esphome/esphome/pull/5443) to fully delete the `build` directory when cleaning an ESPHome config, but for some reason it isn't merged.

To get access to the "new" location which only the ESPHome add-on has access to, you can:

1. Install the [Advanced SSH & Web Terminal]() add-on.
2. Disable "Protection mode" from the add-on's "Info" tab which enables access to the `docker` command.
3. Get the ESPHome add-on's container name with `docker ps`.
4. Get shell access to the ESPHome add-on with `docker exec -it <esphome_container_name> bash`.
5. Delete the remote package directory with `rm /data/packages/<package_sha>`.

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

## Sonoff S31

1. [Disassembly and flashing instructions](https://alfter.us/2021/12/12/using-the-sonoff-s31-with-esphome-first-time-flash/)
