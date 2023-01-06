# scoop-update-notifier

Notify whether or not an update for an installed app by [Scoop](https://github.com/ScoopInstaller/Scoop) via [toast](https://learn.microsoft.com/en-us/windows/apps/design/shell/tiles-and-notifications/toast-notifications-overview).

## Prerequisites

* Windows 10 / 11
* Windows PowerShell 5.1

## Message in toast

| Type | Message |
| :--- | :--- |
| Up to date | Up to date! |
| There is an update (Not same as previous) | There is an update. |
| There is an update (Same as previous) | There is an update.<br>Should be update! |
| There are updates (Not same as previous) |There are \<n\> updates. |
| There are updates (Same as previous) | There are \<n\> updates.<br>Should be update! |

## Installation / Uninstallation

### Installation

Register the task to Task Scheduler.

#### Simple

```PowerShell
PS> install.ps1
```

Default execution time is 10:00 .

#### Specific time

```PowerShell
PS> install.ps1 -ExecutionDateTime '18:00'
```

### Uninstallation

Unregister the task from Task Scheduler.

```PowerShell
PS> uninstall.ps1
```
