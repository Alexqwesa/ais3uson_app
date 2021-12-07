# AIS-3USON backend (Мобильное приложения для ИС "АИС ТриУСОН")

A Flutter backend for AIS-3USON

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
- Установите скрипт WEB-сервера AIS-3USON и пароль в соответствии с инструкцией (здесь будет ссылки на скрипт и инструкцию).
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
- [ ] Write README
- [x] Use provider
- [ ] Services input
- [ ] Journal
- [ ] Logo
- [ ] Distribute via Google Play
- [ ] Snackbar для сообщений и ошибок

## Разработчики

[@Alexqwesa](https://github.com/Alexqwesa).

## Лицензия
[LGPLv2](LICENSE) © Savin Aleksander Viktorovich (Савин Александр Викторович)