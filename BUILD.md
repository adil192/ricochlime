# <img src="assets/icon/icon.png" width="30" height="30" alt="" aria-hidden="true"> Building Ricochlime

### Pre-requisites
1. Install Flutter, either:

   i. Manually, by following the official instructions at https://flutter.dev/docs/get-started/install, or;

   ii. Automatically on Linux, using my script ([source](https://github.com/adil192/adil192-linux/blob/main/bootstrap/install_flutter.sh)):

      ```bash
      curl -s https://raw.githubusercontent.com/adil192/adil192-linux/main/bootstrap/install_flutter.sh | bash
      ```

      (Always use caution when running scripts from the internet including this one. This script should be fairly easy to understand if you're familiar with linux, but if you're unsure, follow the official instructions instead.)
2. For Linux, you'll also need these dependencies:

   Ubuntu:
   ```bash
   sudo apt install libasound2-dev
   ```
   Fedora:
   ```bash
   sudo dnf install alsa-lib-devel
   ```

### Patches

| Patch | Description |
| --- | --- |
| `./patches/foss.sh` | Removes proprietary dependencies, resulting in a fully free and open source build |
| `./patches/remove_dev_dependencies.sh` | Removes dependencies not needed in production, reducing build size |

I recommend running `./patches/remove_dev_dependencies.sh` so your build doesn't contain unused code and assets.

### Build

Run the relevant Flutter command for your target platform:
e.g. `flutter build linux` or `flutter build apk`.
