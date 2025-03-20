@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul  & REM UTF-8 인코딩 설정 (한글 지원)

:: 현재 배치 파일의 이름을 기반으로 새 이름 결정
set "NewNamePrefix=%~n0"

:: 변경할 파일이 있는 폴더 (현재 실행된 폴더)
set "TargetDir=%CD%"

:: PowerShell 실행
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$path='%TargetDir%';" ^
    "$OldPattern1='과제_4기';" ^
    "$OldPattern2='파이썬_(\d+)주차_주말과제';" ^
    "$NewNamePrefix='%NewNamePrefix%';" ^
    "[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;" ^
    "Get-ChildItem -Path $path -File | ForEach-Object {" ^
    "   $oldName=$_.Name;" ^
    "   $newName=$oldName;" ^
    "   if ($oldName -match $OldPattern1) {" ^
    "       $newName=$oldName -replace [regex]::Escape($OldPattern1), $NewNamePrefix;" ^
    "   } elseif ($oldName -match $OldPattern2) {" ^
    "       $newName=$NewNamePrefix + '_파이썬_' + $matches[1] + '주차_주간' + [System.IO.Path]::GetExtension($oldName);" ^
    "   }" ^
    "   if ($newName -ne $oldName) {" ^
    "       $counter=1;" ^
    "       $baseNewName=$newName;" ^
    "       $fileExtension=[System.IO.Path]::GetExtension($oldName);" ^
    "       while (Test-Path -Path (Join-Path -Path $path -ChildPath $newName)) {" ^
    "           $fileNameOnly=[System.IO.Path]::GetFileNameWithoutExtension($baseNewName);" ^
    "           $newName=$fileNameOnly + '_' + $counter + $fileExtension;" ^
    "           $counter++;" ^
    "       }" ^
    "       Rename-Item -LiteralPath $_.FullName -NewName $newName -Force;" ^
    "       Write-Host '변경됨: ' $oldName '→' $newName;" ^
    "   }" ^
    "}"
