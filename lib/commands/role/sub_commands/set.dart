part of commands.role;

Future<CommandOptionBuilder> set() async {
  final guild = await nyxxBot.fetchGuild(guildId);
  final roleChoices = <ArgChoiceBuilder>[];

  for (final role in guild.roles.values) {
    if (!allowedRoles.contains(role.id)) {
      continue;
    }
    roleChoices.add(ArgChoiceBuilder(
      role.name,
      '${role.id.id}',
    ));
  }

  return CommandOptionBuilder(
    CommandOptionType.subCommand,
    'set',
    'Set a role',
    options: [
      CommandOptionBuilder(
        CommandOptionType.string,
        'role',
        'Which role to set',
        required: true,
        choices: roleChoices,
      ),
    ],
  )..registerHandler((event) async {
      final member = event.interaction.memberAuthor;
      if (member == null) {
        return print('Member was not found');
      }
      final arg = event.args.first;
      final role = guild.roles.values.firstWhere(
        (role) => '${role.id.id}' == arg.value,
      );

      if (member.roles.contains(role)) {
        return event.respond(
          MessageBuilder.content('You already have that role silly.'),
          hidden: true,
        );
      }
      await member.addRole(role);
      await event.respond(
        MessageBuilder.content('Your role has been set!'),
        hidden: true,
      );
    });
}
