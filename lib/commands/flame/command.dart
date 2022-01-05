library commands.flame;

import 'dart:async';
import 'dart:convert';

import 'package:ember_bot/bot.dart';
import 'package:http/http.dart' as http;
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/nyxx_interactions.dart';

part 'sub_commands/search.dart';

Future<SlashCommandBuilder> command() async {
  return SlashCommandBuilder(
    'flame',
    'Flame related commands',
    [
      await search(),
    ],
    guild: guildId,
  );
}
