#!/bin/bash

BUILD_CONFIGURATION=${BUILD_CONFIGURATION:-Debug}

echo "// Checking .NET platform"

command -v dotnet >/dev/null 2>&1 || { echo >&2 "dotnet not found. Make sure it's installed and included in PATH. Aborting."; exit 1; }
command -v nuget >/dev/null 2>&1
if [ $? -eq 0 ]; then
    nuget_command='nuget'
else
    command -v mono >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "// Using mono with buildtools/nuget.exe as NuGet command"
        nuget_command='mono buildtools/nuget.exe'
    else
        echo >&2 "NuGet not found. Make sure it's install end included in PATH. Aborting.";
        exit 1;
    fi
fi
command -v msbuild >/dev/null 2>&1 || { echo >&2 "MSBuild not found. Make sure it's installed and included in PATH. Aborting."; exit 1; }

echo "// Restoring NuGet dependencies"
$nuget_command restore

echo "// Build .NET solution ($BUILD_CONFIGURATION)"
rm -rf build
mkdir -p build/package
msbuild Microsoft.Recognizers.Text.sln \
        /p:Configuration="$BUILD_CONFIGURATION" \
        /t:Clean,Build

# Run tests if build was successful
if [ $? -eq 0 ]; then
    echo "// Running .NET Tests"
    test_files=$(find . | grep 'bin/Debug.*Tests.dll')
    for file in "${test_files[@]}"
    do :
        dotnet vstest --Parallel --Diag:log.txt $file
    done
fi

echo "done."
