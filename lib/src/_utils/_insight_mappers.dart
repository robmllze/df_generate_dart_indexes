//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// Dart/Flutter (DF) Packages by DevCetra.com & contributors. The use of this
// source code is governed by an MIT-style license described in the LICENSE
// file located in this project's root directory.
//
// See: https://opensource.org/license/mit
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
        return !e.startsWith('_') &&
            !e.contains('${p.separator}_') &&
            !e.endsWith('.g.dart') &&
            e.endsWith('.dart');
      },
      (e) => "export '$e';",
    ),
  ),
  _InsightMapper(
    placeholder: Placeholders.PRIVATE_EXPORTS,
    mapInsights: (insight) async => _mapper(
      insight,
      (e) =>
          e.startsWith('_') ||
          e.contains('${p.separator}_') && !e.endsWith('.g.dart'),
      (e) => "// export '$e';",
    ),
  ),
  _InsightMapper(
    placeholder: Placeholders.GENERATED_EXPORTS,
    mapInsights: (insight) async => _mapper(
      insight,
      (e) =>
          !e.startsWith('_') &&
          !e.contains('${p.separator}_') &&
          e.endsWith('.g.dart'),
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
  final filePaths =
      dir.getSubFiles().map((e) => p.relative(e.path, from: dir.path));
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

typedef GeneratorConverger
    = gen.GeneratorConverger<_InsightMapper, Placeholders, String>;
