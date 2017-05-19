#!/usr/bin/env bash
source setup_utils.sh.inc

function main
{
    local install_prefix="mcsema_binaries"

    CompileMcSema "${install_prefix}"
    if [ $? -ne 0 ] ; then
        printf "McSema could not be compiled. Aborting...\n"
        return 1
    fi

    InstallMcSema
    if [ $? -ne 0 ] ; then
        printf "McSema could not be installed. Aborting...\n"
        return 1
    fi

    MCSEMA_INSTALL_PREFIX="${install_prefix}" python2 tests/integration_test.py

    return 0
}

main $@
exit $?

