import 'dart:core';
import 'package:ShuffleBot/firebase_storage.dart';
import 'package:ShuffleBot/game.dart';

class ShuffleBot {

  static Future<String> createCommand(String chat_id, String text) {
    var arguments = text.split(" ");

    if (arguments.length < 3) return Future.value("Failed arguments. Use `/create type(1x1 or 2x2) players...`");

    var game = _parseGame(arguments.sublist(1));
    return FirebaseStorage.createGame(chat_id, game).then((_) => 'New game. ${game.players.length}');
  }

  static Future<String> shuffleCommand(String chat_id) {
    return FirebaseStorage.getGame(chat_id)
    .then((game) => game != null ? _formatShuffle(game.shuffle()) : "Please create game firstly. Use /create command");
  }

  static Future<String> addCommand(String chat_id, String text) {
    var arguments = text.split(" ");

    if (arguments.length < 2) return Future.value("Failed arguments. Use `/add player`");

    var player_name = arguments[1];
    var player = Player(name: player_name);

    return FirebaseStorage.addPlayer(chat_id, player)
    .then((_)=> "$player_name added");
  }

  static Future<String> removeCommand(String chat_id, String text) {
    var arguments = text.split(" ");

    if (arguments.length < 2) return Future.value("Failed arguments. Use `/remove player`");

    var player_name = arguments[1];
    var player = Player(name: player_name);

    return FirebaseStorage.removePlayer(chat_id, player)
    .then((is_removed) {
      if (is_removed) {
        return "$player_name was removed.";
      } else {
        return "$player_name not found";
      }
    });
  }

  static Future<String> goCommand(String chat_id, String sender) async {
    var player = Player(name: sender);
    await FirebaseStorage.savePotentialPlayers(chat_id, [player]);
    return "Please send `+` message to join";
  }

  static Future<String> startCommand(String chat_id, String text) async {
    var arguments = text.split(" ");

    if (arguments.length < 2) return Future.value("Failed arguments. Use `/start type(1x1 or 2x2)`");

    var strategy_data = arguments[1];
    var players = await FirebaseStorage.getPotentialPlayers(chat_id);
    await FirebaseStorage.savePotentialPlayers(chat_id, []);

    var strategy = _parseStrategy(strategy_data);
    var game = Game(strategy, players);
    return FirebaseStorage.createGame(chat_id, game)
    .then((_) => 'New game. ${game.players.length}');
  }

  static Future<String> plusKeyword(String chat_id, String sender) async {
    var player = Player(name: sender);
    await FirebaseStorage.addPotentialPlayer(chat_id, player);
    return null;
  }

  static int _parseStrategy(String strategy_data) {
    var strategy;
    switch (strategy_data) {
      case "1x1":
        strategy = 1;
        break;
      case "2x2":
        strategy = 2;
        break;
    }
    return strategy;
  }

  static Game _parseGame(List<String> arguments) {
    var strategy_data = arguments[0];
    var players_data = arguments.sublist(1);

    var strategy = _parseStrategy(strategy_data);

    var players = players_data.map((name) => Player(name: name)).toList();

    return Game(strategy, players);
  }

  static String _formatOpponents(Opponents opponents) {
    return _formatTeam(opponents.teams[0]) + " VS " + _formatTeam(opponents.teams[1]);
  }

  static String _formatTeam(Team team) {
    return _formatPlayers(team.players);
  }

  static String _formatPlayers(List<Player> players) {
    return players.map((player) => player.name).join(" + ");
  }

  static String _formatShuffle(ShuffleResult result) {
    if (result == null) return null;

    var opponents_text = result
      .opponents
      .map((opponent) => _formatOpponents(opponent))
      .join("\n");

    var losers_text = "Losers: " + _formatPlayers(result.losers);

    return opponents_text + "\n" + losers_text;
  }
}