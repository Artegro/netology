# Домашнее задание к занятию "7.5. Основы golang"

С `golang` в рамках курса, мы будем работать не много, поэтому можно использовать любой IDE. 
Но рекомендуем ознакомиться с [GoLand](https://www.jetbrains.com/ru-ru/go/).  

## Задача 1. Установите golang.
1. Воспользуйтесь инструкций с официального сайта: [https://golang.org/](https://golang.org/).
2. Так же для тестирования кода можно использовать песочницу: [https://play.golang.org/](https://play.golang.org/).
---------
### Ответ
*   Качаем свежий пакет 
```bash
 wget https://go.dev/dl/go1.18.3.linux-amd64.tar.gz
```
*   Распаковываем в /usr/local и добавляем в переменную PATH путь к исполняемым файлам /usr/local/go/bin
```bash
tar -C /usr/local -xzf go1.18.3.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
```
*   Прокуряем что всё получилось

![image](https://user-images.githubusercontent.com/95859890/178150961-639b2d44-3c4f-467b-989d-24a15f367cc4.png)

---------
## Задача 2. Знакомство с gotour.
У Golang есть обучающая интерактивная консоль [https://tour.golang.org/](https://tour.golang.org/). 
Рекомендуется изучить максимальное количество примеров. В консоли уже написан необходимый код, 
осталось только с ним ознакомиться и поэкспериментировать как написано в инструкции в левой части экрана.  
---------
### Ответ
Выполнил. Тут наверно придется поверить на слова.

---------
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
 
1. Напишите программу, которая найдет наименьший элемент в любом заданном списке, например:
    ```
    x := []int{48,96,86,68,57,82,63,70,37,34,83,27,19,97,9,17,}
    ```
1. Напишите программу, которая выводит числа от 1 до 100, которые делятся на 3. То есть `(3, 6, 9, …)`.

В виде решения ссылку на код или сам код. 
---------
### Ответ

*   Напишите программу для перевода метров в футы.
```bash
package main

import "fmt"

const c = 0.3048

func main() {
	fmt.Print("Enter a foot: ")
	var input float64
	fmt.Scanf("%f", &input)

	output := input * c

	fmt.Println(" Per meter: ", output)
}
```
Вывод 

![image](https://user-images.githubusercontent.com/95859890/178151620-77ddc0f7-d6cb-4ff8-9131-f9020062350e.png)

* Напишите программу, которая найдет наименьший элемент в любом заданном списке. 
```bash
package main

import "fmt"

const c = 0.3048

func main() {
	x := []int{48, 96, 86, 68, 57, 82, 63, 70, 37, 34, 83, 27, 19, 97, 9, 17}
	min := x[0]
	for _, x := range x {
		if x < min {
			min = x
		}
	}
	fmt.Println(min)
}
```
Вывод

![image](https://user-images.githubusercontent.com/95859890/178151818-8af374f8-e808-42f5-9e7d-3ec1bf9768e9.png)

* Напишите программу, которая выводит числа от 1 до 100, которые делятся на 3. 
```bash
package main

import "fmt"

func main() {
	for i := 1; i <= 100; i++ {

		if (i % 3) == 0 {
			fmt.Print(i, ", ")
		}
	}
}
```
Вывод

![image](https://user-images.githubusercontent.com/95859890/178151972-1e527e80-4a7e-40f2-954c-897bc54ae513.png)

---------
## Задача 4. Протестировать код (не обязательно).

Создайте тесты для функций из предыдущего задания. 

---
