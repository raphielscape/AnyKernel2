#!/system/bin/sh
# Copyright (C) 2018 Raphielscape LLC.
# SPDX-License-Identifier: GPL-3.0-or-later
#
# Bash additional script file for Kat Kernel
#
# DO NOT MODIFY THIS FILE

function write() {
    echo -n $2 > $1
}

function copy() {
    cat $1 > $2
}

function get-set-forall() {
    for f in $1 ; do
        cat $f
        write $f $2
    done
}

function delett {
    rm -rf $1
}

{

# devfreq tuning
# Qualcomm is using obscure directory for devfreq, so follow up
restorecon -R /sys/class/devfreq/*qcom,cpubw*
get-set-forall /sys/class/devfreq/*qcom,mincpubw*/governor cpufreq
}&
