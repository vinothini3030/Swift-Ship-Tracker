#!/usr/bin/env bash
# SwiftShip Tracker - one-click deploy (macOS/Linux). Requires Salesforce CLI (sf).
set -e
ALIAS=swiftship
sf org login web --alias $ALIAS --set-default
sf project deploy start --source-dir force-app --target-org $ALIAS --wait 30
sf org assign permset --name Swift_Ship --target-org $ALIAS
sf apex run --file scripts/apex/seed.apex --target-org $ALIAS
sf org open --target-org $ALIAS --path lightning/app/standard__AppLauncher
