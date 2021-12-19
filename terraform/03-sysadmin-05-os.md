Домашнее задание к занятию "3.5. Файловые системы"

1. Узнайте о sparse (разряженных) файлах.
   
**Ответ:** Ознакомился. Знал что ZFS использует такой принцип, но не знал как он называется. Поддержка торрентами тоже стала открытием.

2.  Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?

**Ответ:**
Так как hardlink это указатель на файл и имеет тот же inode, то права не буду различаться.
```shell
vagrant@vagrant:~$ ln test_hl test_link
vagrant@vagrant:~$ ls -ilh
total 0
1835020 -rw-rw-r-- 2 vagrant vagrant 0 Dec 19 02:41 test_hl
1835020 -rw-rw-r-- 2 vagrant vagrant 0 Dec 19 02:41 test_link
vagrant@vagrant:~$ chmod 0755 test_hl 
vagrant@vagrant:~$ ls -ilh
total 0
1835020 -rwxr-xr-x 2 vagrant vagrant 0 Dec 19 02:41 test_hl
1835020 -rwxr-xr-x 2 vagrant vagrant 0 Dec 19 02:41 test_link
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
   
**Ответ:** Мой Vagrantfile будет выглядеть несколько иначе
```bash
Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-20.04-arm64"
  config.vm.provider :parallels do |prl|
    prl.name = "vagrant_test"
    lvm_experiments_disk0_path = "/Users/dmitriynenashev/new_vagrant_project/lvm_disk0.hdd"
    lvm_experiments_disk1_path = "/Users/dmitriynenashev/new_vagrant_project/lvm_disk1.hdd"
    prl.customize ["set", :id, "--device-add", "hdd", "--image", lvm_experiments_disk0_path, "--size", "2560", "--enable"]
    prl.customize ["set", :id, "--device-add", "hdd", "--image", lvm_experiments_disk1_path, "--size", "2560", "--enable"]
  end```

```shell
root@vagrant:/home/vagrant# lsblk
NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
loop0                       7:0    0 28.1M  1 loop /snap/snapd/12707
loop1                       7:1    0 48.9M  1 loop /snap/core18/2127
loop2                       7:2    0   62M  1 loop /snap/lxd/21032
loop3                       7:3    0   49M  1 loop /snap/core18/2252
loop4                       7:4    0 37.5M  1 loop /snap/snapd/14296
loop5                       7:5    0 57.5M  1 loop /snap/core20/1274
sda                         8:0    0   64G  0 disk 
├─sda1                      8:1    0  512M  0 part /boot/efi
├─sda2                      8:2    0    1G  0 part /boot
└─sda3                      8:3    0 62.5G  0 part 
  └─ubuntu--vg-ubuntu--lv 253:0    0 31.3G  0 lvm  /
sdb                         8:16   0  2.5G  0 disk 
sdc                         8:32   0  2.5G  0 disk 
sr0                        11:0    1 1024M  0 rom 
```

4. Используя fdisk, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство.

**Ответ:**
```shell
Disk /dev/sdb: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: lvm_disk0 SSD   
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disklabel type: dos
Disk identifier: 0x72e156e6

Device     Boot   Start     End Sectors  Size Id Type
/dev/sdb1          2048 4196351 4194304    2G 83 Linux
/dev/sdb2       4196352 5242879 1046528  511M 83 Linux
```
5. Используя sfdisk, перенесите данную таблицу разделов на второй диск.

**Ответ:**
```shell
root@vagrant:/home/vagrant# sfdisk -d /dev/sdb|sfdisk --force /dev/sdc
Checking that no-one is using this disk right now ... OK

Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: lvm_disk1 SSD   
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes

>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Created a new DOS disklabel with disk identifier 0x72e156e6.
/dev/sdc1: Created a new partition 1 of type 'Linux' and of size 2 GiB.
/dev/sdc2: Created a new partition 2 of type 'Linux' and of size 511 MiB.
/dev/sdc3: Done.

New situation:
Disklabel type: dos
Disk identifier: 0x72e156e6

Device     Boot   Start     End Sectors  Size Id Type
/dev/sdc1          2048 4196351 4194304    2G 83 Linux
/dev/sdc2       4196352 5242879 1046528  511M 83 Linux

The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
```

6. Соберите mdadm RAID1 на паре разделов 2 Гб.

***Ответ:***

```shell
root@vagrant:/home/vagrant# mdadm --create --verbose /dev/md1 -l 1 -n 2 /dev/sd{b1,c1}
mdadm: Note: this array has metadata at the start and
    may not be suitable as a boot device.  If you plan to
    store '/boot' on this device please ensure that
    your boot-loader understands md/v1.x metadata, or use
    --metadata=0.90
mdadm: size set to 2094080K
Continue creating array? y
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md1 started.
```

7. Соберите mdadm RAID0 на второй паре маленьких разделов.

***Ответ:***

```shell
root@vagrant:/home/vagrant# mdadm --create --verbose /dev/md0 -l 0 -n 2 /dev/sd{b2,c2}
mdadm: chunk size defaults to 512K
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.
```

8. Создайте 2 независимых PV на получившихся md-устройствах.
   
***Ответ:***
```shell
root@vagrant:/home/vagrant# pvcreate /dev/md1 /dev/md0
  Physical volume "/dev/md1" successfully created.
  Physical volume "/dev/md0" successfully created.
```

9. Создайте общую volume-group на этих двух PV.

***Ответ:***
```shell
root@vagrant:/home/vagrant# vgcreate vg1 /dev/md1 /dev/md0
  Volume group "vg1" successfully created
root@vagrant:/home/vagrant# vgdisplay 
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
  VG Size               <62.50 GiB
  PE Size               4.00 MiB
  Total PE              15999
  Alloc PE / Size       8000 / 31.25 GiB
  Free  PE / Size       7999 / <31.25 GiB
  VG UUID               IiR8bm-o3rO-DGWO-3fqt-P1Me-kl52-v1scdy
   
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
  VG UUID               3HgD1m-rmkf-oIqH-E3YU-Awe7-2x9K-WkYcKz
```

10. Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.

***Ответ:***
```shell
root@vagrant:/home/vagrant# lvcreate -L 100M vg1 /dev/md0
  Logical volume "lvol0" created.
root@vagrant:/home/vagrant# vgs
  VG        #PV #LV #SN Attr   VSize   VFree  
  ubuntu-vg   1   1   0 wz--n- <62.50g <31.25g
  vg1         2   1   0 wz--n-  <2.99g   2.89g
root@vagrant:/home/vagrant# lvs
  LV        VG        Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  ubuntu-lv ubuntu-vg -wi-ao----  31.25g                                                    
  lvol0     vg1       -wi-a----- 100.00m     
```

11. Создайте mkfs.ext4 ФС на получившемся LV.

***Ответ:***
```shell
root@vagrant:/home/vagrant# mkfs.ext4 /dev/vg1/lvol0
mke2fs 1.45.5 (07-Jan-2020)
Discarding device blocks: done                            
Creating filesystem with 25600 4k blocks and 25600 inodes

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (1024 blocks): done
Writing superblocks and filesystem accounting information: done
```

12. Смонтируйте этот раздел в любую директорию, например, /tmp/new.

***Ответ:***
```shell
root@vagrant:/home/vagrant# mkdir /tmp/new
root@vagrant:/home/vagrant# mount /dev/vg1/lvol0 /tmp/new
```

13. Поместите туда тестовый файл, например wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz.

***Ответ:***
```shell
root@vagrant:/home/vagrant# wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz
--2021-12-19 04:31:03--  https://mirror.yandex.ru/ubuntu/ls-lR.gz
Resolving mirror.yandex.ru (mirror.yandex.ru)... 213.180.204.183
Connecting to mirror.yandex.ru (mirror.yandex.ru)|213.180.204.183|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 22748010 (22M) [application/octet-stream]
Saving to: ‘/tmp/new/test.gz’

/tmp/new/test.gz                     100%[=====================================================================>]  21.69M  4.48MB/s    in 4.7s    

2021-12-19 04:31:07 (4.57 MB/s) - ‘/tmp/new/test.gz’ saved [22748010/22748010]

```

14. Прикрепите вывод lsblk.

***Ответ:***
```shell
root@vagrant:/home/vagrant# lsblk
NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
loop0                       7:0    0 28.1M  1 loop  /snap/snapd/12707
loop1                       7:1    0 48.9M  1 loop  /snap/core18/2127
loop2                       7:2    0   62M  1 loop  /snap/lxd/21032
loop3                       7:3    0   49M  1 loop  /snap/core18/2252
loop4                       7:4    0 37.5M  1 loop  /snap/snapd/14296
loop5                       7:5    0 57.5M  1 loop  /snap/core20/1274
loop6                       7:6    0 60.7M  1 loop  /snap/lxd/21843
sda                         8:0    0   64G  0 disk  
├─sda1                      8:1    0  512M  0 part  /boot/efi
├─sda2                      8:2    0    1G  0 part  /boot
└─sda3                      8:3    0 62.5G  0 part  
  └─ubuntu--vg-ubuntu--lv 253:0    0 31.3G  0 lvm   /
sdb                         8:16   0  2.5G  0 disk  
├─sdb1                      8:17   0    2G  0 part  
│ └─md1                     9:1    0    2G  0 raid1 
└─sdb2                      8:18   0  511M  0 part  
  └─md0                     9:0    0 1018M  0 raid0 
    └─vg1-lvol0           253:1    0  100M  0 lvm   /tmp/new
sdc                         8:32   0  2.5G  0 disk  
├─sdc1                      8:33   0    2G  0 part  
│ └─md1                     9:1    0    2G  0 raid1 
└─sdc2                      8:34   0  511M  0 part  
  └─md0                     9:0    0 1018M  0 raid0 
    └─vg1-lvol0           253:1    0  100M  0 lvm   /tmp/new
sr0                        11:0    1 1024M  0 rom   
```

15. Протестируйте целостность файла:

***Ответ:***
```shell
root@vagrant:/home/vagrant# gzip -t /tmp/new/test.gz && echo $?
0
```

16. Используя pvmove, переместите содержимое PV с RAID0 на RAID1.

***Ответ:***
```shell
root@vagrant:/home/vagrant# pvmove /dev/md0
  /dev/md0: Moved: 100.00%
root@vagrant:/home/vagrant# lsblk 
NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
loop0                       7:0    0 28.1M  1 loop  /snap/snapd/12707
loop1                       7:1    0 48.9M  1 loop  /snap/core18/2127
loop2                       7:2    0   62M  1 loop  /snap/lxd/21032
loop3                       7:3    0   49M  1 loop  /snap/core18/2252
loop4                       7:4    0 37.5M  1 loop  /snap/snapd/14296
loop5                       7:5    0 57.5M  1 loop  /snap/core20/1274
loop6                       7:6    0 60.7M  1 loop  /snap/lxd/21843
sda                         8:0    0   64G  0 disk  
├─sda1                      8:1    0  512M  0 part  /boot/efi
├─sda2                      8:2    0    1G  0 part  /boot
└─sda3                      8:3    0 62.5G  0 part  
  └─ubuntu--vg-ubuntu--lv 253:0    0 31.3G  0 lvm   /
sdb                         8:16   0  2.5G  0 disk  
├─sdb1                      8:17   0    2G  0 part  
│ └─md1                     9:1    0    2G  0 raid1 
│   └─vg1-lvol0           253:1    0  100M  0 lvm   /tmp/new
└─sdb2                      8:18   0  511M  0 part  
  └─md0                     9:0    0 1018M  0 raid0 
sdc                         8:32   0  2.5G  0 disk  
├─sdc1                      8:33   0    2G  0 part  
│ └─md1                     9:1    0    2G  0 raid1 
│   └─vg1-lvol0           253:1    0  100M  0 lvm   /tmp/new
└─sdc2                      8:34   0  511M  0 part  
  └─md0                     9:0    0 1018M  0 raid0 
sr0                        11:0    1 1024M  0 rom   
```

17. Сделайте --fail на устройство в вашем RAID1 md.

***Ответ:***
```shell
root@vagrant:/home/vagrant# mdadm /dev/md1 --fail /dev/sdb1
mdadm: set /dev/sdb1 faulty in /dev/md1
root@vagrant:/home/vagrant# mdadm -D /dev/md1
/dev/md1:
           Version : 1.2
     Creation Time : Sun Dec 19 04:17:06 2021
        Raid Level : raid1
        Array Size : 2094080 (2045.00 MiB 2144.34 MB)
     Used Dev Size : 2094080 (2045.00 MiB 2144.34 MB)
      Raid Devices : 2
     Total Devices : 2
       Persistence : Superblock is persistent

       Update Time : Sun Dec 19 04:38:47 2021
             State : clean, degraded 
    Active Devices : 1
   Working Devices : 1
    Failed Devices : 1
     Spare Devices : 0

Consistency Policy : resync

              Name : vagrant:1  (local to host vagrant)
              UUID : aedb54c7:4faae440:bf4bb8a3:920886bb
            Events : 19

    Number   Major   Minor   RaidDevice State
       -       0        0        0      removed
       1       8       33        1      active sync   /dev/sdc1

       0       8       17        -      faulty   /dev/sdb1
```

18. Подтвердите выводом dmesg, что RAID1 работает в деградированном состоянии.

***Ответ:***
```shell
root@vagrant:/home/vagrant# dmesg |grep md1
[  585.031970] md/raid1:md1: not clean -- starting background reconstruction
[  585.031973] md/raid1:md1: active with 2 out of 2 mirrors
[  585.032003] md1: detected capacity change from 0 to 2144337920
[  585.033729] md: resync of RAID array md1
[  595.451851] md: md1: resync done.
[ 1885.043141] md/raid1:md1: Disk failure on sdb1, disabling device.
               md/raid1:md1: Operation continuing on 1 devices.
```

19.Протестируйте целостность файла, несмотря на "сбойный" диск он должен продолжать быть доступен

***Ответ:***
```shell
root@vagrant:/home/vagrant# gzip -t /tmp/new/test.gz && echo $?
0

```

20. Погасите тестовый хост, vagrant destroy

***Ответ:***
```shell
root@vagrant:/home/vagrant# exit
exit
vagrant@vagrant:~$ exit
logout
Connection to 10.211.55.10 closed.
dmitriynenashev@MBP-Dmitriy-2 new_vagrant_project % vagrant destroy
    default: Are you sure you want to destroy the 'default' VM? [y/N] y
==> default: Forcing shutdown of VM...
==> default: Destroying VM and associated drives...
==> default: Destroying unused networking interface...
```