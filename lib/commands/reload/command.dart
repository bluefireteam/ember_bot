import 'dart:async';
import 'dart:io';

import 'package:ember_bot/bot.dart';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/nyxx_interactions.dart';

Future<SlashCommandBuilder> command() async {
  return SlashCommandBuilder(
    'reload',
    'Reload data files',
    [],
    guild: guildId,
  )..registerHandler((event) async {
      if (!isAdmin(event.interaction.memberAuthor!)) {
        return event.respond(
          MessageBuilder()
            ..content = 'Sorry but you are not allowed to do that',
          hidden: true,
        );
      }

      try {
        await Process.run('git', ['pull']);
        return event.respond(
          MessageBuilder()..content = 'Sucessfully reloaded my data files',
          hidden: true,
        );
      } catch (err) {
        print(err);
        return event.respond(
          MessageBuilder()..content = 'Seems like something went wrong? HELP',
          hidden: true,
        );
      }
    });
}
