Домашнее задание к занятию «3.3. Операционные системы, лекция 1»

1. Какой системный вызов делает команда cd?

   **Ответ:** `chdir(const char *path)` - изменяет текущий каталог на path.
```shell
abix@s3:~$ strace bash -c 'cd /tmp/'
execve("/usr/bin/bash", ["bash", "-c", "cd /tmp/"], 0x7ffc2d1a9690 /* 23 vars */) = 0
brk(NULL)                               = 0x5563f83f2000
...
mask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
stat("/tmp", {st_mode=S_IFDIR|S_ISVTX|0777, st_size=4096, ...}) = 0
chdir("/tmp")                           = 0
rt_sigprocmask(SIG_BLOCK, [CHLD], [], 8) = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
exit_group(0)                           = ?
+++ exited with 0 +++
```

2. Используя strace выясните, где находится база данных file на основании которой она делает свои догадки.

   **Ответ:** `/usr/share/misc/magic.mgc -> /usr/lib/file/magic.mgc`

```shell
abix@s3:~$ strace file /dev/sda
execve("/usr/bin/file", ["file", "/dev/sda"], 0x7fff0a8aa528 /* 24 vars */) = 0
brk(NULL)                               = 0x55ac519e8000
...
stat("/home/abix/.magic.mgc", 0x7fff8b212240) = -1 ENOENT (No such file or directory)
stat("/home/abix/.magic", 0x7fff8b212240) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/etc/magic.mgc", O_RDONLY) = -1 ENOENT (No such file or directory)
stat("/etc/magic", {st_mode=S_IFREG|0644, st_size=111, ...}) = 0
openat(AT_FDCWD, "/etc/magic", O_RDONLY) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=111, ...}) = 0
read(3, "# Magic local data for file(1) c"..., 4096) = 111
read(3, "", 4096)                       = 0
close(3)                                = 0
openat(AT_FDCWD, "/usr/share/misc/magic.mgc", O_RDONLY) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=5811536, ...}) = 0
mmap(NULL, 5811536, PROT_READ|PROT_WRITE, MAP_PRIVATE, 3, 0) = 0x7f8f758b9000
close(3)                                = 0
mprotect(0x7f8f758b9000, 5811536, PROT_READ) = 0
openat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/gconv/gconv-modules.cache", O_RDONLY) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=27002, ...}) = 0
mmap(NULL, 27002, PROT_READ, MAP_SHARED, 3, 0) = 0x7f8f758b2000
close(3)                                = 0
futex(0x7f8f76395634, FUTEX_WAKE_PRIVATE, 2147483647) = 0
fstat(1, {st_mode=S_IFCHR|0620, st_rdev=makedev(0x88, 0x2), ...}) = 0
mmap(NULL, 1052672, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f8f757b1000
lstat("/dev/sda", {st_mode=S_IFBLK|0660, st_rdev=makedev(0x8, 0), ...}) = 0
munmap(0x7f8f757b1000, 1052672)         = 0
write(1, "/dev/sda: block special (8/0)\n", 30/dev/sda: block special (8/0)
) = 30
munmap(0x7f8f758b9000, 5811536)         = 0
exit_group(0)                           = ?
+++ exited with 0 +++
abix@s3:~$ ls -la /usr/share/misc/magic.mgc
lrwxrwxrwx 1 root root 24 Jan 16  2020 /usr/share/misc/magic.mgc -> ../../lib/file/magic.mgc
```

3. Основываясь на знаниях о перенаправлении потоков предложите способ обнуления открытого удаленного файла (чтобы освободить место на файловой системе).

   **Ответ:**
```shell
abix@s3:~$ lsof -p 3229
...
vi      322944 abix    3u   REG  253,0    12288  393665 /home/abix/.test.txt.swp  (deleted)
abix@s3:~$ echo '' > /proc/322944/fd/3 
```

4. Занимают ли зомби-процессы какие-то ресурсы в ОС (CPU, RAM, IO)?

   **Ответ:** из Вики - "Зомби не занимают памяти (как процессы-сироты), но блокируют записи в таблице процессов, размер которой ограничен для каждого пользователя и системы в целом." 

5. В iovisor BCC есть утилита opensnoop:

   **Ответ:** не понял вопроса, но в первые секунды увидел вот это:
```shell
abix@s3:~$ sudo /usr/sbin/opensnoop-bpfcc
PID    COMM               FD ERR PATH
652    multipathd          8   0 /sys/devices/pci0000:00/0000:00:10.0/host32/target32:0:0/32:0:0:0/state
652    multipathd          8   0 /sys/devices/pci0000:00/0000:00:10.0/host32/target32:0:0/32:0:0:0/block/sda/size
652    multipathd          8   0 /sys/devices/pci0000:00/0000:00:10.0/host32/target32:0:0/32:0:0:0/state
652    multipathd         -1   2 /sys/devices/pci0000:00/0000:00:10.0/host32/target32:0:0/32:0:0:0/vpd_pg80
969503 systemd-journal    10   0 /proc/652/status
969503 systemd-journal    10   0 /proc/652/status
969503 systemd-journal    10   0 /proc/652/comm
969503 systemd-journal    10   0 /proc/652/cmdline
969503 systemd-journal    10   0 /proc/652/status
969503 systemd-journal    10   0 /proc/652/attr/current
969503 systemd-journal    10   0 /proc/652/sessionid
652    multipathd         -1   2 /sys/devices/pci0000:00/0000:00:10.0/host32/target32:0:0/32:0:0:0/vpd_pg83
969503 systemd-journal    10   0 /proc/652/loginuid
969503 systemd-journal    10   0 /proc/652/cgroup
969503 systemd-journal    -1   2 /run/systemd/units/log-extra-fields:multipathd.service
969503 systemd-journal    -1   2 /run/log/journal/591d5b9db6804601a18869bd9ed803a8/system.journal
969503 systemd-journal    -1   2 /run/log/journal/591d5b9db6804601a18869bd9ed803a8/system.journal
969503 systemd-journal    -1   2 /run/log/journal/591d5b9db6804601a18869bd9ed803a8/system.journal
969503 systemd-journal    -1   2 /run/log/journal/591d5b9db6804601a18869bd9ed803a8/system.journal
```

6. Какой системный вызов использует uname -a? Приведите цитату из man по этому системному вызову, где описывается альтернативное местоположение в /proc, где можно узнать версию ядра и релиз ОС. 

   **Ответ:** Пришлось устанавливать manpages-dev. Part of the utsname information is also accessible  via  /proc/sys/ker‐
nel/{ostype, hostname, osrelease, version, domainname}.

7. Чем отличается последовательность команд через ; и через && в bash?

   **Ответ:** `&&` - условный оператор, а `;` - разделитель последовательных команд. `test -d /tmp/some_dir && echo Hi` - команда `echo` отработает только при успешном завершении команды `test`. 
`set -e` - прервет последовательность команд при ошибке в любой команде кроме последней
   
   Считаю что использование `set -e` не имеет никакого смысла в примере выше.

```shell
abix@s3:~$ false && true
abix@s3:~$ echo $?
1
abix@s3:~$ (false && true)
abix@s3:~$ echo $?
1
abix@s3:~$ set -e
abix@s3:~$ false && true
abix@s3:~$ echo $?
1
abix@s3:~$ (false && true)
<shell died>
```

8. Из каких опций состоит режим bash `set -euxo pipefail` и почему его хорошо было бы использовать в сценариях?

   **Ответ:** 
   - `-e` прерывает последовательность команд кроме последней
   - `-x` трейсинг простых команд
   - `-u` неустановленные/не заданные параметры и переменные считаются как ошибки, с выводом в stderr текста ошибки и выполнит завершение неинтерактивного вызова
   - `-o pipefail` возвращает код возврата набора/последовательности команд, ненулевой при последней команды или 0 для успешного выполнения команд.
   
9. Используя -o stat для ps, определите, какой наиболее часто встречающийся статус у процессов в системе. В man ps ознакомьтесь (/PROCESS STATE CODES) что значат дополнительные к основной заглавной буквы статуса процессов. Его можно не учитывать при расчете (считать S, Ss или Ssl равнозначными).
   
   **Ответ:** Самые частые:
   - S,S+,Ss,Ssl,Ss+ - Процессы ожидающие завершения (прерываемый сон)
   - I,I< - неактивные процессы ядра
   - дополнительные символы прочие характеристики процесса

```
       Here are the different values that the s, stat and state output specifiers (header "STAT" or "S") will display to describe the state of a process:

               D    uninterruptible sleep (usually IO)
               I    Idle kernel thread
               R    running or runnable (on run queue)
               S    interruptible sleep (waiting for an event to complete)
               T    stopped by job control signal
               t    stopped by debugger during the tracing
               W    paging (not valid since the 2.6.xx kernel)
               X    dead (should never be seen)
               Z    defunct ("zombie") process, terminated but not reaped by its parent

       For BSD formats and when the stat keyword is used, additional characters may be displayed:

               <    high-priority (not nice to other users)
               N    low-priority (nice to other users)
               L    has pages locked into memory (for real-time and custom IO)
               s    is a session leader
               l    is multi-threaded (using CLONE_THREAD, like NPTL pthreads do)
               +    is in the foreground process group
```
