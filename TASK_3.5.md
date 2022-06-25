# Домашнее задание к занятию "3.5. Файловые системы"

1. Узнайте о [sparse](https://ru.wikipedia.org/wiki/%D0%A0%D0%B0%D0%B7%D1%80%D0%B5%D0%B6%D1%91%D0%BD%D0%BD%D1%8B%D0%B9_%D1%84%D0%B0%D0%B9%D0%BB) (разряженных) файлах.

```bash
Изучил. Хорошее решение для использования в виртуализации и резерном копировании с целью экономии места.
```

2. Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?

```bash
Нет. Не могут. Потому что они ссылаются на одно и то же место в файловой системе и имеют одну и ту же Iноду.
Если изменить права доступа и (или) владельца для одной из жестких ссылок, 
то эти параметры автоматически изменятся и у всех остальных жестких ссылок,
указывающих на общую Iноду:
vagrant@vagrant:~/test_dir$ touch file_hl1
vagrant@vagrant:~/test_dir$ ln file_hl1 file_hl2
vagrant@vagrant:~/test_dir$ ls -lih
total 0
1048614 -rw-rw-r-- 2 vagrant vagrant 0 Jun 26 18:55 file_hl1
1048614 -rw-rw-r-- 2 vagrant vagrant 0 Jun 26 18:55 file_hl2
vagrant@vagrant:~/test_dir$ chmod +x file_hl1
vagrant@vagrant:~/test_dir$ ls -lih
total 0
1048614 -rwxrwxr-x 2 vagrant vagrant 0 Jun 26 18:55 file_hl1
1048614 -rwxrwxr-x 2 vagrant vagrant 0 Jun 26 18:55 file_hl2
vagrant@vagrant:~/test_dir$
```

3. Сделайте `vagrant destroy` на имеющийся инстанс Ubuntu. Замените содержимое Vagrantfile следующим:

    ```bash
    Vagrant.configure("2") do |config|
      config.vm.box = "bento/ubuntu-20.04"
      config.vm.provider :virtualbox do |vb|
        lvm_experiments_disk0_path = "/tmp/lvm_experiments_disk0.vmdk"
        lvm_experiments_disk1_path = "/tmp/lvm_experiments_disk1.vmdk"
        vb.customize ['createmedium', '--filename', lvm_experiments_disk0_path, '--size', 2560]
        vb.customize ['createmedium', '--filename', lvm_experiments_disk1_path, '--size', 2560]
        vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk0_path]
        vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk1_path]
      end
    end
    ```
Данная конфигурация создаст новую виртуальную машину с двумя дополнительными неразмеченными дисками по 2.5 Гб.

```bash
Появились диски sdb и sdc:
vagrant@vagrant:~$ lsblk
NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
loop0                       7:0    0 55.4M  1 loop /snap/core18/2128
loop1                       7:1    0 61.9M  1 loop /snap/core20/1518
loop2                       7:2    0 70.3M  1 loop /snap/lxd/21029
loop3                       7:3    0 67.8M  1 loop /snap/lxd/22753
loop4                       7:4    0   47M  1 loop /snap/snapd/16010
loop5                       7:5    0 55.5M  1 loop /snap/core18/2409
sda                         8:0    0   64G  0 disk
├─sda1                      8:1    0    1M  0 part
├─sda2                      8:2    0    1G  0 part /boot
└─sda3                      8:3    0   63G  0 part
  └─ubuntu--vg-ubuntu--lv 253:0    0 31.5G  0 lvm  /
sdb                         8:16   0  2.5G  0 disk
sdc                         8:32   0  2.5G  0 disk
vagrant@vagrant:~$
```

4. Используя `fdisk`, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство.

```bash
root@vagrant:~# fdisk -l /dev/sdb
Disk /dev/sdb: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x6b19f235

Device     Boot   Start     End Sectors  Size Id Type
/dev/sdb1          2048 4196351 4194304    2G 83 Linux
/dev/sdb2       4196352 5242879 1046528  511M 83 Linux
```

5. Используя `sfdisk`, перенесите данную таблицу разделов на второй диск.

```bash
root@vagrant:~# sfdisk -d /dev/sdb | sfdisk /dev/sdc
Checking that no-one is using this disk right now ... OK

Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes

>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Created a new DOS disklabel with disk identifier 0x6b19f235.
/dev/sdc1: Created a new partition 1 of type 'Linux' and of size 2 GiB.
/dev/sdc2: Created a new partition 2 of type 'Linux' and of size 511 MiB.
/dev/sdc3: Done.

New situation:
Disklabel type: dos
Disk identifier: 0x6b19f235

Device     Boot   Start     End Sectors  Size Id Type
/dev/sdc1          2048 4196351 4194304    2G 83 Linux
/dev/sdc2       4196352 5242879 1046528  511M 83 Linux

The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
----------------------------------
РЕЗУЛЬТАТ:
root@vagrant:~# fdisk -l /dev/sdb
Disk /dev/sdb: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x6b19f235

Device     Boot   Start     End Sectors  Size Id Type
/dev/sdb1          2048 4196351 4194304    2G 83 Linux
/dev/sdb2       4196352 5242879 1046528  511M 83 Linux
----------------------------------
root@vagrant:~# fdisk -l /dev/sdc
Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x6b19f235

Device     Boot   Start     End Sectors  Size Id Type
/dev/sdc1          2048 4196351 4194304    2G 83 Linux
/dev/sdc2       4196352 5242879 1046528  511M 83 Linux
```

6. Соберите `mdadm` RAID1 на паре разделов 2 Гб.

```bash
root@vagrant:~# mdadm --create --verbose /dev/md0 --level=1 --raid-devices=2 /dev/sdb1 /dev/sdc1
mdadm: Note: this array has metadata at the start and
    may not be suitable as a boot device.  If you plan to
    store '/boot' on this device please ensure that
    your boot-loader understands md/v1.x metadata, or use
    --metadata=0.90
mdadm: size set to 2094080K
Continue creating array? Y
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.
root@vagrant:~#
root@vagrant:~# lsblk
NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
loop0                       7:0    0 55.4M  1 loop  /snap/core18/2128
loop1                       7:1    0 61.9M  1 loop  /snap/core20/1518
loop2                       7:2    0 70.3M  1 loop  /snap/lxd/21029
loop3                       7:3    0 67.8M  1 loop  /snap/lxd/22753
loop4                       7:4    0   47M  1 loop  /snap/snapd/16010
loop5                       7:5    0 55.5M  1 loop  /snap/core18/2409
sda                         8:0    0   64G  0 disk
├─sda1                      8:1    0    1M  0 part
├─sda2                      8:2    0    1G  0 part  /boot
└─sda3                      8:3    0   63G  0 part
  └─ubuntu--vg-ubuntu--lv 253:0    0 31.5G  0 lvm   /
sdb                         8:16   0  2.5G  0 disk
├─sdb1                      8:17   0    2G  0 part
│ └─md0                     9:0    0    2G  0 raid1
└─sdb2                      8:18   0  511M  0 part
sdc                         8:32   0  2.5G  0 disk
├─sdc1                      8:33   0    2G  0 part
│ └─md0                     9:0    0    2G  0 raid1
└─sdc2                      8:34   0  511M  0 part
```

7. Соберите `mdadm` RAID0 на второй паре маленьких разделов.

```bash
root@vagrant:~# mdadm --create --verbose /dev/md1 --level=0 --raid-devices=2 /dev/sdb2 /dev/sdc2
mdadm: chunk size defaults to 512K
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md1 started.
root@vagrant:~# lsblk
NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
loop0                       7:0    0 55.4M  1 loop  /snap/core18/2128
loop1                       7:1    0 61.9M  1 loop  /snap/core20/1518
loop2                       7:2    0 70.3M  1 loop  /snap/lxd/21029
loop3                       7:3    0 67.8M  1 loop  /snap/lxd/22753
loop4                       7:4    0   47M  1 loop  /snap/snapd/16010
loop5                       7:5    0 55.5M  1 loop  /snap/core18/2409
sda                         8:0    0   64G  0 disk
├─sda1                      8:1    0    1M  0 part
├─sda2                      8:2    0    1G  0 part  /boot
└─sda3                      8:3    0   63G  0 part
  └─ubuntu--vg-ubuntu--lv 253:0    0 31.5G  0 lvm   /
sdb                         8:16   0  2.5G  0 disk
├─sdb1                      8:17   0    2G  0 part
│ └─md0                     9:0    0    2G  0 raid1
└─sdb2                      8:18   0  511M  0 part
  └─md1                     9:1    0 1018M  0 raid0
sdc                         8:32   0  2.5G  0 disk
├─sdc1                      8:33   0    2G  0 part
│ └─md0                     9:0    0    2G  0 raid1
└─sdc2                      8:34   0  511M  0 part
  └─md1                     9:1    0 1018M  0 raid0
```

8. Создайте 2 независимых PV на получившихся md-устройствах.

```bash
root@vagrant:~# pvcreate /dev/md0
  Physical volume "/dev/md0" successfully created.
root@vagrant:~# pvcreate /dev/md1
  Physical volume "/dev/md1" successfully created.
```

9. Создайте общую volume-group на этих двух PV.

```bash
root@vagrant:~# vgcreate vg1 /dev/md0 /dev/md1
  Volume group "vg1" successfully created
root@vagrant:~# vgdisplay
  --- Volume group ---
  VG Name               ubuntu-vg
  System ID
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  2
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                1
  Open LV               1
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               <63.00 GiB
  PE Size               4.00 MiB
  Total PE              16127
  Alloc PE / Size       8064 / 31.50 GiB
  Free  PE / Size       8063 / <31.50 GiB
  VG UUID               aK7Bd1-JPle-i0h7-5jJa-M60v-WwMk-PFByJ7

  --- Volume group ---
  VG Name               vg1
  System ID
  Format                lvm2
  Metadata Areas        2
  Metadata Sequence No  1
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                0
  Open LV               0
  Max PV                0
  Cur PV                2
  Act PV                2
  VG Size               <2.99 GiB
  PE Size               4.00 MiB
  Total PE              765
  Alloc PE / Size       0 / 0
  Free  PE / Size       765 / <2.99 GiB
  VG UUID               tO9e7y-2fKe-P9d4-jlne-p30v-xubl-7N1WbP

```

10. Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.

```bash
PV с RAID0 - это /dev/md1, соответственно:
root@vagrant:~# lvcreate -L 100M vg1 /dev/md1
  Logical volume "lvol0" created.
root@vagrant:~# lvdisplay
  --- Logical volume ---
  LV Path                /dev/ubuntu-vg/ubuntu-lv
  LV Name                ubuntu-lv
  VG Name                ubuntu-vg
  LV UUID                ftN15m-3lML-YH5x-R5P2-kLCd-kzW3-32dlqO
  LV Write Access        read/write
  LV Creation host, time ubuntu-server, 2021-12-19 19:37:44 +0000
  LV Status              available
  # open                 1
  LV Size                31.50 GiB
  Current LE             8064
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:0

  --- Logical volume ---
  LV Path                /dev/vg1/lvol0
  LV Name                lvol0
  VG Name                vg1
  LV UUID                84bdOc-5CPd-vX06-vgAg-TfJ2-xxLO-dXmYDI
  LV Write Access        read/write
  LV Creation host, time vagrant, 2022-06-26 20:53:26 +0000
  LV Status              available
  # open                 0
  LV Size                100.00 MiB
  Current LE             25
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     4096
  Block device           253:1
```

11. Создайте `mkfs.ext4` ФС на получившемся LV.
```bash
root@vagrant:~# mkfs.ext4 /dev/vg1/lvol0
mke2fs 1.45.5 (07-Jan-2020)
Creating filesystem with 25600 4k blocks and 25600 inodes

Allocating group tables: done
Writing inode tables: done
Creating journal (1024 blocks): done
Writing superblocks and filesystem accounting information: done
```

12. Смонтируйте этот раздел в любую директорию, например, `/tmp/new`.

```bash
root@vagrant:~# mkdir /tmp/new
root@vagrant:~# mount /dev/vg1/lvol0 /tmp/new/
root@vagrant:~#
root@vagrant:~# mount | grep '/tmp/new'
/dev/mapper/vg1-lvol0 on /tmp/new type ext4 (rw,relatime,stripe=256)
```

13. Поместите туда тестовый файл, например `wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz`.

```bash
root@vagrant:~# wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz
--2022-06-26 21:01:53--  https://mirror.yandex.ru/ubuntu/ls-lR.gz
Resolving mirror.yandex.ru (mirror.yandex.ru)... 213.180.204.183, 2a02:6b8::183
Connecting to mirror.yandex.ru (mirror.yandex.ru)|213.180.204.183|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 23581066 (22M) [application/octet-stream]
Saving to: ‘/tmp/new/test.gz’

/tmp/new/test.gz                          100%[====================================================================================>]  22.49M  8.00MB/s    in 2.8s

2022-06-26 21:01:56 (8.00 MB/s) - ‘/tmp/new/test.gz’ saved [23581066/23581066]

root@vagrant:~# ll /tmp/new/
total 23056
drwxr-xr-x  3 root root     4096 Jun 26 21:01 ./
drwxrwxrwt 12 root root     4096 Jun 26 20:59 ../
drwx------  2 root root    16384 Jun 26 20:57 lost+found/
-rw-r--r--  1 root root 23581066 Jun 26 20:07 test.gz
root@vagrant:~#
```

14. Прикрепите вывод `lsblk`.

```bash
root@vagrant:~# lsblk
NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
loop0                       7:0    0 55.4M  1 loop  /snap/core18/2128
loop1                       7:1    0 61.9M  1 loop  /snap/core20/1518
loop2                       7:2    0 70.3M  1 loop  /snap/lxd/21029
loop3                       7:3    0 67.8M  1 loop  /snap/lxd/22753
loop4                       7:4    0   47M  1 loop  /snap/snapd/16010
loop5                       7:5    0 55.5M  1 loop  /snap/core18/2409
sda                         8:0    0   64G  0 disk
├─sda1                      8:1    0    1M  0 part
├─sda2                      8:2    0    1G  0 part  /boot
└─sda3                      8:3    0   63G  0 part
  └─ubuntu--vg-ubuntu--lv 253:0    0 31.5G  0 lvm   /
sdb                         8:16   0  2.5G  0 disk
├─sdb1                      8:17   0    2G  0 part
│ └─md0                     9:0    0    2G  0 raid1
└─sdb2                      8:18   0  511M  0 part
  └─md1                     9:1    0 1018M  0 raid0
    └─vg1-lvol0           253:1    0  100M  0 lvm   /tmp/new
sdc                         8:32   0  2.5G  0 disk
├─sdc1                      8:33   0    2G  0 part
│ └─md0                     9:0    0    2G  0 raid1
└─sdc2                      8:34   0  511M  0 part
  └─md1                     9:1    0 1018M  0 raid0
    └─vg1-lvol0           253:1    0  100M  0 lvm   /tmp/new
```

15. Протестируйте целостность файла:

```bash
root@vagrant:~# gzip -t /tmp/new/test.gz
root@vagrant:~# echo $?
0
```

```bash
Выполнено:
root@vagrant:~# gzip -t /tmp/new/test.gz && echo $?
0
```

16. Используя pvmove, переместите содержимое PV с RAID0 на RAID1.

```bash
root@vagrant:~# pvmove /dev/md1 /dev/md0
  /dev/md1: Moved: 12.00%
  /dev/md1: Moved: 100.00%
root@vagrant:~# lsblk
NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
loop0                       7:0    0 55.4M  1 loop  /snap/core18/2128
loop1                       7:1    0 61.9M  1 loop  /snap/core20/1518
loop2                       7:2    0 70.3M  1 loop  /snap/lxd/21029
loop3                       7:3    0 67.8M  1 loop  /snap/lxd/22753
loop4                       7:4    0   47M  1 loop  /snap/snapd/16010
loop5                       7:5    0 55.5M  1 loop  /snap/core18/2409
sda                         8:0    0   64G  0 disk
├─sda1                      8:1    0    1M  0 part
├─sda2                      8:2    0    1G  0 part  /boot
└─sda3                      8:3    0   63G  0 part
  └─ubuntu--vg-ubuntu--lv 253:0    0 31.5G  0 lvm   /
sdb                         8:16   0  2.5G  0 disk
├─sdb1                      8:17   0    2G  0 part
│ └─md0                     9:0    0    2G  0 raid1
│   └─vg1-lvol0           253:1    0  100M  0 lvm   /tmp/new
└─sdb2                      8:18   0  511M  0 part
  └─md1                     9:1    0 1018M  0 raid0
sdc                         8:32   0  2.5G  0 disk
├─sdc1                      8:33   0    2G  0 part
│ └─md0                     9:0    0    2G  0 raid1
│   └─vg1-lvol0           253:1    0  100M  0 lvm   /tmp/new
└─sdc2                      8:34   0  511M  0 part
  └─md1                     9:1    0 1018M  0 raid0
```

17. Сделайте `--fail` на устройство в вашем RAID1 md.

```bash
root@vagrant:~# mdadm --fail /dev/md0 /dev/sdc1
mdadm: set /dev/sdc1 faulty in /dev/md0
```

18. Подтвердите выводом `dmesg`, что RAID1 работает в деградированном состоянии.

```bash
root@vagrant:~# dmesg -T | grep md0
[Sun Jun 26 20:30:22 2022] md/raid1:md0: not clean -- starting background reconstruction
[Sun Jun 26 20:30:22 2022] md/raid1:md0: active with 2 out of 2 mirrors
[Sun Jun 26 20:30:22 2022] md0: detected capacity change from 0 to 2144337920
[Sun Jun 26 20:30:22 2022] md: resync of RAID array md0
[Sun Jun 26 20:30:32 2022] md: md0: resync done.
[Sun Jun 26 21:16:21 2022] md/raid1:md0: Disk failure on sdc1, disabling device.
                           md/raid1:md0: Operation continuing on 1 devices.
```

19. Протестируйте целостность файла, несмотря на "сбойный" диск он должен продолжать быть доступен:

```bash
root@vagrant:~# gzip -t /tmp/new/test.gz
root@vagrant:~# echo $?
0
```

```bash
Выполнено:
root@vagrant:~# gzip -t /tmp/new/test.gz
root@vagrant:~# echo $?
0
```

20. Погасите тестовый хост, `vagrant destroy`.

```bash
c:\HashiCorp\Vagrant\bin>vagrant.exe suspend
==> default: Saving VM state and suspending execution...

c:\HashiCorp\Vagrant\bin>vagrant.exe destroy
    default: Are you sure you want to destroy the 'default' VM? [y/N] y
==> default: Discarding saved state of VM...
==> default: Destroying VM and associated drives...
```

