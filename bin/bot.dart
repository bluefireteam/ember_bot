import 'package:ember_bot/bot.dart';
import 'package:nyxx/nyxx.dart';

void main() async {
  nyxxBot.onReady.listen((event) async {
    await syncInteractions();

    nyxxBot.setPresence(
      PresenceBuilder.of(status: UserStatus.from('with the Flame Engine')),
    );
  });
}
