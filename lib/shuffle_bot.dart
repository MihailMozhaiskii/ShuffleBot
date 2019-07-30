import 'dart:core';
import 'package:ShuffleBot/firebase_storage.dart';
import 'package:ShuffleBot/game.dart';
class ShuffleBot {

  static String createCommand(String chat_id, String text) {
    var arguments = text.split(" ");

    if (arguments.length < 3) { return ""; }

    var game = _parseGame(arguments.sublist(1));
    FirebaseStorage.createGame(chat_id, game);

    return 'New game. ${game.players.length}';
  }

  static Future<String> shuffleCommand(String chat_id) {
    return FirebaseStorage.getGame(chat_id)
    .then((game) => _formatShuffle(game.shuffle()));
  }

  static Future<String> addCommand(String chat_id, String text) {
    var arguments = text.split(" ");
    var player_name = arguments[1];
    var player = Player(name: player_name);

    return FirebaseStorage.addPlayer(chat_id, player)
    .then((_)=> "$player_name added");
  }

  static Future<String> removeCommand(String chat_id, String text) {
    var arguments = text.split(" ");
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

  static Game _parseGame(List<String> arguments) {
    var strategy_data = arguments[0];
    var players_data = arguments.sublist(1);

    var strategy;
    switch (strategy_data) {
      case "1x1":
        strategy = 1;
        break;
      case "2x2":
        strategy = 2;
        break;
    }

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
    var opponents_text = result
      .opponents
      .map((opponent) => _formatOpponents(opponent))
      .join("\n");

    var losers_text = "Losers: " + _formatPlayers(result.losers);

    return opponents_text + "\n" + losers_text;
  }
}