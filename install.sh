#!/data/data/com.termux/files/usr/bin/sh
# 
# Helper script to install & setup flutter
# using debian as prooted environment
#
# Only for ARM64/AARCH64 
#
#########################################

FLUTTER_VERSION="2.16.0"

ANDROID_SDK_INSTALLATION_GUIDE="https://www.hax4us.com/2021/11/install-android-sdk-in-termux.html?m=1"
TELEGRAM_JOIN_LINK="https://t.me/hax4us_group"

msg() {
    echo -e "[*] $@"
}

error_msg() {
    echo -e "[!] $@" >&2
}

check_deps() {
    pkgs=("proot-distro" "curl" "git" "unzip" "termux-tools")

    for pkg in pkgs; do
        if [ -z $(command -v ${pkg}) ]; then
            msg "Installing ${pkg}"
            apt install ${pkg} > /dev/null 2>&1
        fi
    done
}

is_android_sdk_installed() {
    if [ ! -d ${PREFIX}/share/android-sdk ]; then
        error_msg "Missing android sdk\nRedirecting you to installation guide and then you can run this script again. "
        termux-open-url ${ANDROID_SDK_INSTALLATION_GUIDE}
        exit 1
    fi
}

install_debian() {
    proot-distro install debian --override-alias flutter
}

install_flutter() {
    proot-distro login flutter -- curl -O https://github.com/Hax4us/flutter_in_termux/releases/download/v${FLUTTER_VERSION}/Flutter-ARM64.zip 
    proot-distro login flutter -- curl -O https://github.com/Hax4us/flutter_in_termux/releases/download/v${FLUTTER_VERSION}/gen_snapshot.zip
    proot-distro login flutter -- unzip Flutter-ARM64.zip 
    proot-distro login flutter -- unzip gen_snapshot.zip
    proot-distro login flutter -- sed -i 's#export PATH=.*#&:~/flutter/bin#g' /etc/profile.d/termux-proot.sh
    proot-distro login flutter -- mkdir -p /root/flutter/bin/cache/artifacts/engine/android-arm64-release/linux-arm64
    proot-distro login flutter -- mv gen_snapshot /root/flutter/bin/cache/artifacts/engine/android-arm64-release/linux-arm64/
    proot-distro login flutter -- flutter doctor
    proot-distro login flutter -- flutter config --android-sdk $PREFIX/share/android-sdk
}

post_install_msg() {
    msg "Everything was fine but still in any case of error/doubt you can ask on Telegram"
    msg 
    msg "Want to join us on Telegram ? [y/n]"

    read choice

    if [ "${choice}" = "y"  ] || [ "${choice}" = "Y"  ]; then
        termux-open-url ${TELEGRAM_JOIN_LINK}
    fi
}

########################
# 
# MAIN 
#
########################

check_deps
is_android_sdk_installed
install_debian
install_flutter
post_install_msg

