@echo off
REM SwiftShip Tracker - one-click deploy (Windows). Requires Salesforce CLI (sf) installed.
set ALIAS=swiftship

echo [1/5] Logging in (browser will open)...
call sf org login web --alias %ALIAS% --set-default || goto :err

echo [2/5] Deploying metadata...
call sf project deploy start --source-dir force-app --target-org %ALIAS% --wait 30 || goto :err

echo [3/5] Assigning permission set Swift_Ship to current user...
call sf org assign permset --name Swift_Ship --target-org %ALIAS% || goto :err

echo [4/5] Loading sample data...
call sf apex run --file scripts/apex/seed.apex --target-org %ALIAS% || goto :err

echo [5/5] Opening org...
call sf org open --target-org %ALIAS% --path lightning/app/standard__AppLauncher
echo Done.
exit /b 0

:err
echo Something failed. Read the error above.
exit /b 1
