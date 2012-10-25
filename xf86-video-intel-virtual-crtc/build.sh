#!/bin/bash

# Written by: Xiao-Long Chen <chenxiaolong@cxl.epac.to>

PATCH=xserver-xorg-video-intel-2.20.10_virtual_crtc.patch

if [ -d xf86-video-intel ]; then
  rm -rvf xf86-video-intel
fi

cp -rv /var/abs/extra/xf86-video-intel .
cd xf86-video-intel
cp ../${PATCH} .

sed -i 's/^\(pkgname=\).*$/\1xf86-video-intel-virtual-crtc/' PKGBUILD
sed -i 's/${*pkgname}*/xf86-video-intel/' PKGBUILD
sed -i "/.\/configure/ i patch -Np1 -i \"\${srcdir}/${PATCH}\"" PKGBUILD
cat >> PKGBUILD << EOF
provides+=("xf86-video-intel=\$pkgver")
conflicts+=('xf86-video-intel')
source+=('${PATCH}')
EOF

makepkg -g >> PKGBUILD

makepkg -si

rm -rvf xf86-video-intel
