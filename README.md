# AIS-3USON backend (Мобильное приложения для ИС "АИС ТриУСОН")
<img align="right" src="assets/ais-3uson-logo-128.png">
[![Build Status](https://github.com/Alexqwesa/ais3uson_app/workflows/Test/badge.svg)](https://github.com/dart-lang/dartdoc/actions?query=workflow%3ATest)
[![Coverage Status](https://coveralls.io/repos/github/dart-lang/dartdoc/badge.svg?branch=master)](https://coveralls.io/github/dart-lang/dartdoc?branch=master)
A Flutter mobile backend for [AIS-3USON](https://github.com/Alexqwesa/AIS-3USON)

Это мобильное приложение для ввода услуг в информационной системе "[АИС ТриУСОН](https://github.com/Alexqwesa/AIS-3USON)" ("Автоматизированная Информационная Система Учета Услуг Учреждений Социального Обслуживания Населения").
В данном приложении используются только обезличенные данные обслуживаемых людей, получающих социальные услуги (далее - получатели СУ).

## Содержание
- [Установка](#установка)
- [Использование](#использование)
- [Реализованные возможности](#реализованные-возможности)
- [TODO](#todo)
- [Разработчики](#разработчики)
- [Лицензия](#лицензия)

## Установка

- Установите пароль для пользователя web_user в вашей SQL базе данных (в установочных скриптах AIS-3USON этому пользователю назначены минимально необходимые привилегии).
- Установите скрипт WEB-сервера AIS-3USON и пароль в соответствии с инструкцией ([ссылка на скрипт и инструкцию](https://github.com/Alexqwesa/AIS-3USON/blob/main/src/worker/web_worker/ais3uson_www.py)).
- Рекомендуется использовать разные серверы для SQL-сервера и WEB-сервера, установите безопасное соединение между SQL-сервером и WEB-сервером, рекомендуется использовать перенаправление портов с помощью openSSH (man ssh или [подробное руководство на русском](https://habr.com/ru/post/331348/)).
- Работники: 
  - устанавливают приложение (здесь будут ссылки для установки), 
  - // Заведующие предоставляют работникам сгенерированный в приложении [АИС ТриУСОН](https://github.com/Alexqwesa/AIS-3USON) Qr код,
  - работник запускают приложение и нажимают кнопку **+** (сканировать Qr-код). 

## Использование

Данное приложение является дополнением для информационной системы "АИС ТриУСОН", и его использование неразрывно связано с основным приложением.  

**Заведующие** отделениями работают с полноценным клиентом "АИС ТриУСОН", и в их обязанности входит:
- предоставляют работникам QR коды для авторизации в данном приложении,
- назначить работнику обслуживаемых получателей СУ,

**Работники:**
- устанавливают приложение на своем мобильном устройстве(ссылка для установки),
- сканируют Qr-код(у заведующих),
- вводят услуги по мере их оказания,
- периодически (или постоянно) подключаются к интернету для синхронизации данных приложения.

## Реализованные возможности:
- [x] Добавление отделения (авторизация) по Qr-коду
- [x] Работа с обезличенными данными клиентов (реализовано на стороне SQL сервера)
- [x] Отравка услуг в СУБД с подтверждением (уникальный uuid каждой записи)
- [x] Работа онлайн и оффлайн (1 раз в день обязательная синхронизация)
- [x] Прикрепление к услуге изображений-подтверждений (хранятся локально)
- [x] Журнал введенных услуг за день
- [x] Архивирование услуг введенных в предыдущие дни
- [x] Проверка переполнения положенных услуг
- [x] Резервное копирование ключей авторизации в облако
- [x] Удаление услуг (только сегодняшних)
- [x] Просмотр архива услуг
- [x] Добавление отделения (авторизация) по строке

## TODO:
- [ ] Настраиваемый вид списка услуг
- [ ] Напоминание о необходимости синхронизации
- [ ] Кнопка: Синхронизировать ВСЕ!
- [ ] Кнопка: Поделится ?
- [ ] dynamic setting from BD: allow collect proofs, etc...
- [ ] WorkerKey allow several servers (comma separated list)
- [ ] maybe backup media data? only on full backup?
- [ ] use ssl, maybe use Dio?
- [ ] Distribute via Google Play
- [ ] использовать темы для изменения размера шрифта
- [ ] индикатор обновления?
- [ ] услуги по типам
- [ ] дополнительные ограничения доступных услуг?
- [ ] сообщения от заведующих (по группам работников, одному, всем)
- [ ] закончившиеся услуги - в конец списка?
- [ ] вводить услуги жестом, а не onTap ???
- [ ] 2 секунды на отмену ввода услуги или журнал введенных сегодня услуг с возможностью отмены?
- [ ] try autoreconnect few times(with timeout) if there is a problem with network

## Разработчики

[@Alexqwesa](https://github.com/Alexqwesa) aka Savin Aleksander Viktorovich (Савин Александр Викторович)

## Лицензия
[LGPLv3](LICENSE) © Savin Aleksander Viktorovich (Савин Александр Викторович)

### Используемые в программе ресурсы
Изображения в папке images получены с сервиса [www.flaticon.com](http://www.flaticon.com), в соответствии требованиями сервиса, размещены ссылки:
- Some Icons in folder *images* made by [Freepik](http://www.freepik.com)
  from [www.flaticon.com](http://www.flaticon.com)
- Some Icons in folder *images* made by [Smashicons](http://www.flaticon.com/authors/smashicons)
  from [www.flaticon.com](http://www.flaticon.com)
- Some Icons in folder *images* made
  by [DinosoftLabs](https://www.flaticon.com/authors/dinosoftlabs)
  from [www.flaticon.com](http://www.flaticon.com)
- Some Icons in folder *images* made by [zafdesign](https://www.flaticon.com/authors/zafdesign)
  from [www.flaticon.com](http://www.flaticon.com)
- Some Icons in folder *images* made by [GOWI](https://www.flaticon.com/authors/GOWI)
  from [www.flaticon.com](http://www.flaticon.com)
- Some Icons in folder *images* made by [Konkapp](https://www.flaticon.com/authors/Konkapp)
  from [www.flaticon.com](http://www.flaticon.com)
- Some Icons in folder *images* made
  by [photo3idea_studio](https://www.flaticon.com/authors/photo3idea_studio)
  from [www.flaticon.com](http://www.flaticon.com)
- Some Icons in folder *images* made by [monkik](https://www.flaticon.com/authors/monkik)
  from [www.flaticon.com](http://www.flaticon.com)
- Some Icons in folder *images* made by [Payungkead](https://www.flaticon.com/authors/Payungkead)
  from [www.flaticon.com](http://www.flaticon.com)
- Some Icons in folder *images* made by [Eucalyp](https://www.flaticon.com/authors/Eucalyp)
  from [www.flaticon.com](http://www.flaticon.com)
- Some Icons in folder *images* made by [kosonicon](https://www.flaticon.com/authors/kosonicon)
  from [www.flaticon.com](http://www.flaticon.com)
- Some Icons in folder *images* made by [wanicon](https://www.flaticon.com/authors/wanicon)
  from [www.flaticon.com](http://www.flaticon.com)

These images belongs to its owners, I am [allowed to use them](https://web.archive.org/web/20211109140855/https://support.flaticon.com/hc/en-us/articles/207248209) in this project by permission of service [www.flaticon.com](http://www.flaticon.com) (here is [license](images/license.pdf)).