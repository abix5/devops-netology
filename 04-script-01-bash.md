# Домашнее задание к занятию "4.1. Командная оболочка Bash: Практические навыки"

## Обязательная задача 1

Есть скрипт:
```bash
a=1
b=2
c=a+b
d=$a+$b
e=$(($a+$b))
```

Какие значения переменным c,d,e будут присвоены? Почему?

| Переменная  | Значение | Обоснование                                                    |
| ------------- |----------|----------------------------------------------------------------|
| `c`  | "a+b"    | Присваиваем строку а не переменные                             |
| `d`  | "1+2"    | Подставляем значение переаменных в строку                      |
| `e`  | 3        | Подставляем значение переменных и благодаря "((..))" вычисляем |


## Обязательная задача 2
На нашем локальном сервере упал сервис и мы написали скрипт, который постоянно проверяет его доступность, записывая дату проверок до тех пор, пока сервис не станет доступным (после чего скрипт должен завершиться). В скрипте допущена ошибка, из-за которой выполнение не может завершиться, при этом место на Жёстком Диске постоянно уменьшается. Что необходимо сделать, чтобы его исправить:
```diff
- while ((1==1)
+ while ((1==1))
do
	curl https://localhost:4757
	if (($? != 0))
	then
-         date >> curl.log
+         date > curl.log
+	else
+         exit 0
	fi
done
```

Необходимо написать скрипт, который проверяет доступность трёх IP: `192.168.0.1`, `173.194.222.113`, `87.250.250.242` по `80` порту и записывает результат в файл `log`. Проверять доступность необходимо пять раз для каждого узла.

### Ваш скрипт:
```bash
#!/usr/bin/env bash
ips=(192.168.0.1 173.194.222.113 87.250.250.242)
for x in {1..5}
  do
    for y in ${ips[@]}
      do
        curl -s --connect-timeout 10 $y:80 2>&1 >/dev/null
      if [ $? == 0 ]; then
        echo $y" is available "$(date) >> available.log
      else 
        echo $y" is not available "$(date) >> available.log
      fi
    done
  done
```

## Обязательная задача 3
Необходимо дописать скрипт из предыдущего задания так, чтобы он выполнялся до тех пор, пока один из узлов не окажется недоступным. Если любой из узлов недоступен - IP этого узла пишется в файл error, скрипт прерывается.

### Ваш скрипт:
```bash
#!/usr/bin/env bash
ips=(192.168.0.1 173.194.222.113 87.250.250.242)
while ((1==1))
  do
    for y in ${ips[@]}
      do
        curl -s --connect-timeout 10 $y:80 2>&1 >/dev/null
      if [ $? != 0 ]; then
        echo $y"  "$(date)>> error.log
        exit      
      fi
    done
  done
```

## Дополнительное задание (со звездочкой*) - необязательно к выполнению

Мы хотим, чтобы у нас были красивые сообщения для коммитов в репозиторий. Для этого нужно написать локальный хук для git, который будет проверять, что сообщение в коммите содержит код текущего задания в квадратных скобках и количество символов в сообщении не превышает 30. Пример сообщения: \[04-script-01-bash\] сломал хук.

### Ваш скрипт:
```bash
#!/usr/bin/env bash

MSG="$(cat $1)"
find_str='(\[*\])'
if ! grep -qE "$find_str" "$1"; then
  echo "The message should have been in the format [task] commission message "
  exit 1
elif [ "${#MSG}" -gt "30" ]; then
  echo "Message must be shorter than 30 characters"
  exit 1
fi
```
