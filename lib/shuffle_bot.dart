import 'dart:core';
import 'package:ShuffleBot/firebase_storage.dart';
import 'package:ShuffleBot/game.dart';
import 'package:ShuffleBot/formatter.dart';
import 'package:ShuffleBot/parser.dart';
import 'package:ShuffleBot/text.dart';
import 'package:ShuffleBot/util.dart';

class ShuffleBot {

  static var _text = ENG;

  static Future<String> startCommand(String chat_id, String sender) async {
    var text = _text['greeting'](Formatter.formatName(sender));

    await FirebaseStorage.createGame(chat_id, null);
    await FirebaseStorage.savePotentialPlayers(chat_id, []);

    return Future.value(text);
  }
  static Future<String> createCommand(String chat_id, String text) {
    var arguments = text.split(" ");

    if (arguments.length < 3) return Future.value(_text['create.fail.argument']());

    var game = Parser.parseGame(arguments.sublist(1));

    if (game == null) return Future.value(_text['create.fail.argument']());

    return FirebaseStorage.createGame(chat_id, game)
    .then((_) => _text['new.game.created'](game.players.length));
  }

  static Future<String> shuffleCommand(String chat_id) {
    return FirebaseStorage.getGame(chat_id)
    .then((game) => game != null ? Formatter.formatShuffle(game.shuffle()) : _text['empty.game']());
  }

  static Future<String> addCommand(String chat_id, String text) {
    var arguments = text.split(" ");

    if (arguments.length < 2) return Future.value( _text['illegal.arguments.add']());

    var player_name = removePrefixIfNeeded(arguments[1]);
    var player = Player(name: player_name);

    return FirebaseStorage.addPlayer(chat_id, player)
    .then((is_added)=> is_added ? _text['was.added'](Formatter.formatName(player_name)) : _text['already.exist'](Formatter.formatName(player_name)));
  }

  static Future<String> removeCommand(String chat_id, String text) {
    var arguments = text.split(" ");

    if (arguments.length < 2) return Future.value(_text['illegal.arguments.remove']());

    var player_name = arguments[1];
    var player = Player(name: player_name);

    return FirebaseStorage.removePlayer(chat_id, player)
    .then((is_removed) {
      if (is_removed) {
        return _text['was.removed'](Formatter.formatName(player_name));
      } else {
        return _text['not.found'](Formatter.formatName(player_name));
      }
    });
  }

  static Future<String> goCommand(String chat_id, String sender) async {
    var player = Player(name: sender);
    await FirebaseStorage.savePotentialPlayers(chat_id, [player]);
    return _text['plus.message.description']();
  }

  static Future<String> runCommand(String chat_id, String text) async {
    var arguments = text.split(" ");

    if (arguments.length < 2) return Future.value(_text['illegal.argument.run']());

    var strategy = arguments[1];
    var players = await FirebaseStorage.getPotentialPlayers(chat_id);
    await FirebaseStorage.savePotentialPlayers(chat_id, []);

    var game = Game(strategy, players);
    return FirebaseStorage.createGame(chat_id, game)
    .then((_) => _text['new.game.created'](game.players.length));
  }

  static Future<String> currentCommand(String chat_id) {
    return FirebaseStorage.getGame(chat_id)
    .then((game) => game != null ? Formatter.formatGame(game) : _text['no.games']());
  }

  static Future<String> plusKeyword(String chat_id, String sender) async {
    var player = Player(name: sender);
    await FirebaseStorage.addPotentialPlayer(chat_id, player);
    return null;
  }
}
