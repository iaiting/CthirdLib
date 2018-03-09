#!/usr/bin/env bash

################################################################################
OpenSSL_SRCDIR="../OpenSSL"
OpenSSL32_OBJDIR="./OpenSSL32"


#******************************************************************************#
GmSSL_SRCDIR="../GmSSL"
GmSSL32_OBJDIR="./GmSSL32"

################################################################################
function lib_sync() {
    if [ $# -ne 2 ]; then
       return 1
    fi

    typeset srcdir=$1
    typeset objdir=$2

    if [ ! -e ${objdir} ]; then
	mkdir ${objdir}
    fi

    cp ${srcdir}/libcrypto.lib ${objdir}/
    cp ${srcdir}/libssl.lib ${objdir}/


    cp ${srcdir}/libcrypto*.dll ${objdir}/
    cp ${srcdir}/libssl*.dll ${objdir}/

    cp ${srcdir}/libcrypto*.pdb ${objdir}/
    cp ${srcdir}/libssl*.pdb ${objdir}/
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
    
    
    cp -rf ${srcdir}/include/openssl ${objdir}/include/
}


################################################################################
function sync() {
    typeset srcdir=$1
    typeset objdir=$2
    
    
    lib_sync ${srcdir} ${objdir}
    if [ $? -ne 0 ]; then
	return 1
    fi

    headfile_sync ${srcdir} ${objdir}
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
function main() {
    OpenSSL32_sync
    if [ $? -ne 0 ]; then
	return 1
    fi
    
    GmSSL32_sync
    if [ $? -ne 0 ]; then
	return 1
    fi
}


################################################################################
main "$@"
    

