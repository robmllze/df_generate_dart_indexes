//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// 🇽🇾🇿 & Dev
//
// Licencing details are in the LICENSE file in the root directory.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:df_gen_core/df_gen_core.dart' as gen;
import 'package:path/path.dart' as p;

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

final insightMappers = [
  _InsightMapper(
    placeholder: Placeholders.PUBLIC_EXPORTS,
    mapInsights: (insight) async => _mapper(
      insight,
      (e) {
        return !e.contains('${p.separator}_') && !e.endsWith('.g.dart') && e.endsWith('.dart');
      },
      (e) => "export '$e';",
    ),
  ),
  _InsightMapper(
    placeholder: Placeholders.PRIVATE_EXPORTS,
    mapInsights: (insight) async => _mapper(
      insight,
      (e) => e.contains('${p.separator}_') && !e.endsWith('.g.dart'),
      (e) => "// export '$e';",
    ),
  ),
  _InsightMapper(
    placeholder: Placeholders.GENERATED_EXPORTS,
    mapInsights: (insight) async => _mapper(
      insight,
      (e) => !e.contains('${p.separator}_') && e.endsWith('.g.dart'),
      (e) => "// export '$e';",
    ),
  ),
];

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

String _mapper(
  gen.DirInsight insight,
  bool Function(String filePath) test,
  String Function(String baseName) statementBuilder,
) {
  final dir = insight.dir;
  final filePaths = dir.getSubFiles().map((e) => p.relative(e.path, from: dir.path));
  final exportFilePaths = filePaths.where((e) => test(e));
  if (exportFilePaths.isNotEmpty) {
    final statements = exportFilePaths.map(statementBuilder);
    return statements.join('\n');
  } else {
    return '// None found.';
  }
}

enum Placeholders {
  PUBLIC_EXPORTS,
  PRIVATE_EXPORTS,
  GENERATED_EXPORTS,
}

typedef _InsightMapper = gen.InsightMapper<gen.DirInsight, Placeholders>;

typedef GeneratorConverger = gen.GeneratorConverger<_InsightMapper, Placeholders, String>;
