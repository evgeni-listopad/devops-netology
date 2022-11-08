# Домашнее задание к занятию "7.5. Основы golang"

С `golang` в рамках курса, мы будем работать не много, поэтому можно использовать любой IDE. 
Но рекомендуем ознакомиться с [GoLand](https://www.jetbrains.com/ru-ru/go/).  

## Задача 1. Установите golang.
1. Воспользуйтесь инструкций с официального сайта: [https://golang.org/](https://golang.org/).
2. Так же для тестирования кода можно использовать песочницу: [https://play.golang.org/](https://play.golang.org/).

### Решение задачи 1
Golang установлен из [файла](https://go.dev/dl/go1.19.3.linux-amd64.tar.gz)
```
 00:34:50 @ ~/golang []
└─ #  go version
go version go1.19.3 linux/amd64
```

## Задача 2. Знакомство с gotour.
У Golang есть обучающая интерактивная консоль [https://tour.golang.org/](https://tour.golang.org/). 
Рекомендуется изучить максимальное количество примеров. В консоли уже написан необходимый код, 
осталось только с ним ознакомиться и поэкспериментировать как написано в инструкции в левой части экрана.  

### Решение задачи 2
Примеры изучены

## Задача 3. Написание кода. 
Цель этого задания закрепить знания о базовом синтаксисе языка. Можно использовать редактор кода 
на своем компьютере, либо использовать песочницу: [https://play.golang.org/](https://play.golang.org/).

1. Напишите программу для перевода метров в футы (1 фут = 0.3048 метр). Можно запросить исходные данные 
у пользователя, а можно статически задать в коде.
    Для взаимодействия с пользователем можно использовать функцию `Scanf`:
    ```
    package main
    
    import "fmt"
    
    func main() {
        fmt.Print("Enter a number: ")
        var input float64
        fmt.Scanf("%f", &input)
    
        output := input * 2
    
        fmt.Println(output)    
    }
    ```

### Решение задачи 3.1
```
 00:34:57 @ ~/golang []
└─ #  cat task3.1.go
package main

import "fmt"

func Transform(meter float64) float64 {
    return meter * 3.28084
}

func main() {
    fmt.Print("Please, enter the length in meters: ")
    var input float64
    fmt.Scanf("%f", &input)

    output := Transform(input)

    fmt.Println("The length in feet is ", output)
}
 00:38:22 @ ~/golang []
└─ #
 00:38:23 @ ~/golang []
└─ #  go run task3.1.go
Please, enter the length in meters: 12.68
The length in feet is  41.6010512
```
 
2. Напишите программу, которая найдет наименьший элемент в любом заданном списке, например:
    ```
    x := []int{48,96,86,68,57,82,63,70,37,34,83,27,19,97,9,17,}
    ```

### Решение задачи 3.2
```
 00:43:09 @ ~/golang []
└─ #  cat task3.2.go
package main

import "fmt"

func Minimum(sl []int) int {
    min := sl[0]
    for i := 1; i < len(sl); i++ {
        if sl[i] < min {
            min = sl[i]
        }
    }
    return min
}

func main() {
    x := []int{48, 96, 86, 68, 57, 82, 63, 70, 37, 34, 83, 27, 19, 97, 9, 17}
    fmt.Println("The minimum element in the list is ", Minimum(x))
}
 00:43:15 @ ~/golang []
└─ #  go run task3.2.go
The minimum element in the list is  9
```

3. Напишите программу, которая выводит числа от 1 до 100, которые делятся на 3. То есть `(3, 6, 9, …)`.

В виде решения ссылку на код или сам код. 

### Решение задачи 3.3
```
 01:03:40 @ ~/golang []
└─ #  cat task3.3.go
package main

import "fmt"

func Compute1() (Res []int) {
        for i := 3; i <= 100; i += 3 {
                Res = append(Res, i)
        }
        return
}

func main() {

        s := Compute1()
        fmt.Println(s)
}
 01:03:47 @ ~/golang []
└─ #  go run task3.3.go
[3 6 9 12 15 18 21 24 27 30 33 36 39 42 45 48 51 54 57 60 63 66 69 72 75 78 81 84 87 90 93 96 99]
```
Или другим способом:
```
 01:06:30 @ ~/golang []
└─ #  cat task3.3_.go
package main

import "fmt"

func Compute2() (Res []int) {
        for i := 1; i <= 100; i++ {
                if i%3 == 0 {
                         Res = append(Res, i)
                }
        }
        return
}

func main() {

        s := Compute2()
        fmt.Println(s)
}
 01:06:32 @ ~/golang []
└─ #  go run task3.3_.go
[3 6 9 12 15 18 21 24 27 30 33 36 39 42 45 48 51 54 57 60 63 66 69 72 75 78 81 84 87 90 93 96 99]
```

## Задача 4. Протестировать код (не обязательно).

Создайте тесты для функций из предыдущего задания. 

### Решение задачи 4.
1. Тест для задачи 3.1 (функция Transform):
```
 01:41:06 @ ~/golang []
└─ #  cat task3.1_test.go
package main

import "testing"

func TestMain(t *testing.T) {
     var test float64
     test = Transform(1)
     if test != 3.28084 {
          t.Error("Expected 3.28084, got ", test)
     }
}
 01:41:22 @ ~/golang []
└─ #  go test task3.1.go task3.1_test.go
ok      command-line-arguments  0.003s
```
2. Тест для задачи 3.2 (функция Minimum)
```
 01:46:47 @ ~/golang []
└─ #  cat task3.2_test.go
package main

import "testing"

func TestMain(t *testing.T) {
     test := Minimum([]int{10, 5, 2, 18, 90})
     if test != 2 {
          t.Error("Right result must be 2, but it is ", test)
     }
}
 01:46:58 @ ~/golang []
└─ #  go test task3.2.go task3.2_test.go
ok      command-line-arguments  0.003s
```
3. Тест для задачи 3.3 (функция Compute1)
```
 02:04:16 @ ~/golang []
└─ #  cat task3.3_test.go
package main

import "testing"

func TestMain(t *testing.T) {
        var test []int
        test = Compute1()
        if test[0] != 3 || test[32] != 99 {
                t.Error("Expected the first element is 3, got ", test[0])
        }
}
 02:04:29 @ ~/golang []
└─ #  go test task3.3.go task3.3_test.go
ok      command-line-arguments  0.003s
```
4. Тест для задачи 3.3 (функция Compute2)
```
 02:05:53 @ ~/golang []
└─ #  cat task3.3__test.go
package main

import "testing"

func TestMain(t *testing.T) {
        var test []int
        test = Compute2()
        if test[0] != 3 || test[32] != 99 {
                t.Error("Expected the first element is 3, got ", test[0])
        }
}
 02:05:57 @ ~/golang []
└─ #  go test task3.3_.go task3.3__test.go
ok      command-line-arguments  0.002s
```

