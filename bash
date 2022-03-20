#!$PREFIX/bin/bash

msg() {
echo -e "$@" >&2
}

apt install ncurses-utils -y > /dev/null 2>&1

if [ -d "$main" ]; 
then
msg "${RST}$(tput bold)$(tput setaf 1)[!] Sorry But Debian Has Installed!"
exit
fi

if [ -n "$(command -v tput)" ] && [ $(tput colors) -ge 8 ]; then
RST="$(tput sgr0)"
RED="${RST}$(tput setaf 1)"
BRED="${RST}$(tput bold)$(tput setaf 1)"
GREEN="${RST}$(tput setaf 2)"
YELLOW="${RST}$(tput setaf 3)"
BYELLOW="${RST}$(tput bold)$(tput setaf 3)"
BLUE="${RST}$(tput setaf 4)"
CYAN="${RST}$(tput setaf 6)"
BCYAN="${RST}$(tput bold)$(tput setaf 6)"
ICYAN="${RST}$(tput sitm)$(tput setaf 6)"
else
RED=""
BRED=""
GREEN=""
YELLOW=""
BYELLOW=""
BLUE=""
CYAN=""
BCYAN=""
ICYAN=""
RST=""
fi

main="$HOME.debian_termux"
version="1.0"

clear
msg "${YELLOW}[#] installing package"
apt install wget curl proot xz-utils tar -y > /dev/null 2>&1
sleep 0.5

mkdir -p $main
cd $main

msg "${YELLOW}[#] Installing Rootfs"
curl https://raw.githubusercontent.com/debuerreotype/docker-debian-artifacts/dist-arm64v8/stable/slim/rootfs.tar.xz --progress-bar --output "rootfs.tar.xz"
sleep 0.5

msg "${YELLOW}[#] Extract Rootfs"
tar xvf "rootfs.tar.xz"
rm rootfs.tar.xz
sleep 0.5

msg "${YELLOW}[#] Setup System"
cat <<- EOF > "${main}/etc/ld.so.preload"
/lib/aarch64-linux-gnu/libgcc_s.so.1
EOF
cat <<- EOF > "${main}/etc/profile.d/config.sh"
export LANG="C.UTF-8"
export MOZ_FAKE_NO_SANDBOX="1"
export PULSE_SERVER="127.0.0.1"
EOF
cat <<- EOF > "${main}/etc/resolv.conf"
nameserver 8.8.8.8
nameserver 8.8.4.4
EOF
cat <<- EOF > "${main}/etc/hosts"
127.0.0.1  localhost
::1        ip6-localhost ip6-loopback
EOF
while read group_name group_id; do
cat <<- EOF >> "${main}/etc/group"
${group_name}:x:${group_id}:
EOF
cat <<- EOF >> "${main}/etc/gshadow"
${group_name}:*::
EOF
done < <(paste <(id -Gn | tr ' ' '\n') <(id -G | tr ' ' '\n'))
cat <<- EOF > "${main}/proc/.loadavg"
0.35 0.22 0.15 1/575 7767
EOF
cat <<- EOF > "${main}/proc/.stat"
cpu  265542 13183 24203 611072 152293 68 191340 255 0 0 0
cpu0 265542 13183 24203 611072 152293 68 191340 255 0 0 0
intr 815181 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
ctxt 906205
btime 163178502
processes 25384
procs_running 1
procs_blocked 0
softirq 1857962 55 2536781 34 1723322 8 2457784 5 1914410
EOF
cat <<- EOF > "${main}/proc/.uptime"
11965.80 11411.22
EOF
cat <<- EOF > "${main}/proc/.vmstat"
nr_free_pages 705489
nr_alloc_batch 0
nr_inactive_anon 1809
nr_active_anon 61283
nr_inactive_file 69543
nr_active_file 58416
nr_unevictable 64
nr_mlock 64
nr_anon_pages 60894
nr_mapped 99503
nr_file_pages 130218
nr_dirty 9
nr_writeback 0
nr_slab_reclaimable 2283
nr_slab_unreclaimable 3714
nr_page_table_pages 1911
nr_kernel_stack 687
nr_unstable 0
nr_bounce 0
nr_vmscan_write 0
nr_vmscan_immediate_reclaim 0
nr_writeback_temp 0
nr_isolated_anon 0
nr_isolated_file 0
nr_shmem 2262
nr_dirtied 3675
nr_written 3665
nr_pages_scanned 0
workingset_refault 1183
workingset_activate 1183
workingset_nodereclaim 0
nr_anon_transparent_hugepages 0
nr_free_cma 0
nr_dirty_threshold 21574
nr_dirty_background_threshold 5393
pgpgin 541367
pgpgout 23248
pswpin 1927
pswpout 2562
pgalloc_dma 182
pgalloc_normal 76067
pgalloc_high 326333
pgalloc_movable 0
pgfree 1108260
pgactivate 53201
pgdeactivate 2592
pgfault 420060
pgmajfault 4323
pgrefill_dma 0
pgrefill_normal 2589
pgrefill_high 0
pgrefill_movable 0
pgsteal_kswapd_dma 0
pgsteal_kswapd_normal 0
pgsteal_kswapd_high 0
pgsteal_kswapd_movable 0
pgsteal_direct_dma 0
pgsteal_direct_normal 1211
pgsteal_direct_high 7987
pgsteal_direct_movable 0
pgscan_kswapd_dma 0
pgscan_kswapd_normal 0
pgscan_kswapd_high 0
pgscan_kswapd_movable 0
pgscan_direct_dma 0
pgscan_direct_normal 4172
pgscan_direct_high 25365
pgscan_direct_movable 0
pgscan_direct_throttle 0
pginodesteal 0
slabs_scanned 9728
kswapd_inodesteal 0
kswapd_low_wmark_hit_quickly 0
kswapd_high_wmark_hit_quickly 0
pageoutrun 1
allocstall 189
pgrotated 7
drop_pagecache 0
drop_slab 0
htlb_buddy_alloc_success 0
htlb_buddy_alloc_fail 0
unevictable_pgs_culled 64
unevictable_pgs_scanned 0
unevictable_pgs_rescued 0
unevictable_pgs_mlocked 64
unevictable_pgs_munlocked 0
unevictable_pgs_cleared 0
unevictable_pgs_stranded 0
EOF
cat <<- EOF > "${main}/proc/.version"
Linux version 7.1.2-tmux (termux@android) (gcc version 4.9 (GCC)) $(uname -v)
EOF
cat <<- EOF > "${PREFIX}/bin/start-debian"
#!$PREFIX/bin/bash
unset LD_PRELOAD
command="proot"
command+=" --kernel-release=7.1.2-tmux"
command+=" --link2symlink"
command+=" --kill-on-exit"
command+=" --rootfs=\$HOME.debian_termux"
command+=" --root-id"
command+=" --bind=/dev"
command+=" --bind=/dev/urandom:/dev/random"
command+=" --bind=/proc"
command+=" --bind=/proc/self/fd:/dev/fd"
command+=" --bind=/proc/self/fd/0:/dev/stdin"
command+=" --bind=/proc/self/fd/1:/dev/stdout"
command+=" --bind=/proc/self/fd/2:/dev/stderr"
command+=" --bind=/sys"
command+=" --bind=/storage/self/primary:/sdcard"
command+=" --bind=/data/data/com.termux"
command+=" --bind=\$HOME.debian_termux/tmp:/dev/shm"
if ! cat /proc/loadavg > /dev/null 2>&1; then
command+=" --bind=\$HOME.debian_termux/proc/.loadavg:/proc/loadavg"
fi
if ! cat /proc/stat > /dev/null 2>&1; then
command+=" --bind=\$HOME.debian_termux/proc/.stat:/proc/stat"
fi
if ! cat /proc/uptime > /dev/null 2>&1; then
command+=" --bind=\$HOME.debian_termux/proc/.uptime:/proc/uptime"
fi
if ! cat /proc/vmstat > /dev/null 2>&1; then
command+=" --bind=\$HOME.debian_termux/proc/.vmstat:/proc/vmstat"
fi
command+=" --bind=\$HOME.debian_termux/proc/.version:/proc/version"
command+=" /usr/bin/env --ignore-environment"
command+=" TERM=\${TERM-xterm-256color}"
command+=" /bin/su --login"
com="\$@"; [ -z "\$1" ] && exec \${command} || \${command} "\${com}"
EOF
chmod +x $PREFIX/bin/start-debian
sleep 0.5
msg "${GREEN}✓ Setup Complate. no error report."
msg "${GREEN}✓ You can Start Debian Now."
msg "${GREEN}✓ Type start-debian To start!"
