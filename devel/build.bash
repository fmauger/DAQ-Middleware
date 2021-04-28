#!/usr/bin/env bash

sourceDir=$(pwd)
buildDir=${sourceDir}/_build.d
installDir=${sourceDir}/_install.d

doTests=false
doBuildExamples=false
useRoot=true
rootDir=

function app_exit()
{
    local error_code=0
    if [ -n "$1" ]; then
	error_code=$1
	shift 1
    fi
    local error_msg="$@"
    if [ -n "${error_msg}" ]; then
	echo >&2 "[error] ${error_msg}"
    fi
    exit ${error_code}
}

while [ -n "$1" ]; do
    opt="$1"
    shift 1
    if [ "${opt}" == "--tests" -o "${opt}" == "-T" ]; then
	doTests=true
    elif [ "${opt}" == "--build-examples" -o "${opt}" == "-E" ]; then
	doBuildExamples=true
    elif [ "${opt}" == "--no-root" -o "${opt}" == "-R" ]; then
	useRoot=false
    fi
done

echo >&2 "[info] sourceDir  = '${sourceDir}'"
echo >&2 "[info] buildDir   = '${buildDir}'"
echo >&2 "[info] installDir = '${installDir}'"
echo >&2 "[info] doTests    = ${doTests}"
echo >&2 "[info] useRoot    = ${useRoot}"

if [ ! -d ${buildDir} ]; then
    mkdir -p ${buildDir}
fi

if [ ${useRoot} = true ]; then
    which root-config > /dev/null 2>&1
    if [ $? -ne 0 ]; then
	echo >&2 "[warning] Cannot find ROOT!"
	useRoot=false
    else
	rootDir="$(root-config --prefix)/share/root/cmake"
	if [ ! -d ${rootDir}  ]; then
	    app_exit 1 "ROOT CMake config directory '${rootDir}' does not exist!"
	fi
    fi
fi


buildExamplesOptions="-DDAQMW_BUILD_EXAMPLES:BOOL=OFF"
if [ ${doBuildExamples} == true ]; then
   buildExamplesOptions="-DDAQMW_BUILD_EXAMPLES:BOOL=ON" 
fi

testOptions="-DDAQMW_ENABLE_TESTING:BOOL=OFF"
if [ ${doTests} == true ]; then
   testOptions="-DDAQMW_ENABLE_TESTING:BOOL=ON" 
fi

rootOptions=
if [ ${useRoot} == true ]; then
   rootOptions="-DROOT_DIR:PATH=${rootDir}" 
fi
echo >&2 "[info] useRoot    = ${useRoot}"
echo >&2 "[info] rootDir    = ${rootDir}"

which rtm-config >/dev/null 2>&1
if [ $? -ne 0 ]; then
    app_exit 1 "Missing 'rtm-config'! Please setup OpenRTM-aist!"
fi
# orbPrefix=$(rtm-config --prefix)
# orbOptions="-DORB_ROOT=${orbPrefix}"
openRTMDir="$(rtm-config --libdir)/cmake"
openRTMOptions="-DOpenRTM_DIR:PATH=${openRTMDir}"

cd ${buildDir}
cmake \
    -DCMAKE_INSTALL_PREFIX=${installDir} \
    ${testOptions} \
    ${buildExamplesOptions} \
    ${openRTMOptions} \
    ${rootOptions} \
    ${sourceDir}
if [ $? -ne 0 ]; then
    app_exit 1 "CMake configuration failure!"
fi

make -j4
if [ $? -ne 0 ]; then
    app_exit 1 "Build failure!"
fi

make test
if [ $? -ne 0 ]; then
    app_exit 1 "Some tests failed!"
fi

make install
if [ $? -ne 0 ]; then
    app_exit 1 "Installation failure!"
fi

app_exit
