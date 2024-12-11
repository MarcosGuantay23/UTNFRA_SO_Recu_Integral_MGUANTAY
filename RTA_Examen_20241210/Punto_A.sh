#!/bin/bash

sudo fdisk -l

echo -e "n\np\n1\n\n+2G\nt\n1\n82\nn\np\n2\n\nt\n2\n8e\nwq" | sudo fdisk /dev/sdc

echo -e "n\np\n1\n\n+500M\nn\np\n2\n\nwq" | sudo fdisk /dev/sdd

echo -e "n\np\n1\n\nt\n8e\nwq" | sudo fdisk /dev/sde

echo -e "t\n1\n82\nt\n8e\nwq" | sudo fdisk /dev/sdc

echo -e "t\n1\n8e\nt\n2\n82\nwq" | sudo fdisk /dev/sdd

sudo pvcreate /dev/sdd1 /dev/sdd2 /dev/sde1 /dev/sdc1 /dev/sdc2

sudo vgcreate vg_datos /dev/sde1 /dev/sdd1 /dev/sdc2
sudo vgcreate vg_temp /dev/sdc1

sudo vgs

sudo lvcreate -L 1G vg_datos -n lv_docker
sudo lvcreate -l 100%FREE vg_datos -n lv_multimedia
sudo lvcreate -l 100%FREE vg_temp -n lv_swap

sudo fdisk -l

sudo mkfs.ext4 /dev/mapper/vg_datos-lv_docker
sudo mkfs.ext4 /dev/mapper/vg_datos-lv_multimedia
sudo mkfs.ext4 /dev/mapper/vg_temp-lv_swap

sudo mount /dev/mapper/vg_datos-lv_docker /var/lib/docker/
sudo mkdir -p /Multimedia/
sudo mount /dev/mapper/vg_datos-lv_multimedia /Multimedia/

sudo systemctl restart docker
sudo systemctl status docker
