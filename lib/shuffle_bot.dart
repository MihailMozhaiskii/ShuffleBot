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
    final text = _text['greeting'](Formatter.formatName(sender));

    await FirebaseStorage.createGame(chat_id, null);
    await FirebaseStorage.savePotentialPlayers(chat_id, []);

    return text;
  }

  static Future<String> createCommand(String chat_id, String text) async {
    final arguments = text.split(" ");

    if (arguments.length < 3) return _text['create.fail.argument']();

    final game = Parser.parseGame(arguments.sublist(1));

    if (game == null) return _text['create.fail.argument']();

    await FirebaseStorage.createGame(chat_id, game);

    return _text['new.game.created'](game.players.length);
  }

  static Future<String> shuffleCommand(String chat_id, String text) async {
    final arguments = text.split(" ");
    final players = await FirebaseStorage.getPotentialPlayers(chat_id);
    final hasPotentialPlayers = players.isNotEmpty;

    String strategy = arguments.length == 2 ? arguments[1] : null;

    if (hasPotentialPlayers) {
      if (players.length > 4) return _text['shuffle.fail.argument'];

      if (strategy == null) {
        strategy = (await FirebaseStorage.getDefaultStrategy(chat_id)) ?? '2x2';
      }

      await FirebaseStorage.savePotentialPlayers(chat_id, []);

      var game = Game(strategy, players);
      await FirebaseStorage.createGame(chat_id, game);

      return Formatter.formatShuffle(game.shuffle());
    } else {
      if (strategy != null && !Parser.validateStrategy(strategy)) return _text['shuffle.fail.argument']();

      var game = await FirebaseStorage.getGame(chat_id);

      if (game == null) return _text['empty.game']();

      if (strategy != null) {
        game = Game(strategy, game.players);
        await FirebaseStorage.createGame(chat_id, game);
      }

      return Formatter.formatShuffle(game.shuffle());
    }
  }

  static Future<String> addCommand(String chat_id, String text) async {
    final arguments = text.split(" ");

    if (arguments.length < 2) return Future.value(_text['illegal.arguments.add']());

    final players = arguments.sublist(1)
        .toSet()
        .map((name) => removePrefixIfNeeded(name))
        .map((name) => Player(name: name))
        .toList();

    final result = <Player, bool>{};
    for (var player in players) {
      result[player] = await FirebaseStorage.addPlayer(chat_id, player);
    }

    final addedPlayers = players.where((player) => result[player]).toList();
    final alreadyExistPlayers = players.where((player) => !result[player])
        .toList();

    final addedText = () {
      final addedTextRes = addedPlayers.length > 1
          ? _text['were.added']
          : _text['was.added'];
      return addedTextRes(Formatter.formatPlayers(addedPlayers, ', '));
    };

    final alreadyExistText = () {
      final alreadyExistRes = alreadyExistPlayers.length > 1
          ? _text['already.exists']
          : _text['already.exist'];
      return alreadyExistRes(Formatter.formatPlayers(alreadyExistPlayers, ', '));
    };

    if (addedPlayers.isEmpty) return alreadyExistText();
    if (alreadyExistPlayers.isEmpty) return addedText();

    return "${addedText()}\n\n${alreadyExistText()}";
  }

  static Future<String> removeCommand(String chat_id, String text) async {
    var arguments = text.split(" ");

    if (arguments.length < 2) return Future.value(_text['illegal.arguments.remove']());

    var players = arguments.sublist(1)
        .toSet()
        .map((name) => removePrefixIfNeeded(name))
        .map((name) => Player(name: name))
        .toList();

    final result = <Player, bool>{};
    for (var player in players) {
      result[player] = await FirebaseStorage.removePlayer(chat_id, player);
    }

    final removedPlayers = players.where((player) => result[player]).toList();
    final notFoundPlayers = players.where((player) => !result[player]).toList();

    final removedText = () {
      final addedTextTes = removedPlayers.length > 1
          ? _text['were.removed']
          : _text['was.removed'];
      return addedTextTes(Formatter.formatPlayers(removedPlayers, ', '));
    };

    final notFoundText = () {
      final notFoundRes = _text['not.found'];
      return notFoundRes(Formatter.formatPlayers(notFoundPlayers, ', '));
    };

    if (removedPlayers.isEmpty) return notFoundText();
    if (notFoundPlayers.isEmpty) return removedText();

    return "${removedText()}\n\n${notFoundText()}";
  }

  static Future<String> goCommand(String chat_id, String sender) async {
    final player = Player(name: sender);
    await FirebaseStorage.savePotentialPlayers(chat_id, [player]);

    return _text['plus.message.description']();
  }

  static Future<String> currentCommand(String chat_id) async {
    final game = await FirebaseStorage.getGame(chat_id);

    return game != null ? Formatter.formatGame(game) : _text['no.games']();
  }

  static Future<String> infoCommand() {
    return Future.value(_text['info']());
  }

  static Future<String> strategyCommand(String chat_id, String text) async {
    final arguments = text.split(' ');

    if (arguments.length == 1) {
      final strategy = await FirebaseStorage.getDefaultStrategy(chat_id);
      return strategy == null ? 'Default strategy: 2x2' : 'Default strategy not found. Please set one';
    } else if (arguments.length == 2) {
      final strategy = arguments[1];

      if (strategy != null && !Parser.validateStrategy(strategy)) return _text['shuffle.fail.argument']();

      await FirebaseStorage.saveDefaultStrategy(strategy, chat_id);

      return 'Saved';
    } else if (arguments.length > 2) {
      return _text['shuffle.fail.argument']();
    }
    return null;
  }

  static Future<String> plusKeyword(String chat_id, String sender) async {
    final player = Player(name: sender);
    await FirebaseStorage.addPotentialPlayer(chat_id, player);

    return null;
  }
}
