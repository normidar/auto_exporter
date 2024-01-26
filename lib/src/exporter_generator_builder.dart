import 'dart:async';

import 'package:auto_exporter/src/exports_builder.dart';
import 'package:auto_exporter_annotation/auto_exporter_annotation.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

/// visit all files to remember they path
class ExporterGeneratorBuilder implements Builder {
  @override
  final buildExtensions = const {
    '.dart': ['.exports']
  };

  @override
  Future<void> build(BuildStep buildStep) async {
    final resolver = buildStep.resolver;
    if (!await resolver.isLibrary(buildStep.inputId)) return;
    final element = await buildStep.inputLibrary;
    final lib = [element, ...element.topLevelElements];

    final List<Set<String?>> annotated = [];

    for (var member in lib) {
      if (member.name == null) continue;
      final annotationChecker = LibraryReader(await buildStep.inputLibrary);
      for (var _ in annotationChecker
          .annotatedWith(TypeChecker.fromRuntime(IgnoreExport))) {
        return;
      }
      annotated.add({member.name});
    }

    if (annotated.isNotEmpty) {
      ExportsBuilder.packageName = buildStep.inputId.package;
      await buildStep.writeAsString(
          buildStep.inputId.changeExtension('.exports'), annotated.join(','));
    }
  }
}
