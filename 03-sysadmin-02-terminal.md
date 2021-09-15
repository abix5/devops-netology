Домашнее задание к занятию «3.2. Работа в терминале, лекция 2»

1. Какого типа команда cd?
   
**Ответ:** 
```shell
abix@s3:~$ type cd
cd is a shell builtin
```

2. Какая альтернатива без pipe команде `grep <some_string> <some_file> | wc -l`?

**Ответ:** `grep s3 readonlybitrix.json -c`

3. Какой процесс с `PID 1` является родителем для всех процессов?

**Ответ:** 
```shell
abix@s3:~$ ps p 1
    PID TTY      STAT   TIME COMMAND
      1 ?        Ss    10:17 /lib/systemd/systemd --system --deserialize 33
abix@s3:~$ pstree -a
systemd --system --deserialize 33
  ├─VGAuthService
  ├─accounts-daemon
  │   └─2*[{accounts-daemon}]
  ├─atd -f
  ├─cron -f
  ....   
   
   ```
4. Как будет выглядеть команда, которая перенаправит вывод `stderr` ls на другую сессию терминала?

**Ответ:**
```shell
abix@s3:~$ ls ./file 2>/dev/pts/1

temp@s3:~$ ls: cannot access './file': No such file or directory
```

5. Получится ли одновременно передать команде файл на `stdin` и вывести ее `stdout` в другой файл? Приведите работающий пример.

**Ответ:**
```shell
abix@s3:~$ cat <file.txt >file2.txt
abix@s3:~$ cat file2.txt 
Hello World!
abix@s3:~$ 
```
6. Получится ли находясь в графическом режиме, вывести данные из PTY в какой-либо из эмуляторов TTY? Сможете ли вы наблюдать выводимые данные?

**Ответ:**
```shell
#PTY
abix@s3:~$ tty
/dev/pts/2
abix@s3:~$ cat file.txt > /dev/tty1

#TTY
abix@s3:~$ tty
/dev/tty1
abix@s3:~$ Hello World!
```

7. Выполните команду `bash 5>&1`. К чему она приведет? Что будет, если вы выполните `echo netology > /proc/$$/fd/5`? Почему так происходит?

**Ответ:**
```shell
bash 5>&1 - перенаправляем(связываем) вывод файлового дескриптовар номер 5 в стандартный поток вывода.
echo netology > /proc/$$/fd/5 - перенаправялем вывод команды echo в файловый дескриптор 5

в терменале увидим слово netology, т.к. мы связали файловый дескриптор с потоком стандарного вывода.
```

8. Получится ли в качестве входного потока для pipe использовать только `stderr` команды, не потеряв при этом отображение `stdout` на pty?

**Ответ:** Можно и через дескриптор, а можно и так –
```shell
abix@s3:~$ ls -d ./data ./non-existent_file ./other_non-existent_file
ls: cannot access './non-existent_file': No such file or directory
ls: cannot access './other_non-existent_file': No such file or directory
./data
abix@s3:~$ tty
/dev/pts/0
abix@s3:~$ ls -d ./data ./non-existent_file ./other_non-existent_file 2>&1 >/dev/pts/0 | egrep "Doc|other"
./data
ls: cannot access './other_non-existent_file': No such file or directory
```

9. Что выведет команда `cat /proc/$$/environ?` Как еще можно получить аналогичный по содержанию вывод?

**Ответ:** Переменные окружения текущей сессии bash
```shell
root@web:~# printenv
SHELL=/bin/bash
PWD=/root
LOGNAME=root
HOME=/root
LANG=en_US.UTF-8
SSH_CONNECTION=217.173.67.118 62879 185.75.47.65 22
TERM=xterm-256color
USER=root
SHLVL=1
SSH_CLIENT=217.173.67.118 62879 22
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
MAIL=/var/mail/root
SSH_TTY=/dev/pts/0
_=/usr/bin/printenv
```

10. Используя man, опишите что доступно по адресам `/proc/<PID>/cmdline`, `/proc/<PID>/exe`.

**Ответ:**
```
man proc 190 line
/proc/[pid]/cmdline. В этом файле хранится командная строка, которой был запущен данный процесс

man proc 237 line
/proc/[pid]/exe представляет собой символическую ссылку на исполняемый файл, который инициировал запуск процесса
```

11. Узнайте, какую наиболее старшую версию набора инструкций SSE поддерживает ваш процессор с помощью `/proc/cpuinfo`.

**Ответ:** На виртуалке у меня именно 2 сокета, исходя из этого вывод вот такой по первому и второму процессору.
```shell
abix@s3:~$ cat /proc/cpuinfo | grep -oP "(processor.*)|(sse.*?)\s"
processor       : 0
sse 
sse2 
sse3 
sse4_1 
sse4_2 
processor       : 1
sse 
sse2 
sse3 
sse4_1 
sse4_2 
abix@s3:~$ cat /proc/cpuinfo | grep -oP "(sse.*?)\s" | sort -u
sse 
sse2 
sse3 
sse4_1 
sse4_2 
```

12. При открытии нового окна терминала и vagrant ssh создается новая сессия и выделяется pty. Однако `ssh localhost 'tty'` – `not a tty`. Почитайте, почему так происходит, и как изменить поведение.

**Ответ:** Могу предположить вот этот – `config.ssh.pty` (boolean) - If true, pty will be used for provisioning. Defaults to false.

```shell
dmitriynenashev@MacBook-Pro-Dmitriy-2 ~ % vagrant help ssh | grep tty
    -t, --[no-]tty                   Enables tty when executing an ssh command (defaults to true)
        --no-tty                     Enable non-interactive output
 ```

13. Бывает, что есть необходимость переместить запущенный процесс из одной сессии в другую. Попробуйте сделать это, воспользовавшись `reptyr`.

**Ответ:** 
```shell
abix@s3:~$ htop

[1]+  Stopped                 htop
abix@s3:~$ 
```
```shell
abix@s3:~$ tmux
abix@s3:~$ ps -ef | grep htop
abix     4002565 4002169  0 13:21 pts/3    00:00:00 htop
abix     4002574 4000581  0 13:21 pts/2    00:00:00 grep --color=auto htop
abix@s3:~$ reptyr 4002565
```

14. Узнайте что делает команда tee и почему в отличие от `sudo echo` команда с `sudo tee` будет работать.

**Ответ:** Не знаю в чем суть вопроса, но это же очевидно, что в первом случае мы исполняем с повышенными правами только команду `echo` т.е. вывод на экран и потом перенаправляем ее вывод в файл, к которому у нас доступа нет.
Во втором же случае мы исполняем команду `echo` и после повышаем привилегии именно для команды `tee` которая как раз и открывает файл на запись и перенаправляет весь вывод в него.