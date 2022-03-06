# AIS-3USON backend (Мобильное приложения для ИС "АИС ТриУСОН")[<img alt="get it on Google Play" height="55" src="https://raw.githubusercontent.com/steverichey/google-play-badge-svg/master/img/en_get.svg" />](https://play.google.com/store/apps/details?id=com.ais3uson.app.ais3uson_app)

<img align="right" src="assets/ais-3uson-logo-128.png">

[![Test](https://github.com/Alexqwesa/ais3uson_app/actions/workflows/test.yml/badge.svg)](https://github.com/Alexqwesa/ais3uson_app/actions/workflows/test.yml)
[![codecov](https://codecov.io/gh/Alexqwesa/ais3uson_app/branch/master/graph/badge.svg?token=32VLHP06HD)](https://codecov.io/gh/Alexqwesa/ais3uson_app)

A Flutter mobile backend for [AIS-3USON](https://github.com/Alexqwesa/AIS-3USON)

Это мобильное приложение для ввода услуг в информационной
системе "[АИС ТриУСОН](https://github.com/Alexqwesa/AIS-3USON)" ("Автоматизированная Информационная
Система Учета Услуг Учреждений Социального Обслуживания Населения"). В данном приложении
используются только обезличенные данные обслуживаемых людей, получающих социальные услуги (далее -
получатели СУ).

## Содержание

- [Установка](#установка)
- [Использование](#использование)
- [Реализованные возможности](#реализованные-возможности)
- [TODO](#todo)
- [Разработчики](#разработчики)
- [Лицензия](#лицензия)

## Установка

- Установите пароль для пользователя web_user в вашей SQL базе данных (в установочных скриптах
  AIS-3USON этому пользователю назначены минимально необходимые привилегии).
- Установите скрипт WEB-сервера AIS-3USON и пароль в соответствии с
  инструкцией ([ссылка на скрипт и инструкцию](https://github.com/Alexqwesa/AIS-3USON/blob/main/src/worker/web_worker/ais3uson_www.py))
  .
- Рекомендуется использовать разные серверы для SQL-сервера и WEB-сервера, установите безопасное
  соединение между SQL-сервером и WEB-сервером, рекомендуется использовать перенаправление портов с
  помощью openSSH (man ssh или [подробное руководство на русском](https://habr.com/ru/post/331348/))
  .
  <img align="right" src="qrcode_ais3uson_app_on_google_play.png" width="180">
- Работники:
    - устанавливают
      приложение, [>>> установить из каталога Google <<<](https://play.google.com/store/apps/details?id=com.ais3uson.app.ais3uson_app)
      ,
    - // Заведующие предоставляют работникам сгенерированный в
      приложении [АИС ТриУСОН](https://github.com/Alexqwesa/AIS-3USON) Qr код,
    - работник запускают приложение и нажимают кнопку **+** (сканировать Qr-код).

## Использование

Данное приложение является дополнением для информационной системы "АИС ТриУСОН", и его использование
неразрывно связано с основным приложением.

**Заведующие** отделениями работают с полноценным клиентом "АИС ТриУСОН", и в их обязанности входит:

- предоставляют работникам QR коды для авторизации в данном приложении,
- назначить работнику обслуживаемых получателей СУ,

**Работники:**

- устанавливают приложение на своем мобильном
  устройстве( [ссылка для установки](https://play.google.com/store/apps/details?id=com.ais3uson.app.ais3uson_app) )
  ,
- сканируют Qr-код(предоставленный заведующим отделением/менеджером),
- вводят услуги по мере их оказания,
- периодически (или постоянно) подключаются к интернету для синхронизации данных приложения(не реже
  раза в сутки).

Для не поддерживаемых ОС, также в целях проверки - доступно
web-приложение ( [https://alexqwesa.github.io/web3uson/](https://alexqwesa.github.io/web3uson/)
).

<img  src="qr_web3uson.png">

## Реализованные возможности:

- [x] Добавление отделения (авторизация) по Qr-коду (и по строке текста)
- [x] Добавление тестового отделения
- [x] Работа с обезличенными данными клиентов (реализовано на стороне SQL сервера)
- [x] Отравка услуг в СУБД с подтверждением (уникальный uuid каждой записи)
- [x] Работа онлайн и оффлайн (1 раз в день обязательная синхронизация)
- [x] Прикрепление к услуге изображений-подтверждений (хранятся локально)
- [x] Журнал введенных услуг за день
- [x] Архивирование услуг введенных в предыдущие дни
- [x] Просмотр архива услуг
- [x] Проверка переполнения положенных услуг
- [x] Резервное копирование ключей авторизации в облако
- [x] Удаление услуг (только сегодняшних)
- [x] Настраиваемый вид списка услуг
- [x] Защищенные соединения (https), нужно только добавить ssl сертификат и ключ на web-сервер (
  можно использовать и самоподписанный сертификат, если добавить его в QR-код, однако данный способ
  не работает в браузерах)
- [x] Доступно для скачивания
  на [Google Play Market](https://play.google.com/store/apps/details?id=com.ais3uson.app.ais3uson_app)

## TODO:

- [ ] услуги по типам
- [ ] индикатор обновления?
- [ ] Резервный способ сбора и хранения услуг (на случай недоступности mysql сервера), shadow
  server?
- [ ] Резервный web-сервер(WorkerKey allow several servers (comma separated list))
- [ ] Показ общего колличества услуг по дням
- [ ] Настраиваемый размер виджетов
- [ ] Повышенный уровень защиты: SSL Pinning
- [ ] Напоминание о необходимости синхронизации
- [ ] Кнопка: Синхронизировать ВСЕ!
- [ ] Кнопка: Поделится ?
- [ ] dynamic setting from BD: allow collect proofs, etc...
- [ ] maybe backup media data? only on full backup?
- [ ] использовать темы для изменения размера шрифта
- [ ] дополнительные ограничения доступных услуг?
- [ ] сообщения от заведующих (по группам работников, одному, всем)
- [ ] закончившиеся услуги - в конец списка?
- [ ] вводить услуги жестом, а не onTap ??? (оказанные услуги в конец списка после разделителя)
- [ ] Хранить все данные о вводе в архиве ввода(запретить загрузку по сети)
- [ ] Кнопка получения архива ввода
- [ ] 2 секунды на отмену ввода услуги или журнал введенных сегодня услуг с возможностью отмены?
- [ ] try autoreconnect few times(with timeout) if there is a problem with network
- [ ] add server tests
- [ ] use badges
- [ ] tutorial
- [ ] translations
- [ ] export to csv file
- [ ] split AppData?
- [ ] настраиваемый размер карточек услуг
- [ ] use bloc/getx/get_it/...

## Разработчики

[@Alexqwesa](https://github.com/Alexqwesa) aka Savin Aleksander Viktorovich (Савин Александр
Викторович)

### [Документация для разработчиков](https://alexqwesa.github.io/ais3uson_app/)

- [Автоматически сгенерированная документация для разработчиков](https://alexqwesa.github.io/ais3uson_app/)

## Лицензия

[LGPLv3](LICENSE) © Savin Aleksander Viktorovich (Савин Александр Викторович)

### Используемые в программе ресурсы

Изображения в папке images получены с сервиса [www.flaticon.com](http://www.flaticon.com), в
соответствии требованиями сервиса, размещены ссылки:

- Some Icons in folder *images* made by authors: [Freepik](http://www.freepik.com)
  , [Smashicons](http://www.flaticon.com/authors/smashicons)
  , [DinosoftLabs](https://www.flaticon.com/authors/dinosoftlabs)
  , [zafdesign](https://www.flaticon.com/authors/zafdesign)
  , [GOWI](https://www.flaticon.com/authors/GOWI)
  , [Konkapp](https://www.flaticon.com/authors/Konkapp)
  , [photo3idea_studio](https://www.flaticon.com/authors/photo3idea_studio)
  , [monkik](https://www.flaticon.com/authors/monkik)
  , [Payungkead](https://www.flaticon.com/authors/Payungkead)
  , [Eucalyp](https://www.flaticon.com/authors/Eucalyp)
  , [kosonicon](https://www.flaticon.com/authors/kosonicon)
  , [wanicon](https://www.flaticon.com/authors/wanicon)
  from [www.flaticon.com](http://www.flaticon.com)

These images belongs to its owners, I
am [allowed to use them](https://web.archive.org/web/20211109140855/https://support.flaticon.com/hc/en-us/articles/207248209)
in this project by permission of service [www.flaticon.com](http://www.flaticon.com) (here
is [license](images/_license.pdf)).
