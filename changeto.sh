#!/bin/bash
xorgconf=/usr/share/X11/xorg.conf.d
nvidiafile=10-nvidia-drm-outputclass.conf
nouveaufile=20-nouveau.conf

function reboot_process(){
    read -p 'Reboot? y ' choice
    if [[ choice == [yY] ]]
    then
        reboot
    fi
}


function nvidia(){
    echo 'nvidia'
    echo 'blacklisting nouveau'
    echo 'blacklist nouveau'>/usr/lib/modprobe.d/nvidia.conf
    echo 'done'

    echo 'configuring nvidia setup'
    if [[ -f $xorgconf/$nvidiafile ]]
    then
        mv $xorgconf/$nvidiafile.bak $xorgconf/$nvidiafile
    else
        cp ./$nvidiafile $xorgconf/$nvidiafile
    fi
    echo 'done'

    echo 'deconfiguring nouveau setup'
    if [[ -f $xorgconf/$nouveaufile ]]
    then
    mv $xorgconf/$nouveaufile $xorgconf/$nouveaufile.bak
    fi
    echo 'done'
    reboot_process
}

function nouveau(){
    echo 'nouveau'
    echo 'whitelisting nouveau'
    echo '#blacklist nouveau'>/usr/lib/modprobe.d/nvidia.conf
    echo 'done'
    echo 'blacklisting nvidia'
    echo 'blacklist nvidia'>>/usr/lib/modprobe.d/nvidia.conf
    echo 'done'
    
    echo 'deconfiguring nvidia setup'
    if [[ -f $xorgconf/$nvidiafile ]]
    then
        mv $xorgconf/$nvidiafile $xorgconf/$nvidiafile.bak
    fi
    echo 'done'

    echo 'configuring nouveau setup'
    if [[ -f $xorgconf/$nouveaufile.bak ]]
    then
        mv $xorgconf/$nouveaufile.bak $xorgconf/$nouveaufile
    else
        cp ./$nouveaufile $xorgconf/$nouveaufile
    fi
    echo 'done'
    reboot_process
}


# main logic
if [[ $1 == 'nvidia' ]]
then
    nvidia
elif [[ $1 == 'nouveau' ]]
then
    nouveau
else
    echo There are two options
    echo nvidia: change to nvidia
    echo nouveau: change to nouveau
fi
