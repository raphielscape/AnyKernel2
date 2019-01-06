#!/system/bin/sh
# Copyright (C) 2018 Raphielscape LLC.
# SPDX-License-Identifier: GPL-3.0-or-later
#
# Bash additional script file for Kat Kernel
#
# DO NOT MODIFY THIS FILE

write() {
    echo "$2" > "$1"
}

copy() {
    cat "$1" > "$2"
}

delett() {
    rm -rf "$1"
}

{
write /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor "schedutil"
write /sys/devices/system/cpu/cpufreq/policy0/schedutil/up_rate_limit_us 500
write /sys/devices/system/cpu/cpufreq/policy0/schedutil/down_rate_limit_us 20000
write /sys/devices/system/cpu/cpufreq/policy0/schedutil/pl 0
write /sys/devices/system/cpu/cpufreq/policy0/schedutil/hispeed_freq 0
 
write /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor "schedutil"
write /sys/devices/system/cpu/cpufreq/policy4/schedutil/up_rate_limit_us 500
write /sys/devices/system/cpu/cpufreq/policy4/schedutil/down_rate_limit_us 20000
write /sys/devices/system/cpu/cpufreq/policy4/schedutil/pl 0
write /sys/devices/system/cpu/cpufreq/policy4/schedutil/hispeed_freq 0

# Input boost and stune configuration
write /sys/module/cpu_boost/parameters/input_boost_freq "0:1056000 1:0 2:0 3:0 4:0 5:0 6:0 7:0"
write /sys/module/cpu_boost/parameters/input_boost_ms 600
write /sys/module/cpu_boost/parameters/dynamic_stune_boost 15

# Disable Boost_No_Override
write /dev/stune/foreground/schedtune.sched_boost_no_override 0
write /dev/stune/top-app/schedtune.sched_boost_no_override 0

# Set default schedTune value for foreground/top-app
write /dev/stune/foreground/schedtune.prefer_idle 1
write /dev/stune/top-app/schedtune.boost 1
write /dev/stune/top-app/schedtune.prefer_idle 1

# Enable PEWQ
write /sys/module/workqueue/parameters/power_efficient Y

# Disable Touchboost
write /sys/module/msm_performance/parameters/touchboost 0

# Adjust SCHED Features
write /sys/kernel/debug/sched_features NO_EAS_USE_NEED_IDLE
write /sys/kernel/debug/sched_features TTWU_QUEUE

# Disable CAF task placement for Big Cores
write /proc/sys/kernel/sched_walt_rotate_big_tasks 0

# Disable Autogrouping
write /proc/sys/kernel/sched_autogroup_enabled 0

# Setup EAS cpusets values for better load balancing
write /dev/cpuset/top-app/cpus 0-7
# Since we are not using core rotator, lets load balance
write /dev/cpuset/foreground/cpus 0-3,6-7
write /dev/cpuset/background/cpus 0-1
write /dev/cpuset/system-background/cpus 0-3

# For better screen off idle
write /dev/cpuset/restricted/cpus 0-3
}&