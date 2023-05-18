################################################################################
# Copyright (C) 2019-2022 NI SP GmbH
# All Rights Reserved
#
# info@ni-sp.com / www.ni-sp.com
#
# We provide the information on an as is basis. 
# We provide no warranties, express or implied, related to the
# accuracy, completeness, timeliness, useability, and/or merchantability
# of the data and are not liable for any loss, damage, claim, liability,
# expense, or penalty, or for any direct, indirect, special, secondary,
# incidental, consequential, or exemplary damages or lost profit
# deriving from the use or misuse of this information.
################################################################################
# Version v1.2
#
# SLURM 20.11.3 Build and Installation script for Ubuntu 18.04, 20.04 and 22.04
# 
# https://slurm.schedmd.com/quickstart_admin.html

# prepare system
sudo apt update
sleep 2
# sudo apt upgrade -y

# get OS env
. /etc/os-release

# SLURM accounting support
if [ "$VERSION_ID" == "22.04" ] ; then
    sudo DEBIAN_FRONTEND=noninteractive apt install mariadb-server libmariadb-dev-compat libmariadb-dev -y
else
    sudo apt install mariadb-server libmariadbclient-dev libmariadb-dev -y
fi

export MUNGEUSER=966
sudo groupadd -g $MUNGEUSER munge
sudo useradd  -m -c "MUNGE Uid 'N' Gid Emporium" -d /var/lib/munge -u $MUNGEUSER -g munge  -s /sbin/nologin munge
export SLURMUSER=967
sudo groupadd -g $SLURMUSER slurm
sudo useradd  -m -c "SLURM workload manager" -d /var/lib/slurm -u $SLURMUSER -g slurm  -s /bin/bash slurm

# install munge
sudo DEBIAN_FRONTEND=noninteractive apt install munge libmunge-dev libmunge2 rng-tools -y
sudo rngd -r /dev/urandom

if [ "$VERSION_ID" == "22.04" ] ; then
    sudo /usr/sbin/mungekey -f
else
    sudo /usr/sbin/create-munge-key -r -f
fi

sudo sh -c  "dd if=/dev/urandom bs=1 count=1024 > /etc/munge/munge.key"
sudo chown munge: /etc/munge/munge.key
sudo chmod 400 /etc/munge/munge.key

sudo systemctl enable munge
sudo systemctl start munge

# prepare to build and install SLURM
sudo DEBIAN_FRONTEND=noninteractive apt install python3 gcc openssl numactl hwloc lua5.3 man2html \
     make ruby ruby-dev libmunge-dev libpam0g-dev -y
sudo /usr/bin/gem install fpm

mkdir slurm-tmp
cd slurm-tmp
if [ "$VER" == "" ]; then
    export VER=22.05.7    # latest 20.02.XX version
    export VER=22.05.8
    export VER=23.02.0   
    export VER=23.02.1   
    # export VER=22.05-latest # broken 
fi
# https://download.schedmd.com/slurm/slurm-23.02.1.tar.bz2
wget https://download.schedmd.com/slurm/slurm-$VER.tar.bz2

[ $? != 0 ] && echo Problem downloading https://download.schedmd.com/slurm/slurm-$VER.tar.bz2 ... Exiting && exit

tar jxvf slurm-$VER.tar.bz2
cd  slurm-[0-9]*.[0-9]
# ./configure
./configure --prefix=/usr --sysconfdir=/etc/slurm --enable-pam --with-pam_dir=/lib/x86_64-linux-gnu/security/ --without-shared-libslurm
make
make contrib
sudo make install
cd ..
# fpm -s dir -t deb -v 1.0 -n slurm-$VER --prefix=/usr -C /tmp/slurm-build .
# echo Creating deb package for SLURM $VER
# sudo fpm -s dir -t deb -v 1.0 -n slurm-$VER --prefix=/usr -C /usr .
# on compute nodes
# dpkg -i slurm-$VER_1.0_amd64.deb

# clean up
# rm -rf slurm-$VER

# mkdir -p /etc/slurm /etc/slurm/prolog.d /etc/slurm/epilog.d /var/spool/slurm/ctld /var/spool/slurm/d /var/log/slurm
# chown slurm /var/spool/slurm/ctld /var/spool/slurm/d /var/log/slurm

sudo mkdir /var/spool/slurm
sudo chown slurm:slurm /var/spool/slurm
sudo chmod 755 /var/spool/slurm
sudo mkdir /var/spool/slurm/slurmctld
sudo chown slurm:slurm /var/spool/slurm/slurmctld
sudo chmod 755 /var/spool/slurm/slurmctld
sudo mkdir /var/spool/slurm/cluster_state
sudo chown slurm:slurm /var/spool/slurm/cluster_state
sudo touch /var/log/slurmctld.log
sudo chown slurm:slurm /var/log/slurmctld.log
sudo touch /var/log/slurm_jobacct.log /var/log/slurm_jobcomp.log
sudo chown slurm: /var/log/slurm_jobacct.log /var/log/slurm_jobcomp.log
# sudo touch /var/run/slurmctld.pid /var/run/slurmd.pid
# sudo chown slurm:slurm /var/run/slurmctld.pid /var/run/slurmd.pid
sudo mkdir -p /etc/slurm/prolog.d /etc/slurm/epilog.d 

# rm slurm-$VER.tar.bz2
# cd ..
# rmdir slurm-tmp 

# get perl-Switch
# sudo yum install cpan -y 

# create the SLURM default configuration with
# compute nodes called "NodeName=linux[1-32]"
# in a cluster called "cluster"
# and a partition name called "test"
# Feel free to adapt to your needs
HOST=`hostname`

cat << EOF | sudo tee /etc/slurm/slurm.conf

# slurm.conf file generated by configurator easy.html.
# Put this file on all nodes of your cluster.
# See the slurm.conf man page for more information.
#
SlurmctldHost=localhost
#
#MailProg=/bin/mail
MpiDefault=none
#MpiParams=ports=#-#
ProctrackType=proctrack/cgroup
ReturnToService=2
SlurmctldPidFile=/var/run/slurmctld.pid
#SlurmctldPort=6817
SlurmdPidFile=/var/run/slurmd.pid
#SlurmdPort=6818
SlurmdSpoolDir=/var/spool/slurm/slurmd
SlurmUser=slurm
#SlurmdUser=root
StateSaveLocation=/var/spool/slurm/
SwitchType=switch/none
TaskPlugin=task/affinity
#
#
# TIMERS
#KillWait=30
#MinJobAge=300
#SlurmctldTimeout=120
#SlurmdTimeout=300
#
#
# SCHEDULING
SchedulerType=sched/backfill
SelectType=select/cons_res
SelectTypeParameters=CR_Core
#
#
# LOGGING AND ACCOUNTING
AccountingStorageType=accounting_storage/none
ClusterName=cluster
#JobAcctGatherFrequency=30
JobAcctGatherType=jobacct_gather/none
#SlurmctldDebug=info
SlurmctldLogFile=/var/log/slurmctld.log
#SlurmdDebug=info
SlurmdLogFile=/var/log/slurmd.log
#
#
# COMPUTE NODES
NodeName=$HOST State=idle Feature=dcv2,other
# NodeName=linux[1-32] CPUs=1 State=UNKNOWN
# NodeName=linux1 NodeAddr=128.197.115.158 CPUs=4 State=UNKNOWN
# NodeName=linux2 NodeAddr=128.197.115.7 CPUs=4 State=UNKNOWN

PartitionName=test Nodes=$HOST Default=YES MaxTime=INFINITE State=UP
# PartitionName=test Nodes=$HOST,linux[1-32] Default=YES MaxTime=INFINITE State=UP

# DefMemPerNode=1000
# MaxMemPerNode=1000
# DefMemPerCPU=4000 
# MaxMemPerCPU=4096

EOF

cat  << EOF | sudo tee /etc/slurm/cgroup.conf
###
#
# Slurm cgroup support configuration file
#
# See man slurm.conf and man cgroup.conf for further
# information on cgroup configuration parameters
#--
CgroupAutomount=yes

ConstrainCores=no
ConstrainRAMSpace=no

EOF


# on master/controller node
cat <<EOF  | sudo tee /etc/systemd/system/slurmctld.service
[Unit]
Description=Slurm controller daemon
After=network.target munge.service
ConditionPathExists=/etc/slurm/slurm.conf

[Service]
Type=forking
EnvironmentFile=-/etc/sysconfig/slurmctld
ExecStart=/usr/sbin/slurmctld $SLURMCTLD_OPTIONS
ExecReload=/bin/kill -HUP \$MAINPID
PIDFile=/var/run/slurmctld.pid

[Install]
WantedBy=multi-user.target
EOF

cat <<EOF | sudo tee /etc/systemd/system/slurmdbd.service
[Unit]
Description=Slurm DBD accounting daemon
After=network.target munge.service
ConditionPathExists=/etc/slurm/slurmdbd.conf

[Service]
Type=forking
EnvironmentFile=-/etc/sysconfig/slurmdbd
ExecStart=/usr/sbin/slurmdbd $SLURMDBD_OPTIONS
ExecReload=/bin/kill -HUP \$MAINPID
PIDFile=/var/run/slurmdbd.pid

[Install]
WantedBy=multi-user.target
EOF

# on master
sudo systemctl daemon-reload
sudo systemctl enable slurmdbd
sudo systemctl start slurmdbd
sudo systemctl enable slurmctld
sudo systemctl start slurmctld

# on compute nodes
cat  <<EOF  | sudo tee /etc/systemd/system/slurmd.service
[Unit]
Description=Slurm node daemon
After=network.target munge.service
ConditionPathExists=/etc/slurm/slurm.conf

[Service]
Type=forking
EnvironmentFile=-/etc/sysconfig/slurmd
ExecStart=/usr/sbin/slurmd -d /usr/sbin/slurmstepd $SLURMD_OPTIONS
ExecReload=/bin/kill -HUP \$MAINPID
PIDFile=/var/run/slurmd.pid
KillMode=process
LimitNOFILE=51200
LimitMEMLOCK=infinity
LimitSTACK=infinity

[Install]
WantedBy=multi-user.target
EOF

# on compute nodes 
sudo systemctl daemon-reload
sudo systemctl enable slurmd.service
sudo systemctl start slurmd.service

# firewall will block connections between nodes so in case of cluster
# with multiple nodes adapt the firewall on the compute nodes 
#
# sudo systemctl stop firewalld
# sudo systemctl disable firewalld

# on the master node
#sudo firewall-cmd --permanent --zone=public --add-port=6817/udp
#sudo firewall-cmd --permanent --zone=public --add-port=6817/tcp
#sudo firewall-cmd --permanent --zone=public --add-port=6818/tcp
#sudo firewall-cmd --permanent --zone=public --add-port=6818/tcp
#sudo firewall-cmd --permanent --zone=public --add-port=7321/tcp
#sudo firewall-cmd --permanent --zone=public --add-port=7321/tcp
#sudo firewall-cmd --reload

# sync clock on master and every compute node 
#sudo yum install ntp -y
#sudo chkconfig ntpd on
#sudo ntpdate pool.ntp.org
#sudo systemctl start ntpd


echo Sleep for a few seconds for slurmd to come up ...
sleep 2

# checking 
# sudo systemctl status slurmd.service
# sudo journalctl -xe

# if you experience an error with starting up slurmd.service
# like "fatal: Incorrect permissions on state save loc: /var/spool"
# then you might want to adapt with chmod 777 /var/spool

# more checking 
# sudo slurmd -Dvvv -N YOUR_HOSTNAME 
# sudo slurmctld -D vvvvvvvv
# or tracing with sudo strace slurmctld -D vvvvvvvv

# echo Compute node bugs: tail /var/log/slurmd.log
# echo Server node bugs: tail /var/log/slurmctld.log

# show cluster 
echo 
echo Output from: \"sinfo\"
sinfo

# sinfo -Nle
echo 
echo Output from: \"scontrol show partition\"
scontrol show partition

# show host info as slurm sees it
echo 
echo Output from: \"slurmd -C\"
slurmd -C

# in case host is in drain status
# scontrol update nodename=$HOST state=idle
 
echo 
echo Output from: \"scontrol show nodes\"
scontrol show nodes

# If jobs are running on the node:
# scontrol update nodename=$HOST state=resume

# lets run our first job
echo 
echo Output from: \"srun hostname\"
srun hostname

# if there are issues in scheduling
# turn on debugging
#    sudo scontrol setdebug 6   # or up to 9 
# check the journal 
#    journalctl -xe
# turn off debugging
#    sudo scontrol setdebug 3

# scontrol
# scontrol: show node $HOST

# scontrol show jobs
# scontrol update NodeName=ip-172-31-23-216 State=RESUME
# scancel JOB_ID
# srun -N5 /bin/hostname
# after changing the configuration:
#   scontrol reconfigure
#
# more resources
# https://slurm.schedmd.com/quickstart.html
# https://slurm.schedmd.com/quickstart_admin.html
#



