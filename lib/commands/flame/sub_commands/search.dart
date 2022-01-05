part of commands.flame;

final regexp = RegExp(r'\[(.*?)\]\(([\w\d]+).md\)');

final timer = Timer(Duration(days: 1), syncInteractions);

Future<CommandOptionBuilder> search() async {
  final response = await http.get(
    Uri.parse('https://api.github.com/repos/flame-engine/flame/git/refs/tags'),
    headers: {'Accept': 'application/vnd.github.v3+json'},
  );
  final List<String> allVersions =
      jsonDecode(response.body).map((e) => e['ref']).toList().cast<String>();

  final v1AndHigher = RegExp(r'^refs/tags/([v]?\d+(?<!0)\.\d+\.\d+)$');
  final versions = <String>['main'];
  for (final version in allVersions) {
    final match = v1AndHigher.firstMatch(version);
    if (match != null) {
      versions.add(match.group(1)!);
    }
  }

  return CommandOptionBuilder(
    CommandOptionType.subCommand,
    'search',
    'Generate a search link to the Flame docs',
    options: [
      CommandOptionBuilder(
        CommandOptionType.string,
        'version',
        'For which Flame version',
        choices: versions.map((e) => ArgChoiceBuilder(e, e)).toList(),
        required: true,
      ),
      CommandOptionBuilder(
        CommandOptionType.string,
        'query',
        'Query to search with',
        required: true,
      ),
    ],
  )..registerHandler((event) {
      final version =
          event.args.firstWhere((element) => element.name == 'version').value;
      final query =
          event.args.firstWhere((element) => element.name == 'query').value;

      event.respond(
        MessageBuilder.content(
          'https://docs.flame-engine.org/$version/search.html?q=$query',
        ),
        hidden: true,
      );
    });
}
