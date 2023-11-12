[![pub package](https://img.shields.io/pub/v/auto_exporter.svg)](https://pub.dev/packages/auto_exporter)

# Auto Exporter

This project fork from https://github.com/AlbertoMonteiro/FlutterAutoExport Thanks the author.

If you request a issue please @normidar

A Dart package that allows you to auto export types globally.

## How to use it ?

first: add those to `pubspec.yaml` 
```
dev_dependencies:
  auto_exporter: ^...
  build_runner: ^2.4.6
  build_test: ^2.2.0
```

second run:
```
 dart run build_runner build  # Dart SDK
 flutter pub run build_runner build  # Flutter SDK
 flutter packages pub run build_runner build # try this on error
```

wait a minute... and you get the export file.

remove your export file and change the `export.dart` to your name.

#### on the last

rename you export.dart to your project name

remember to run this:`dart format .`!

#### hint

`dart pub publish --dry-run` to up your package to pub.dev


### auto shell

you can use this shell to auto export your files(required: you must only has one file in your lib folder):

``` shell
#!/bin/bash

set -eux

folder_path="lib/"

file_name=$(find "$folder_path" -maxdepth 1 -type f)
file_name=$(basename "$file_name")

rm -rf "$folder_path""$file_name"

flutter packages pub run build_runner build

mv "$folder_path""export.dart" "$folder_path""$file_name"
```

### ignore exports

If you want to ignore certain files without exporting them, you can use the annotation `IgnoreExport` for your class.

you can see the example to know how to use this annotation.

> feature advised by @hasimyerlikaya.

