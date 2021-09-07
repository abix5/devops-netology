Домашнее задание к занятию «3.1. Работа в терминале, лекция 1»

4.На компьютерах с процессорами `M1` не поддерживается работа `VirtualBox`.
```shell
dmitriynenashev@MacBook-Pro-Dmitriy-2 01-terminal % vagrant up
Bringing machine 'default' up with 'virtualbox' provider...
==> default: Checking if box 'bento/ubuntu-20.04' version '202107.28.0' is up to date...
==> default: Clearing any previously set forwarded ports...
==> default: Clearing any previously set network interfaces...
==> default: Preparing network interfaces based on configuration...
default: Adapter 1: nat
==> default: Forwarding ports...
default: 22 (guest) => 2222 (host) (adapter 1)
==> default: Booting VM...
There was an error while executing `VBoxManage`, a CLI used by Vagrant
for controlling VirtualBox. The command and stderr is shown below.

Command: ["startvm", "ffc675a9-8ff4-43bf-9dbc-0a31225cd207", "--type", "headless"]

Stderr: VBoxManage: error: The virtual machine '01-terminal_default_1630762594137_27901' has terminated unexpectedly during startup with exit code 1 (0x1)
VBoxManage: error: Details: code NS_ERROR_FAILURE (0x80004005), component MachineWrap, interface IMachine
```
Запускал на `ESXi` в итоге Ubuntu. с `Vagrant` знаком хорошо, сейчас не имею под рукой компьютера на х86 архитектуре.

8. `man bash`
  - По умолчанию длинна журнала 500, задать переменной HISTFILESIZE. `Cтрока 699`
  - ignoreboth - сокращение от ignorespace и ignoredups. А те в свою очередь игнорируют запись в историю комманд начинающихся с пробела и дублирования команд в истории.


9. `{}` в оболочке bash служат для обозначения раскрытия перечисляемых значений и подстановке их в итерируемую строку слева на право. `Строку 881`
   

10. Как создать однократным вызовом touch 100000 файлов?
  - `touch test{1..10000}.txt`
  - не получится `-bash: /usr/bin/touch: Argument list too long`, как вариант, но правда медленный можно сделать так `echo $(seq 1 300000) | xargs -n1 touch`


11. `[[ -d /tmp ]]` - это условное, выражение проверяет существование файла и что он является каталогом.
    

12. Используем следующие команды:
  - `mkdir /tmp/new_path_directory`
  - `ln -s /bin/bash /tmp/new_path_directory/bash`
  - `export PATH=/tmp/new_path_directory/:$PATH`


13. Утилита командной строки `at` позволяет планировать выполнение команд в определенное время, но только единожды. Утилита `batch` выполняет команды, когда это позволяет загрузка системы.