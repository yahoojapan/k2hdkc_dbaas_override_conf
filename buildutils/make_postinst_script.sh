#!/bin/sh
#
# K2HDKC DBaaS Utilities - Override configuration for K2HDKC DBaaS
#
# Copyright 2021 Yahoo Japan Corporation.
#
# K2HDKC DBaaS is a DataBase as a Service provided by Yahoo! JAPAN
# which is built K2HR3 as a backend and provides services in
# cooperation with OpenStack.
# The Override configuration for K2HDKC DBaaS serves to connect the
# components that make up the K2HDKC DBaaS. K2HDKC, K2HR3, CHMPX,
# and K2HASH are components provided as AntPickax.
#
# For the full copyright and license information, please view
# the license file that was distributed with this source code.
#
# AUTHOR:   Takeshi Nakatani
# CREATE:   Fri May 12 2021
# REVISION:
#

#
# Return post install script common body data
#
func_usage()
{
	echo ""
	echo "Usage:  $1 [rpm|deb] [--help(-h)]"
	echo "	[rpm|deb]    for rpm package or debian package"
	echo "	--help(-h)   print help."
	echo ""
}

#
# Common variables
#
PRGNAME=$(basename "$0")
#SCRIPTDIR=$(dirname "$0")
#SRCTOP=$(cd "${SCRIPTDIR}/.."; pwd)

#
# Check options
#
TARGET_TYPE=""
while [ $# -ne 0 ]; do
	if [ -z "$1" ]; then
		break;

	elif [ "$1" = "-h" ] || [ "$1" = "-H" ] || [ "$1" = "--help" ] || [ "$1" = "--HELP" ]; then
		func_usage "${PRGNAME}"
		exit 0

	elif [ "$1" = "deb" ] || [ "$1" = "DEB" ] || [ "$1" = "debian" ] || [ "$1" = "DEBIAN" ]; then
		if [ -n "${TARGET_TYPE}" ]; then
			echo "[ERROR] rpm or deb option is already specified."
		fi
		TARGET_TYPE="deb"

	elif [ "$1" = "rpm" ] || [ "$1" = "RPM" ]; then
		if [ -n "${TARGET_TYPE}" ]; then
			echo "[ERROR] rpm or deb option is already specified."
		fi
		TARGET_TYPE="rpm"

	else
		echo "[ERROR] Unknown option($1) is specified."
	fi
	shift
done
if [ -z "${TARGET_TYPE}" ]; then
	echo "[ERROR] rpm or deb option must be specified."
	exit 1
fi

#
# Script body
#
_SCRIPT_BODY=$(cat<<EOS
if [ -d /etc/antpickax ] && [ -f /etc/antpickax/k2hr3-api-uri ] && [ -f /etc/antpickax/k2hr3-role-name ] && [ -f /etc/antpickax/k2hr3-role-name ] && [ -f /etc/antpickax/k2hr3-cuk-param ]; then
	K2HR3_URI=\$(cat /etc/antpickax/k2hr3-api-uri)
	K2HR3_ROLE=\$(cat /etc/antpickax/k2hr3-role-name)
	K2HR3_RESOURCE=\$(sed -e 's/:role:/:resource:/g' /etc/antpickax/k2hr3-role-name)
	K2HR3_CUK=\$(cat /etc/antpickax/k2hr3-cuk-param)
	K2HDKC_PROC_USER="k2hdkc"
	K2HR3_RESULT=\$(curl -s -X GET -H 'Content-Type: application/json' "\${K2HR3_URI}"/v1/resource/"\${K2HR3_RESOURCE}"?"\${K2HR3_CUK}"\&role="\${K2HR3_ROLE}"\&type=keys\&keyname=k2hdkc-dbaas-proc-user)
	if ! echo "\${K2HR3_RESULT}" | grep -q '"result":true'; then
		K2HDKC_PROC_USER=\$(echo "\${K2HR3_RESULT}" | sed 's/^.*\"resource\":\"\([^\"]*\)*\".*\$/\1/g' | grep -v "[^a-zA-Z0-9_]")
		if [ -n "\${K2HDKC_PROC_USER}" ]; then
			sed -i -e "s/chmpx-service-helper.conf:SUBPROCESS_USER[[:space:]]*=.*\$/chmpx-service-helper.conf:SUBPROCESS_USER\t\t= \${K2HDKC_PROC_USER}/g" -e "s/k2hdkc-service-helper.conf:SUBPROCESS_USER[[:space:]]*=.*\$/k2hdkc-service-helper.conf:SUBPROCESS_USER\t\t= \${K2HDKC_PROC_USER}/g" /etc/antpickax/override.conf
		else
			K2HDKC_PROC_USER="k2hdkc"
		fi
	fi
	K2HR3_RESULT=\$(curl -s -X GET -H 'Content-Type: application/json' "\${K2HR3_URI}"/v1/resource/"\${K2HR3_RESOURCE}"?"\${K2HR3_CUK}"\&role="\${K2HR3_ROLE}"\&type=keys\&keyname=k2hdkc-dbaas-add-user)
	if ! echo "\${K2HR3_RESULT}" | grep -q '"result":true'; then
		K2HDKC_ADD_USER=\$(echo "\${K2HR3_RESULT}" | sed 's/^.*\"resource\":\(.*\)}.*\$/\1/g')
		if [ -n "\${K2HDKC_ADD_USER}" ] && [ "\${K2HDKC_ADD_USER}" = "1" ]; then
			if ! id -u "\${K2HDKC_PROC_USER}" >/dev/null 2>&1; then
				if ! grep -q "^\${K2HDKC_PROC_USER}:" /etc/group; then
					useradd -s /bin/sh -d /home/"\${K2HDKC_PROC_USER}" -m "\${K2HDKC_PROC_USER}"
				else
					useradd -s /bin/sh -d /home/"\${K2HDKC_PROC_USER}" -m "\${K2HDKC_PROC_USER}" -g "\${K2HDKC_PROC_USER}"
				fi
			fi
		fi
	fi
fi
EOS
)

#
# Main
#
if [ -n "${TARGET_TYPE}" ] && [ "${TARGET_TYPE}" = "deb" ]; then
	/bin/echo "${_SCRIPT_BODY}"
else
	/bin/echo "if [ \"\$1\" -eq 1 ]; then"
	/bin/echo "${_SCRIPT_BODY}" | sed -e 's/^/\t/g' -e 's/\t/    /g'
	/bin/echo "fi"
fi

exit 0

#
# Local variables:
# tab-width: 4
# c-basic-offset: 4
# End:
# vim600: noexpandtab sw=4 ts=4 fdm=marker
# vim<600: noexpandtab sw=4 ts=4
#
