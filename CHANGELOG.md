## 1.0.1

* **Fix:** Updated repository and metadata links for pub.dev compliance.

## 1.0.0

* **Initial Release:** Built a robust, strict runtime architectural boundary enforcement tool for Clean Architecture.
* **WardenMember:** Included the Identity system for tracking Presentation, Domain, Data, and Infrastructure boundaries.
* **WardenEngine:** Added core evaluation logic mapping violations silently or strictly based on boundaries (Presentation Leak and Domain Leak guards).
* **Observers:** Shipped native integration for `flutter_bloc` and `flutter_riverpod`.
* **Alerting System:** Implemented ANSI-formatted console logs and an optional un-intrusive floating `InAppAlerter`.
* **Security:** Added `SensitiveDataMasker` to keep data payloads like passwords and tokens masked out of terminal logs.
* **Zero Reflection:** Completely avoided `dart:mirrors` making it incredibly lightweight and fully AOT/Web compatible.
