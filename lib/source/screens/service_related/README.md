# UIServices - Classes to display service related data

There are is two screens to display services:
- [ClientServicesListScreen] to display **list** of services,
- [ClientServicesScreen] to display **one** service.

Both of them use [ServiceCard] to display [ClientService].

The [ServiceCard] calculate it size via [AppData.serviceCardSize] and select one of views:
[ServiceCardView] or [ServiceCardTileView], to display [ClientService].

Each service view use [ServiceCardState] to display [Journal] data (how many services is added, etc...).

[ClientServicesScreen] is also displayed service [ProofList].