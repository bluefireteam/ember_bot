part of commands.role;

Future<CommandOptionBuilder> remove() async {
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
    'remove',
    'Rempve a role',
    options: [
      CommandOptionBuilder(
        CommandOptionType.string,
        'role',
        'Which role to remove',
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

      if (!member.roles.contains(role)) {
        return event.respond(
          MessageBuilder()..content = 'You dont have that role silly.',
          hidden: true,
        );
      }
      await member.removeRole(role);
      await event.respond(
        MessageBuilder()..content = 'Your role has been removed!',
        hidden: true,
      );
    });
}
