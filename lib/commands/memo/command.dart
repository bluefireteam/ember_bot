import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:ember_bot/bot.dart';
import 'package:ember_bot/commands/memo/memo.dart';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/nyxx_interactions.dart';

Future<SlashCommandBuilder> command() async {
  final memosData = File('./data/memos.csv').readAsStringSync().split('\n')
    ..removeAt(0);

  final memos = <Memo>[];
  for (final memoData in memosData) {
    final data = memoData.split(',');
    final memoId = Snowflake.value(int.parse(data.removeLast()));
    final channelId = Snowflake.value(int.parse(data.removeLast()));
    final channel = await nyxxBot.fetchChannel<ITextChannel>(channelId);

    memos.add(Memo(
      data.join(','),
      channel,
      await channel.fetchMessage(memoId),
    ));
  }

  return SlashCommandBuilder(
    'memo',
    'Display saved memos',
    [
      CommandOptionBuilder(
        CommandOptionType.string,
        'which',
        'Which memo to show',
        choices: memos
            .map((m) => ArgChoiceBuilder(m.description, m.description))
            .toList(),
        required: true,
      ),
      CommandOptionBuilder(
        CommandOptionType.user,
        'user',
        'Do you want to tag a user?',
        required: false,
      ),
    ],
    guild: guildId,
  )..registerHandler((event) async {
      final which = event.args.first;
      final user = event.args.firstWhereOrNull((a) => a.name == 'user');
      final mentionedUser = user != null
          ? await nyxxBot.fetchUser(Snowflake.value(int.parse(user.value)))
          : null;
      final memo = memos.firstWhere((m) => m.description == which.value);

      await event.respond(
        MessageBuilder()
          ..content = [
            if (mentionedUser != null) 'Hi ${mentionedUser.mention},',
            '${memo.message.content}',
          ].join('\n'),
      );
    });
}
