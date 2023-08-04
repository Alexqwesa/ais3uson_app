# UI Services - Classes to display service related data

There are two screens to display services:

- [ClientServicesListScreen] to display **list** of services,
- [ClientServicesScreen] to display **one** service.

Both of them use [ServiceCard] to display [ClientService].

The [ServiceCard] is display widget for [ClientService]. 
Based on [tileTypeProvider] it select one of views:
 - [ServiceCardView],
 - [ServiceCardSquareView],
 - [ServiceCardTileView],
 each of them get it size from provider [serviceCardSize] (which depend on [serviceCardMagnifying]).

Each [ServiceCard] view use [ServiceCardState] to display data from [Journal]
(how many services is added, etc...).

[ClientServicesScreen] is also displayed service's [Proof]s.