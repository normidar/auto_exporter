import 'dart:async';

import 'package:auto_exporter/src/exports_builder.dart';
import 'package:build/build.dart';

/// visit all files to remember they path
class ExporterGeneratorBuilder implements Builder {
  @override
  final buildExtensions = const {
    '.dart': ['.exports']
  };

  @override
  Future<void> build(BuildStep buildStep) async {
    print("generator running");
    final resolver = buildStep.resolver;
    if (!await resolver.isLibrary(buildStep.inputId)) return;
    final element = await buildStep.inputLibrary;
    final lib = [element, ...element.topLevelElements];
    // final exportAnnotation = TypeChecker.fromRuntime(AutoExporter);
    final annotated = [
      for (var member in lib) {member.name},
    ];
    if (annotated.isNotEmpty) {
      ExportsBuilder.packageName = buildStep.inputId.package;
      await buildStep.writeAsString(
          buildStep.inputId.changeExtension('.exports'), annotated.join(','));
    }
  }
}
