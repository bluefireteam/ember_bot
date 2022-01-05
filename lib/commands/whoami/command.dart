import 'dart:async';

import 'package:ember_bot/bot.dart';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/nyxx_interactions.dart';

Future<SlashCommandBuilder> command() async {
  return SlashCommandBuilder('whoami', 'Who I am', [], guild: guildId)
    ..registerHandler((event) async {
      await event.respond(
        MessageBuilder.content([
          'Hi! My name is Ember and I am the Flame Engine mascot.',
          '',
          'My job in this discord is making stay here fun. <a:ember:747919943193854093>',
          '',
          'You can find my DNA here: https://github.com/bluefireteam/ember_bot',
        ].join('\n')),
        hidden: true,
      );
    });
}
