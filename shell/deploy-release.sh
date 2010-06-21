#! /bin/bash

[ -z "$1" ] && exit -1

export PATH="$PWD/$(dirname $0):$PATH"

cd "$1" || exit -1

source deploy.inc.sh

keyfile=../release.ks.pw

preDeploy.sh
ant clean
ant debug || exit -1
ant release < ${keyfile} 
adb -d install -r bin/*-debug.apk || adb -d install -r bin/*-release.apk

mv bin/*-release.apk bin/${fname}-${pversion}.apk

[ -n "${gproject}" ] && \
googlecode_upload.py -u ${gcodelogin} -w ${gcodepassw} -p ${gproject}  -s "${sname}-${pversion}"  -l Featured,Type-Package,OpSys-Android${lextra}  bin/${fname}-${pversion}.apk

postDeploy.sh