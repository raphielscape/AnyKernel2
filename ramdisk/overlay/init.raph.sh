#!/system/bin/sh

################################################################################
# helper functions to allow Android init like script

write() {
    echo "$2" > "$1"
}

copy() {
    cat "$1" > "$2"
}

# macro to write pids to system-background cpuset
writepid_sbg() {
    until [ ! "$1" ]; do
        echo "$1" > /dev/cpuset/system-background/tasks;
        shift;
    done;
}

################################################################################

{

sleep 10;

# write /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq 2169600;

write /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor "schedutil"
write /sys/devices/system/cpu/cpufreq/policy0/schedutil/up_rate_limit_us 500
write /sys/devices/system/cpu/cpufreq/policy0/schedutil/down_rate_limit_us 20000
write /sys/devices/system/cpu/cpufreq/policy0/schedutil/iowait_boost_enable 1
write /sys/devices/system/cpu/cpufreq/policy0/schedutil/pl 0
write /sys/devices/system/cpu/cpufreq/policy0/schedutil/hispeed_freq 0
write /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor "schedutil"
write /sys/devices/system/cpu/cpufreq/policy4/schedutil/up_rate_limit_us 500
write /sys/devices/system/cpu/cpufreq/policy4/schedutil/down_rate_limit_us 20000
write /sys/devices/system/cpu/cpufreq/policy4/schedutil/iowait_boost_enable 1
write /sys/devices/system/cpu/cpufreq/policy4/schedutil/pl 0
write /sys/devices/system/cpu/cpufreq/policy4/schedutil/hispeed_freq 0

# Disable Touchboost
write /sys/module/msm_performance/parameters/touchboost 0

# Disable CAF task placement for Big Cores
write /proc/sys/kernel/sched_walt_rotate_big_tasks 0

# Enable suspend to idle mode to reduce latency during suspend/resume
write /sys/power/mem_sleep "s2idle"

# Disable I/O statistics accounting on important block devices (others disabled in kernel)
write /sys/block/sda/queue/iostats 0
write /sys/block/sdf/queue/iostats 0

# Init still likes to overriding cpuset ._.
write /dev/cpuset/audio-app/cpus 0-7
write /dev/cpuset/background/cpus 0-1
write /dev/cpuset/camera-daemon/cpus 0-7
write /dev/cpuset/foreground/cpus 0-3,6-7
write /dev/cpuset/restricted/cpus 0-3
write /dev/cpuset/system/cpus 0-1,6-7
write /dev/cpuset/system-background/cpus 0-3
write /dev/cpuset/top-app/cpus 0-7

# Enable ZRAM
write /sys/block/zram0/reset 1
write /sys/block/zram0/disksize 1073741824
mkswap /dev/block/zram0
swapon /dev/block/zram0

sleep 20;

QSEECOMD=$(pidof qseecomd)
THERMALENGINE="$(pidof thermal-engine)"
TIME_DAEMON=$(pidof time_daemon)
IMSQMIDAEMON=$(pidof imsqmidaemon)
IMSDATADAEMON=$(pidof imsdatadaemon)
DASHD=$(pidof dashd)
CND=$(pidof cnd)
DPMD=$(pidof dpmd)
RMT_STORAGE=$(pidof rmt_storage)
TFTP_SERVER=$(pidof tftp_server)
NETMGRD=$(pidof netmgrd)
IPACM=$(pidof ipacm)
QTI=$(pidof qti)
LOC_LAUNCHER=$(pidof loc_launcher)
QSEEPROXYDAEMON=$(pidof qseeproxydaemon)
IFAADAEMON=$(pidof ifaadaemon)
LOGCAT=$(pidof logcat)
LMKD=$(pidof lmkd)
PERFD=$(pidof perfd)
IOP=$(pidof iop)
MSM_IRQBALANCE=$(pidof msm_irqbalance)
SEEMP_HEALTHD=$(pidof seemp_healthd)
ESEPMDAEMON=$(pidof esepmdaemon)
WPA_SUPPLICANT=$(pidof wpa_supplicant)
SEEMPD=$(pidof seempd)
EMBRYO=$(pidof embryo)
HEALTHD=$(pidof healthd)
OEMLOGKIT=$(pidof oemlogkit)
NETD=$(pidof netd)

writepid_sbg "$QSEECOMD";
writepid_sbg "$THERMALENGINE";
writepid_sbg "$TIME_DAEMON";
writepid_sbg "$IMSQMIDAEMON";
writepid_sbg "$IMSDATADAEMON";
writepid_sbg "$DASHD";
writepid_sbg "$CND";
writepid_sbg "$DPMD";
writepid_sbg "$RMT_STORAGE";
writepid_sbg "$TFTP_SERVER";
writepid_sbg "$NETMGRD";
writepid_sbg "$IPACM";
writepid_sbg "$QTI";
writepid_sbg "$LOC_LAUNCHER";
writepid_sbg "$QSEEPROXYDAEMON";
writepid_sbg "$IFAADAEMON";
writepid_sbg "$LOGCAT";
writepid_sbg "$LMKD";
writepid_sbg "$PERFD";
writepid_sbg "$IOP";
writepid_sbg "$MSM_IRQBALANCE";
writepid_sbg "$SEEMP_HEALTHD";
writepid_sbg "$ESEPMDAEMON";
writepid_sbg "$WPA_SUPPLICANT";
writepid_sbg "$SEEMPD";
writepid_sbg "$HEALTHD";
writepid_sbg "$OEMLOGKIT";
writepid_sbg "$NETD";
writepid_sbg "$EMBRYO";

}&