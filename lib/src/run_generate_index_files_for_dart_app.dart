//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// 🇽🇾🇿 & Dev
//
// Licencing details are in the LICENSE file in the root directory.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:args/args.dart';

import 'package:df_gen_core/df_gen_core.dart' as gen;

import 'generate_index_files_for_dart.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// A command line app for generating index files for Dart from directories.
/// The [args] are interpreted and passed to [generateIndexFilesForDart].
Future<void> runGenerateIndexFilesForDartApp(List<String> args) async {
  await gen.runCommandLineApp(
    title: 'Generate Dart Indexes',
    description: 'A command line app for generating Dart index files for the provided directories.',
    args: args,
    parser: ArgParser()
      ..addFlag(
        'help',
        abbr: 'h',
        negatable: false,
        help: 'Help information.',
      )
      ..addOption(
        'roots',
        abbr: 'r',
        help: 'Root directory paths of source files separated by `&`.',
        //defaultsTo: 'lib',
      )
      ..addOption(
        'subs',
        abbr: 's',
        help: 'Sub-directory paths of source files separated by `&`.',
      )
      ..addOption(
        'patterns',
        abbr: 'p',
        help: 'Path patterns for source files separated by `&`.',
      )
      ..addOption(
        'templates',
        abbr: 't',
        help: 'Root directory paths of templates separated by `&`.',
      ),
    onResults: (parser, results) {
      return _ArgsChecker(
        rootPaths: results['roots'],
        subPaths: results['subs'],
        pathPatterns: results['patterns'],
        templatesRootDirPaths: results['templates'],
      );
    },
    action: (parser, results, args) async {
      await generateIndexFilesForDart(
        templatesRootDirPaths: {}, // templates not used atm
        rootDirPaths: args.rootPaths!,
        subDirPaths: args.subPaths ?? const {},
        pathPatterns: args.pathPatterns ?? const {},
      );
    },
  );
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class _ArgsChecker extends gen.ValidArgsChecker {
  //
  //
  //

  final Set<String>? templatesRootDirPaths;
  final Set<String>? rootPaths;
  final Set<String>? subPaths;
  final Set<String>? pathPatterns;

  //
  //
  //

  _ArgsChecker({
    required dynamic templatesRootDirPaths,
    required dynamic rootPaths,
    required dynamic subPaths,
    required dynamic pathPatterns,
  })  : this.templatesRootDirPaths = gen.splitArg(templatesRootDirPaths)?.toSet(),
        this.rootPaths = gen.splitArg(rootPaths)?.toSet(),
        this.subPaths = gen.splitArg(subPaths)?.toSet(),
        this.pathPatterns = gen.splitArg(pathPatterns)?.toSet();

  //
  //
  //

  @override
  List get args => [
        //this.templatesRootDirPaths, // templates not used atm
        this.rootPaths,
        if (this.subPaths != null) this.subPaths,
        if (this.pathPatterns != null) this.pathPatterns,
      ];
}
