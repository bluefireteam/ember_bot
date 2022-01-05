import 'package:nyxx/nyxx.dart';

class Memo {
  const Memo(
    this.description,
    this.channel,
    this.message,
  );

  final String description;

  final ITextChannel channel;

  final IMessage message;
}
