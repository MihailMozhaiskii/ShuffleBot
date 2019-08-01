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

    return text;
  }
  static Future<String> createCommand(String chat_id, String text) async {
    var arguments = text.split(" ");

    if (arguments.length < 3) return _text['create.fail.argument']();

    var game = Parser.parseGame(arguments.sublist(1));

    if (game == null) return _text['create.fail.argument']();

    await FirebaseStorage.createGame(chat_id, game);

    return _text['new.game.created'](game.players.length);
  }

  static Future<String> shuffleCommand(String chat_id, String text) async {
    var arguments = text.split(" ");
    if (arguments.length > 2) return _text['shuffle.fail.argument'];

    String strategy = arguments.length == 2 ? arguments[1] : null;

    var game = await FirebaseStorage.getGame(chat_id);

    if (game == null) return _text['empty.game'];

    if (strategy != null) {
      game = Game(strategy, game.players);
      await FirebaseStorage.createGame(chat_id, game);
    }

    return Formatter.formatShuffle(game.shuffle());
  }

  static Future<String> addCommand(String chat_id, String text) async {
    var arguments = text.split(" ");

    if (arguments.length < 2) return Future.value( _text['illegal.arguments.add']());

    var players = arguments.sublist(1)
    .toSet()
    .map((name) => removePrefixIfNeeded(name))
    .map((name) => Player(name: name))
    .toList();

    Map<Player, bool> result = {};
    for (var player in players) {
      result[player] = await FirebaseStorage.addPlayer(chat_id, player);
    }

    var added_players = players.where((player) => result[player]).toList();
    var already_exist_players = players.where((player) => !result[player]).toList();

    var added_text = () {
      var added_text_res = added_players.length > 1 ? _text['were.added'] : _text['was.added'];
      return added_text_res(Formatter.formatPlayers(added_players, ', '));
    };
    
    var already_exist_text = () {
      var already_exist_res = already_exist_players.length > 1 ? _text['already.exists'] : _text['already.exist'];
      return already_exist_res(Formatter.formatPlayers(already_exist_players, ', '));
    };

    if (added_players.isEmpty) return already_exist_text();
    if (already_exist_players.isEmpty) return added_text();

    return "${added_text()}\n\n${already_exist_text()}";
  }

  static Future<String> removeCommand(String chat_id, String text) async {
    var arguments = text.split(" ");

    if (arguments.length < 2) return Future.value(_text['illegal.arguments.remove']());

    var players = arguments.sublist(1)
    .toSet()
    .map((name) => removePrefixIfNeeded(name))
    .map((name) => Player(name: name))
    .toList();

    Map<Player, bool> result = {};
    for (var player in players) {
      result[player] = await FirebaseStorage.removePlayer(chat_id, player);
    }

    var removed_players = players.where((player) => result[player]).toList();
    var not_found_players = players.where((player) => !result[player]).toList();

    var removed_text = () {
      var added_text_res = removed_players.length > 1 ? _text['were.removed'] : _text['was.removed'];
      return added_text_res(Formatter.formatPlayers(removed_players, ', '));
    };
    
    var not_found_text = () {
      var not_found_res = _text['not.found'];
      return not_found_res(Formatter.formatPlayers(not_found_players, ', '));
    };

    if (removed_players.isEmpty) return not_found_text();
    if (not_found_players.isEmpty) return removed_text();

    return "${removed_text()}\n\n${not_found_text()}";
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
    await FirebaseStorage.createGame(chat_id, game);

    return  _text['new.game.created'](game.players.length);
  }

  static Future<String> currentCommand(String chat_id) async {
    var game = await FirebaseStorage.getGame(chat_id);

    return game != null ? Formatter.formatGame(game) : _text['no.games']();
  }

  static Future<String> plusKeyword(String chat_id, String sender) async {
    var player = Player(name: sender);
    await FirebaseStorage.addPotentialPlayer(chat_id, player);

    return null;
  }
}
