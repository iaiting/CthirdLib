#!/usr/bin/env bash

#******************************************************************************#
OpenSSL_SRCDIR="../OpenSSL"
OpenSSL32_OBJDIR="./OpenSSL32"

#******************************************************************************#
GmSSL_SRCDIR="../GmSSL"
GmSSL32_OBJDIR="./GmSSL32"

#******************************************************************************#
TaSSL_SRCDIR="../TaSSL"
TaSSL32_OBJDIR="./TaSSL32"

#******************************************************************************#
function lib_sync() {
    if [ $# -ne 2 ]; then
       return 1
    fi

    typeset srcdir=$1
    typeset objdir=$2

    if [ ! -e ${objdir} ]; then
	mkdir ${objdir}
    fi

    cp ${srcdir}/libcrypto*.lib ${objdir}/  1>/dev/null 2>&1
    if [ $? -ne 0 ]; then
	cp ${srcdir}/libeay*.lib ${objdir}/
    fi

    cp ${srcdir}/libcrypto*.dll ${objdir}/  1>/dev/null 2>&1
    if [ $? -ne 0 ]; then
	cp ${srcdir}/libeay*.dll ${objdir}/
    fi
    
    cp ${srcdir}/libcrypto*.pdb ${objdir}/  1>/dev/null 2>&1
    if [ $? -ne 0 ]; then
	cp ${srcdir}/libeay*.pdb ${objdir}/
    fi
    
    cp ${srcdir}/*ssl*.lib ${objdir}/
    cp ${srcdir}/*ssl*.dll ${objdir}/
    cp ${srcdir}/*ssl*.pdb ${objdir}/
}


################################################################################
function headfile_sync() {
    if [ $# -ne 2 ]; then
       return 1
    fi

    typeset srcdir=$1
    typeset objdir=$2
    
    if [ ! -e ${objdir}/include ]; then
	mkdir ${objdir}/include
    fi
    
    cp -rf ${srcdir}/openssl ${objdir}/include/
    if [ -e ${srcdir}/internal ]; then
    	cp -rf ${srcdir}/internal ${objdir}/include/
    fi
}


################################################################################
function sync() {
    typeset srcdir=$1
    typeset objdir=$2
    
    
    lib_sync ${srcdir} ${objdir}
    if [ $? -ne 0 ]; then
	return 1
    fi

    headfile_sync ${srcdir}/include ${objdir}
    if [ $? -ne 0 ]; then
	return 1
    fi

    return 0
}


################################################################################
function OpenSSL32_sync() {
    echo "Start syncing OpenSSL32: ${OpenSSL_SRCDIR} -> ${OpenSSL32_OBJDIR} ..."

    sync ${OpenSSL_SRCDIR} ${OpenSSL32_OBJDIR}
    if [ $? -ne 0 ]; then
	return 1
    fi

    echo "Syncing OpenSSL32 finish ."
    
    return 0
}


################################################################################
function GmSSL32_sync() {
    echo "Start syncing GmSSL32: ${GmSSL_SRCDIR} -> ${GmSSL32_OBJDIR} ..."

    sync ${GmSSL_SRCDIR} ${GmSSL32_OBJDIR}
    if [ $? -ne 0 ]; then
	return 1
    fi
    
    echo "Syncing GmSSL32 finish ."
    
    return 0
}


################################################################################
function TaSSL32_sync() {
    echo "Start syncing TaSSL32: ${TaSSL_SRCDIR} -> ${TaSSL32_OBJDIR} ..."

    lib_sync ${TaSSL_SRCDIR}/out32dll ${TaSSL32_OBJDIR}
    if [ $? -ne 0 ]; then
	return 1
    fi

    headfile_sync ${TaSSL_SRCDIR}/inc32 ${TaSSL32_OBJDIR}
    if [ $? -ne 0 ]; then
	return 1
    fi


    if [ $? -ne 0 ]; then
	return 1
    fi
    
    echo "Syncing TaSSL32 finish ."
    
    return 0
}


################################################################################
function main() {
    OpenSSL32_sync
    if [ $? -ne 0 ]; then
	return 1
    fi
    
    GmSSL32_sync
    if [ $? -ne 0 ]; then
	return 1
    fi

    TaSSL32_sync
    if [ $? -ne 0 ]; then
	return 1
    fi
}


################################################################################
main "$@"

