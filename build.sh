#!/bin/bash
(cd app && sudo find . | sudo cpio -o -H newc > ../app-mod.cpio)
(cd system && sudo find . | sudo cpio -o -H newc > ../system-mod.cpio)
(cd web && sudo find . | sudo cpio -o -H newc > ../web-mod.cpio)
