//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// Dart/Flutter (DF) Packages by DevCetra.com & contributors. See MIT LICENSE
// file in the root directory.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'dart:io';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

void main(List<String> args) {
  final version = args.isNotEmpty ? args[0] : '0.1.0';
  final newReleaseNotes = args.length > 1 ? args[1] : 'Initial commit';
  final changelogPath = 'CHANGELOG.md';
  final file = File(changelogPath);
  if (!file.existsSync()) {
    print('$changelogPath does not exist.');
    exit(1);
  }
  var contents = file.readAsStringSync();
  contents = contents.replaceAll('# Changelog', '').trim();
  final sections = extractSections(contents);
  final versionExist = sections.where((e) => e.version == version).isNotEmpty;
  if (versionExist) {
    sections.where((e) => e.version == version).forEach((e) {
      e.addUpdate(newReleaseNotes);
    });
  } else {
    sections.add(
      _VersionSection(
        version: version,
        releasedAt: DateTime.now().toUtc(),
        updates: {newReleaseNotes},
      ),
    );
  }
  contents = '# Changelog\n\n${(sections.toList()..sort((a, b) {
      return b.releasedAt.compareTo(a.releasedAt);
    })).map((e) => e.toString()).join('\n')}';

  file.writeAsStringSync(contents);
  print('Changelog updated with version $version.');
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Set<_VersionSection> extractSections(String contents) {
  final headerPattern = RegExp(r'## \[\d+\.\d+\.\d+(\+\d+)?\]');
  final allVersionMatches = headerPattern.allMatches(contents).toList();
  final results = <_VersionSection>{};
  for (var i = 0; i < allVersionMatches.length; i++) {
    final start = allVersionMatches[i].end;
    final end = i + 1 < allVersionMatches.length ? allVersionMatches[i + 1].start : contents.length;
    final sectionContents = contents.substring(start, end).trim();
    final lines = sectionContents.split('\n').where((line) => line.isNotEmpty).toList();
    final version =
        allVersionMatches[i].group(0)!.substring(4, allVersionMatches[i].group(0)!.length - 1);
    var releasedAt = DateTime.now().toUtc();
    final updates = <String>{};
    final old = lines
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .map((e) => e.startsWith('-') ? e.substring(1) : e)
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty);
    for (var line in old) {
      if (line.contains('Released @')) {
        final temp = line.split('Released @').last.trim();
        releasedAt = DateTime.tryParse(temp) ?? releasedAt;
      } else {
        updates.add(line);
      }
    }
    results.add(
      _VersionSection(
        version: version,
        releasedAt: releasedAt,
        updates: updates,
      ),
    );
  }

  return results;
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class _VersionSection {
  //
  //
  //

  String version;
  DateTime releasedAt;
  Set<String> updates;

  //
  //
  //

  _VersionSection({
    required this.version,
    required this.releasedAt,
    this.updates = const {},
  });

  //
  //
  //

  void addUpdate(String update) {
    this.updates.add(update);
    this.releasedAt = DateTime.now().toUtc();
  }

  //
  //
  //

  @override
  String toString() {
    final updatesString = updates.map((update) => '- $update').join('\n');
    return '## [$version]\n\n- Released @ ${releasedAt.month}/${releasedAt.year} (UTC)\n$updatesString\n';
  }
}
