# Домашнее задание к занятию "7.5. Основы golang"

## Задача 1. Установите golang.

<details>
<summary>Раскрыть условие задачи</summary>

> 1. Воспользуйтесь инструкций с официального сайта: [https://golang.org/](https://golang.org/).
> 2. Так же для тестирования кода можно использовать песочницу: [https://play.golang.org/](https://play.golang.org/).

</details>

```shell
❯ go version
go version go1.16.4 darwin/arm64
```

## Задача 2. Знакомство с gotour.

Прошел `Basics` и `Methods and interfaces`. `Concurrency` не стал изучать пока.

<details>
<summary>Раскрыть условие задачи</summary>

> У Golang есть обучающая интерактивная консоль [https://tour.golang.org/](https://tour.golang.org/).
> Рекомендуется изучить максимальное количество примеров. В консоли уже написан необходимый код, осталось только с ним ознакомиться и поэкспериментировать как написано в инструкции в левой части экрана.

</details>

## Задача 3. Написание кода.


<details>
<summary>Раскрыть условие задачи</summary>

> Цель этого задания закрепить знания о базовом синтаксисе языка. Можно использовать редактор кода на своем компьютере, либо использовать песочницу: [https://play.golang.org/](https://play.golang.org/).
>
> 1. Напишите программу для перевода метров в футы (1 фут = 0.3048 метр). Можно запросить исходные данные
     > у пользователя, а можно статически задать в коде.
     >     Для взаимодействия с пользователем можно использовать функцию `Scanf`:
     >     ```
>     package main
>     
>     import "fmt"
>     
>     func main() {
>         fmt.Print("Enter a number: ")
>         var input float64
>         fmt.Scanf("%f", &input)
>     
>         output := input * 2
>     
>         fmt.Println(output)    
>     }
>     ```
>
> 1. Напишите программу, которая найдет наименьший элемент в любом заданном списке, например:
     >     ```
>     x := []int{48,96,86,68,57,82,63,70,37,34,83,27,19,97,9,17,}
>     ```
> 1. Напишите программу, которая выводит числа от 1 до 100, которые делятся на 3. То есть `(3, 6, 9, …)`.
>
> В виде решения ссылку на код или сам код.

</details>

### Напишите программу для перевода метров в футы

```go
package main

import "fmt"

func MetertoFeet(m float64) (f float64) {
	f = m * 3.28084
	return
}

func main() {
	fmt.Print("Введите длину в метрах: ")
	var input float64
	fmt.Scanf("%f", &input)

	output := MetertoFeet(input)

	fmt.Printf("В футах это %v\n", output)
}

```

### Напишите программу, которая найдет наименьший элемент в любом заданном списке

```go
package main

import "fmt"
import "sort"

func SearchMin(toSort []int) (minNum int) {
	sort.Ints(toSort)
	minNum = toSort[0]
	return
}

func main() {
	x := []int{13, 6, 154, 17, 53, 81, 63, 7, 164, 24, 18, 47, 91, 29, 4, 74}
	y := SearchMin(x)
	fmt.Printf("Наименьшее число в списке: %v\n", y)
}
```


### Напишите программу, которая выводит числа от 1 до 100, которые делятся на 3

```go
package main

import "fmt"

func MultipleOfThree() (noReminder []int) {
	for i := 1; i <= 100; i++ {
		if i%3 == 0 {
			noReminder = append(noReminder, i)
		}
	}
	return
}

func main() {
	toPrint := MultipleOfThree()
	fmt.Printf("Числа от 1 до 100, которые делятся на 3 без остатка: %v\n", toPrint)
}```

## Задача 4. Протестировать код (не обязательно).

### Тест для программы, переводящей метры в футы

```go
package main

import "testing"

func TestMetertoFeet(t *testing.T) {
	var v float64
	v = MetertoFeet(8)
	if v != 26.24672 {
		t.Error("Expected 26.24672 , got ", v)
	}
}
```

### Тест для программы поиска минимального числа из списка

```go
package main

import "testing"

func TestSearchMin(t *testing.T) {
	var v int
	v = SearchMin([]int{11,16,18,90})
	if v != 11 {
		t.Error("Expected 11, got ", v)
	}
}
```

### Тест для программы поиска чисел, делимых на три, в диапазоне от 1 до 100

```go
package main

import "fmt"
import "testing"

func TestMultipleOfThree(t *testing.T) {
	var v []int
	v = MultipleOfThree()
	if v[4] != 15 || v[18] != 57 {
		s := fmt.Sprintf("Expected values 15 and 57, got %v and %v", v[4], v[18])
		t.Error(s)
	}
}
```

`Пример удачного и неудачного прохождения теста`
```shell
❯ go test
PASS
ok      awesomeProject  0.341s
❯ go test
--- FAIL: TestMultipleOfThree (0.00s)
    program_test.go:11: Expected values 15 and 57, got 20 and 76
FAIL
exit status 1
FAIL    awesomeProject  0.341s

```