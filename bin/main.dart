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
   .listen(((message) => teledart.replyMessage(message, ShuffleBot.createCommand(message.chat.id.toString(), message.text))));

  teledart
  .onCommand('shuffle')
  .listen((message) => ShuffleBot.shuffleCommand(message.chat.id.toString()).then((text) => teledart.replyMessage(message, text)));

  teledart
  .onCommand('add')
  .listen((message) => ShuffleBot.addCommand(message.chat.id.toString(), message.text).then((text) => teledart.replyMessage(message, text)));

  teledart
  .onCommand('remove')
  .listen((message) => ShuffleBot.removeCommand(message.chat.id.toString(), message.text).then((text) => teledart.replyMessage(message, text)));
}
