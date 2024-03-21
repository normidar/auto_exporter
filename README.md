[![pub package](https://img.shields.io/pub/v/auto_exporter.svg)](https://pub.dev/packages/auto_exporter)

# Auto Exporter

This project fork from https://github.com/AlbertoMonteiro/FlutterAutoExport Thanks to the author. (But after fork from that, it has been a lot different)

If you request an issue please @normidar

A Dart package that allows you to auto-export types globally.

## How to use it?

Firstly: add those to `pubspec.yaml` 

```
dependencies:
  auto_exporter_annotation: ^1.0.1

dev_dependencies:
  auto_exporter: ^3.0.0
  build_runner: ^2.4.6
  build_test: ^2.2.0
```

Secondly: add those to `build.yaml`:
```
targets:
  $default:
    builders:
      auto_exporter:
        options:
          default_export_all: true # default export all files, if false only export @AutoExport() files, default is true.
          project_name: your_project_name
```

Thirdly: run code:

```
 dart run build_runner build  # Dart SDK
 flutter pub run build_runner build  # Flutter SDK
 flutter packages pub run build_runner build # try this on error
```

wait a minute... and you get the export file.

## hint

`dart pub publish --dry-run` to check your package prepare for `pub.dev`.


## ignore exports

If you want to ignore certain files without exporting them, you can use the annotation `IgnoreExport` for your class.

you can see the example to know how to use this annotation.

> feature advised by @hasimyerlikaya.

## only export some files

change the `default_export_all` option to false, and add @AutoExport() annotation to the files that you want to export.

> feature advised by @sm-riyadh