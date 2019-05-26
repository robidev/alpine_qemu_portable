@echo off
setlocal EnableDelayedExpansion

set "IMAGE=alpine.img"
set "ISOFILE=alpine.iso"
set "QEMUBIN=qemu-system-x86_64.exe"
set "QEMUIMG=qemu-img.exe"
set "GRAPHIC=-nographic"

if not exist %IMAGE% (
    echo No existing image found with name %IMAGE%
    echo Generating new image
    set /p Size="Enter image size(e.g. 1G, 20G): "
    %QEMUIMG% create %IMAGE% !Size!
) 

echo WARNING: qemu started alpine in headless mode, this should only be used if ssh access is working properly, and not during installation phase

%QEMUBIN% ^
-smp cpus=2 -name alpine ^
-drive file=%IMAGE%,index=0,media=disk,format=raw ^
-device e1000,netdev=net0 ^
-netdev user,id=net0,hostfwd=tcp::10022-:22 ^
-cdrom %ISOFILE% -boot order=a ^
%GRAPHIC% ^
-m 2048M

