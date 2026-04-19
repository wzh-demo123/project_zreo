@echo off
title Project Zero - Sync Rollback Tool
cls

echo ======================================================
echo [WARNING] This will FORCE OVERWRITE local and remote!
echo ======================================================
echo.

:: 1. Get Target ID
set /p target="Enter Branch Name or Commit ID to rollback: "

:: 2. Get current branch name
for /f "tokens=*" %%i in ('git rev-parse --abbrev-ref HEAD') do set cb=%%i

echo.
echo [1/3] Fetching and Resetting local to: %target%
git fetch origin
git reset --hard %target%

echo.
echo [2/3] Cleaning untracked files (Keep core tools)...
:: Exclude the scripts so they don't delete themselves
git clean -fdx -e Git_Sync_Rollback.bat -e flatten_code.py -e ProjectZero_Sync.py

echo.
echo [3/3] Force pushing to GitHub (Branch: %cb%)...
git push origin %cb% --force

echo.
echo ======================================================
echo SUCCESSFULLY synchronized local and remote to: %target%
echo ======================================================
pause