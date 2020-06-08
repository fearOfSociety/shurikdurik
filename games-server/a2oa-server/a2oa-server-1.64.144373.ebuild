# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit games systemd

PATCH_P="${P}.tar.bz2"
DESCRIPTION="ARMA 2 OA - Linux Server"
HOMEPAGE="http://community.bistudio.com/wiki/ArmA:_Dedicated_Server"
SRC_URI="
	https://www.dropbox.com/s/ocq6m3afsi7oc34/${PATCH_P}
	https://dl.dropbox.com/u/18463425/a2oa/${PATCH_P}
	https://www.arma2.com/downloads/update/${PATCH_P}
	https://downloads.bistudio.com/arma2.com/update/${PATCH_P}
	ftp://downloads.bistudio.com/arma2.com/update/${PATCH_P}
	https://www.dropbox.com/s/1by4asvkbx1ejxp/${PATCH_P}
"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror strip"

RDEPEND="
	sys-libs/glibc
	sys-libs/zlib
	amd64? (
		|| ( app-emulation/emul-linux-x86-baselibs sys-libs/zlib[abi_x86_32] )
		sys-libs/glibc[multilib]
	)
"

GAMES_USER_DED=arma2
dir=${GAMES_PREFIX_OPT}/${PN}
QA_PREBUILT="${dir}"/arma2oaserver

S=${WORKDIR}

src_prepare() {
	mv arma2oaserver arma2oaserver-daemon-bad.txt
	mv server arma2oaserver
	rm -f tolower.c install
}

src_install() {
	insinto "${dir}"
	doins -r *
	fperms +x "${dir}"/arma2oaserver

	doins -r "${FILESDIR}"/${PN}_tolower.sh
	fperms +x "${dir}"/${PN}_tolower.sh

	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service

	prepgamesdirs

	fowners -R ${GAMES_USER_DED} "${dir}"
}

pkg_postinst() {
	ewarn "Update BattlEye"
	ewarn "wget https://www.battleye.com/downloads/arma2oa/beserver.so -O ${dir}/expansion/battleye/beserver.so"
}
