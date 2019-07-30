import 'package:ShuffleBot/shuffle_bot.dart';
import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';
import 'dart:io';

main(List<String> arguments) {

  final String FLAVOR = arguments[0]; 

  final Map env = Platform.environment;
  var TOKEN;
  switch (FLAVOR) {
    case 'RELEASE': {
      TOKEN = env['CHU_WA_CHI_TELEGRAM_TOKEN'];
    }
    break;

    default: {
      TOKEN = env['CHU_WA_CHI_TELEGRAM_TOKEN_DEV'];
    }
    break;
  }
  
  Telegram telegram = Telegram(TOKEN);
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

  teledart
  .onMessage(keyword: '\\+')
  .listen((message) => teledart.replyMessage(message, "${message.date} plus detected."));
}
