import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/nyxx_interactions.dart';
import 'package:ember_bot/commands/whoami/command.dart' as whoami;
import 'package:ember_bot/commands/memo/command.dart' as memo;
import 'package:ember_bot/commands/flame/command.dart' as flame;
import 'package:ember_bot/commands/role/command.dart' as role;

INyxxWebsocket? _bot;

final guildId = 509714518008528896.toSnowflake();

INyxxWebsocket get nyxxBot {
  if (_bot != null) {
    return _bot!;
  }
  return _bot = NyxxFactory.createNyxxWebsocket(
    'API_KEY_HERE',
    GatewayIntents.allUnprivileged,
  )
    ..registerPlugin(Logging()) // Default logging plugin
    ..registerPlugin(CliIntegration()) // CLI integration for Nyxx
    ..registerPlugin(IgnoreExceptions()) // Handle uncaught exceptions
    ..connect();
}

IInteractions? _iInteractions;

Future<void> syncInteractions() async {
  _iInteractions ??= IInteractions.create(WebsocketInteractionBackend(nyxxBot));
  _iInteractions!
    ..registerSlashCommand(await whoami.command())
    ..registerSlashCommand(await memo.command())
    ..registerSlashCommand(await flame.command())
    ..registerSlashCommand(await role.command());

  return _iInteractions!.sync();
}
