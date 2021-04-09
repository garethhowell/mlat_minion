# Resilio-sync container

This container starts from a vanilla Ubuntu image and installs [resilio-sync]  from the [official instructions][install].
It then copies and default configuration file and uses a script to edit it with this minion's device variables before starting the sync process.

[resilio-sync]: https://www.resilio.com
[install]: https://help.resilio.com/hc/en-us/articles/206178924-Installing-Sync-package-on-Linux