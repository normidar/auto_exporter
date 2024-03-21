import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:build/build.dart';
import 'package:glob/glob.dart';

/// the ExportsBuilder will create the file to
/// export all dart files
class ExportsBuilder implements Builder {
  BuilderOptions options;

  ExportsBuilder({required this.options});

  @override
  Map<String, List<String>> get buildExtensions {
    return {
      r'$lib$': ['$packageName.dart']
    };
  }

  bool get isDefaultExportAll => options.config['default_export_all'] ?? true;

  String get packageName => options.config['project_name'] ?? 'exports';

  @override
  Future<void> build(BuildStep buildStep) async {
    final exports = buildStep.findAssets(Glob('lib/**/*.dart'));

    final expList = <String>[];
    final content = [
      "// run this to reset your file:  dart run build_runner build",
      "// or use flutter:               flutter packages pub run build_runner build",
      "// remenber to format this file, you can use: dart format",
      "// publish your package hint: dart pub publish --dry-run",
      "// if you want to update your packages on power: dart pub upgrade --major-versions",
    ];
    await for (var exportLibrary in exports) {
      final con = await buildStep.readAsString(exportLibrary);
      // to check has `part of`
      var ast = parseString(content: con).unit.childEntities;

      final exportUri = exportLibrary.uri.path;
      if (exportUri.toString() != 'package:$packageName/$packageName.dart') {
        final expStr = "export 'package:$exportUri';";
        if (con.contains('@IgnoreExport()')) {
          continue;
        }
        if (ast.whereType<PartOfDirective>().isEmpty) {
          if (isDefaultExportAll) {
            expList.add(expStr);
          } else {
            if (con.contains('@AutoExport()')) {
              expList.add(expStr);
            }
          }
        }
      }
    }
    expList.add('');

    content.addAll(expList);
    if (content.isNotEmpty) {
      await buildStep.writeAsString(
          AssetId(buildStep.inputId.package, 'lib/$packageName.dart'),
          content.join('\n'));
    }
  }
}
