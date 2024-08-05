//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// Dart/Flutter (DF) Packages by DevCetra.com & contributors. See LICENSE file
// in root directory.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:df_config/df_config.dart';
import 'package:df_gen_core/df_gen_core.dart' as gen;
import 'package:df_log/df_log.dart';
import 'package:path/path.dart' as p;

import '_insight_mappers.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

final generatorConverger = _GeneratorConverger(
  (replacements, templates) async {
    for (final template in templates) {
      // Extract the content from the template.
      final templateContent = gen.extractCodeFromMarkdown(template);

      for (final replacement in replacements) {
        final dir = replacement.insight.dir;
        final dirPath = dir.path;

        // Fill the template with the replacement data.
        final output = replaceData(
          templateContent,
          replacement.replacements,
        );

        // Determine the output file name.
        final outputFileName = [
          '_index',
          '.g.dart',
        ].join();
        final outputFilePath = p.join(dirPath, outputFileName);

        // Write the content to the file.
        await gen.writeFile(
          outputFilePath,
          output,
        );

        debugLogSuccess('Generated "${gen.previewPath(outputFilePath)}"');
      }
    }
  },
);

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

typedef _GeneratorConverger = gen.GeneratorConverger<gen.DirInsight, Placeholders, String>;
