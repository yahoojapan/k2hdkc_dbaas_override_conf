#!/bin/sh
#
# K2HDKC DBaaS Utilities - Override configuration for K2HDKC DBaaS
#
# Copyright 2021 Yahoo! Japan Corporation.
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
MYSCRIPTDIR=$(dirname "$0")
SRCTOP=$(cd "${MYSCRIPTDIR}/.."; pwd)

#
# Check options
#
TARGET_TYPE=""
while [ $# -ne 0 ]; do
	if [ "X$1" = "X" ]; then
		break;

	elif [ "X$1" = "X-h" -o "X$1" = "X-H" -o "X$1" = "X--help" -o "X$1" = "X--HELP" ]; then
		func_usage "${PRGNAME}"
		exit 0

	elif [ "X$1" = "Xdeb" -o "X$1" = "XDEB" -o "X$1" = "Xdebian" -o "X$1" = "XDEBIAN" ]; then
		if [ "X${TARGET_TYPE}" != "X" ]; then
			echo "[ERROR] rpm or deb option is already specified."
		fi
		TARGET_TYPE="deb"

	elif [ "X$1" = "Xrpm" -o "X$1" = "XRPM" ]; then
		if [ "X${TARGET_TYPE}" != "X" ]; then
			echo "[ERROR] rpm or deb option is already specified."
		fi
		TARGET_TYPE="rpm"

	else
		echo "[ERROR] Unknown option($1) is specified."
	fi
	shift
done
if [ "X${TARGET_TYPE}" = "X" ]; then
	echo "[ERROR] rpm or deb option must be specified."
	exit 1
fi

#
# Script body
#
_SCRIPT_BODY=$(cat<<EOS
if [ -d /etc/antpickax -a -f /etc/antpickax/k2hr3-api-uri -a -f /etc/antpickax/k2hr3-role-name -a -f /etc/antpickax/k2hr3-role-name -a -f /etc/antpickax/k2hr3-cuk-param ]; then
	K2HR3_URI=\$(cat /etc/antpickax/k2hr3-api-uri)
	K2HR3_ROLE=\$(cat /etc/antpickax/k2hr3-role-name)
	K2HR3_RESOURCE=\$(cat /etc/antpickax/k2hr3-role-name | sed 's/:role:/:resource:/g')
	K2HR3_CUK=\$(cat /etc/antpickax/k2hr3-cuk-param)
	K2HDKC_PROC_USER="k2hdkc"
	K2HR3_RESULT=\$(curl -s -X GET -H 'Content-Type: application/json' "\${K2HR3_URI}"/v1/resource/"\${K2HR3_RESOURCE}"?"\${K2HR3_CUK}"\&role="\${K2HR3_ROLE}"\&type=keys\&keyname=k2hdkc-dbaas-proc-user)
	echo "\${K2HR3_RESULT}" | grep -q '"result":true'
	if [ \$? -eq 0 ]; then
		K2HDKC_PROC_USER=\$(echo "\${K2HR3_RESULT}" | sed 's/^.*\"resource\":\"\([^\"]*\)*\".*\$/\1/g' | grep -v "[^a-zA-Z0-9_]")
		if [ "X\${K2HDKC_PROC_USER}" != "X" ]; then
			sed -i -e "s/chmpx-service-helper.conf:SUBPROCESS_USER[[:space:]]*=.*\$/chmpx-service-helper.conf:SUBPROCESS_USER\t\t= \${K2HDKC_PROC_USER}/g" -e "s/k2hdkc-service-helper.conf:SUBPROCESS_USER[[:space:]]*=.*\$/k2hdkc-service-helper.conf:SUBPROCESS_USER\t\t= \${K2HDKC_PROC_USER}/g" /etc/antpickax/override.conf
		else
			K2HDKC_PROC_USER="k2hdkc"
		fi
	fi
	K2HR3_RESULT=\$(curl -s -X GET -H 'Content-Type: application/json' "\${K2HR3_URI}"/v1/resource/"\${K2HR3_RESOURCE}"?"\${K2HR3_CUK}"\&role="\${K2HR3_ROLE}"\&type=keys\&keyname=k2hdkc-dbaas-add-user)
	echo "\${K2HR3_RESULT}" | grep -q '"result":true'
	if [ \$? -eq 0 ]; then
		K2HDKC_ADD_USER=\$(echo "\${K2HR3_RESULT}" | sed 's/^.*\"resource\":\(.*\)}.*\$/\1/g')
		if [ "X\${K2HDKC_ADD_USER}" = "X1" ]; then
			id -u "\${K2HDKC_PROC_USER}" >/dev/null 2>&1
			if [ \$? -ne 0 ]; then
				grep -q "^\${K2HDKC_PROC_USER}:" /etc/group
				if [ \$? -ne 0 ]; then
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
if [ "X${TARGET_TYPE}" = "Xdeb" ]; then
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
