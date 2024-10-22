#!/bin/bash

echo "000-setup.sh"
./000-setup.sh || exit 1

echo "001-install.sh"
./001-install.sh || exit 1

echo "002-backup.sh"
./002-backup.sh || exit 1

echo "003-download.sh"
./003-download.sh || exit 1

echo "004-uninstall.sh"
./004-uninstall.sh || exit 1

echo "999-teardown.sh"
./999-teardown.sh || exit 1

echo "All tests passed"