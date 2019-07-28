import 'package:ShuffleBot/shuffle_bot.dart';
import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';

import 'config.dart';

main(List<String> arguments) {
  Telegram telegram = Telegram(TELEGRAM_TOKEN);
  TeleDart teledart = TeleDart(telegram, Event());

  teledart.start().then((me) => print('${me.username} is initialised'));

  teledart
        .onCommand('create')
        .listen(((message) => teledart.replyMessage(message, handleCreateCommand(message.text))));
}
