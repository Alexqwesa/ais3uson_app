# AIS-3USON backend (Мобильное приложения для ИС "АИС ТриУСОН")
<img align="right" src="assets/ais-3uson-logo-128.png">

A Flutter mobile backend for AIS-3USON

Это мобильное приложение для ввода услуг в информационной системе "АИС ТриУСОН" ("Автоматизированная Информационная Система Учета Услуг Учреждений Социального Обслуживания Населения").
В данном приложении используются только обезличенные данные обслуживаемых людей, получающих социальные услуги (далее - получатели СУ).

## Содержание
- [Установка](#установка)
- [Использование](#использование)
- [TODO](#todo)
- [Разработчики](#разработчики)
- [Лицензия](#лицензия)

## Установка

- Установите пароль для пользователя web_user в вашей SQL базе данных (в установочных скриптах AIS-3USON этому пользователю назначены минимально необходимые привилегии).
- Установите скрипт WEB-сервера AIS-3USON и пароль в соответствии с инструкцией ([ссылка на скрипт и инструкцию](https://github.com/Alexqwesa/AIS-3USON/blob/main/src/worker/web_worker/ais3uson_www.py)).
- Рекомендуется использовать разные серверы для SQL-сервера и WEB-сервера, установите безопасное соединение между SQL-сервером и WEB-сервером, рекомендуется использовать перенаправление портов с помощью openSSH (здесь будет инструкция).
- Работники устанавливают приложение (здесь будут ссылки для установки), приходят к заведующим, запускают его и нажимают кнопку + (сканировать Qr код) . Заведующие предоставляют работникам сгенерированный в приложении АИС ТриУСОН Qr код.

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

## TODO:
- [x] Write README
- [x] Use provider
- [x] Services input
- [x] Journal
- [x] Logo
- [x] удаление отделений
- [x] Snackbar для сообщений и ошибок
- [x] rework network error handling
- [ ] Store userKeys in Cloud? 
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

[@Alexqwesa](https://github.com/Alexqwesa).

## Лицензия
[LGPLv3](LICENSE) © Savin Aleksander Viktorovich (Савин Александр Викторович)

### Используемые в программе ресурсы
Изображения в папке images получены с сервиса [www.flaticon.com](http://www.flaticon.com), в соответствии требованиями сервиса, размещены ссылки:
- Some Icons in folder *images* made by [Freepik](http://www.freepik.com) from [www.flaticon.com](http://www.flaticon.com)
- Some Icons in folder *images* made by [Smashicons](http://www.flaticon.com/authors/smashicons) from [www.flaticon.com](http://www.flaticon.com)
- Some Icons in folder *images* made by [DinosoftLabs](https://www.flaticon.com/authors/dinosoftlabs) from [www.flaticon.com](http://www.flaticon.com)

These images belongs to its owners, I am [allowed to use them](https://web.archive.org/web/20211109140855/https://support.flaticon.com/hc/en-us/articles/207248209) in this project by permission of service [www.flaticon.com](http://www.flaticon.com) (here is [license](images/license.pdf)).