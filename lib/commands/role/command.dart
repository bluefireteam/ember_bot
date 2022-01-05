library commands.role;

import 'package:ember_bot/bot.dart';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/nyxx_interactions.dart';

part 'sub_commands/remove.dart';
part 'sub_commands/set.dart';

final allowedRoles = [
  614088388181622814.toSnowflake(), // Flame
  614088521891708948.toSnowflake(), // AudioPlayers
];

Future<SlashCommandBuilder> command() async {
  return SlashCommandBuilder(
    'role',
    'Manage your own roles',
    [
      await remove(),
      await set(),
    ],
    guild: guildId,
  );
}
