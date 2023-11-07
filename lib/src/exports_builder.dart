import 'package:build/build.dart';
import 'package:glob/glob.dart';

/// the ExportsBuilder will create the file to
/// export all dart files
class ExportsBuilder implements Builder {
  @override
  Map<String, List<String>> get buildExtensions {
    return {
      r'$lib$': ['export.dart']
    };
  }

  static var packageName = "export";
  @override
  Future<void> build(BuildStep buildStep) async {
    print("running build");

    final exports = buildStep.findAssets(Glob('**/*.exports'));

    final expList = <String>[];
    final content = [
      "// run this to reset your file:  dart run build_runner build",
      "// or use flutter:               flutter packages pub run build_runner build",
      "// remenber to format this file, you can use: dart format",
      "// publish your package hint: dart pub publish --dry-run",
      "// if you want to update your packages on power: dart pub upgrade --major-versions",
    ];
    await for (var exportLibrary in exports) {
      print("exportLibrary: $exportLibrary");
      final exportUri = exportLibrary.changeExtension('.dart').uri;
      if (exportUri.toString().substring(0, 5) != "asset") {
        if (exportUri.toString() != 'package:$packageName/$packageName.dart') {
          final expStr = "export '$exportUri';";
          expList.add(expStr);

          // if (content[2] == "") {
          //   packageName = expStr.split("/")[0].split(":")[1];
          //   content[2] = "// " + packageName;
          // }
        }
      }
    }
    expList.add('');
    print("export list:$expList");

    content.addAll(expList);
    if (content.isNotEmpty) {
      await buildStep.writeAsString(
          AssetId(buildStep.inputId.package, 'lib/export.dart'),
          content.join('\n'));
    }
  }
}
