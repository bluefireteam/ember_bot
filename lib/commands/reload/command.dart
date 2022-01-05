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
          MessageBuilder.content('Sorry but you are not allowed to do that'),
          hidden: true,
        );
      }

      await event.respond(
        MessageBuilder.content('Gotcha! Reloading now...'),
        hidden: true,
      );
      try {
        await event.sendFollowup(
          MessageBuilder.content('Pulling new data files...'),
          hidden: true,
        );
        await Process.run('git', ['pull']);
        await event.sendFollowup(
          MessageBuilder.content('Done, rebuilding my interactions now...'),
          hidden: true,
        );
        await syncInteractions();
        await event.sendFollowup(
          MessageBuilder.content('Done, I have sucessfully reloaded myself.'),
          hidden: true,
        );
      } catch (err) {
        await event.sendFollowup(
          MessageBuilder.content('Seems like something went wrong: $err'),
          hidden: true,
        );
      }
    });
}
