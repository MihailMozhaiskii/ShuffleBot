import 'dart:core';
import 'package:ShuffleBot/game.dart';

String handleCreateCommand(String text) {
  var arguments = text.split(" ");
  
  var players = arguments.sublist(2).map((name) => Player(name)).toList();
  var strategy;
  switch (arguments[1]) {
    case "1x1":
      strategy = ShuffleStrategy.SINGLE;
      break;
    case "2x2":
      strategy = ShuffleStrategy.PAIR;
      break;
  }

  Game game = Game(strategy, players);
  var shuffle_result = game.shuffle();

  var opponents_text = shuffle_result
    .opponents
    .map((opponent) => _formatOpponents(opponent))
    .join("\n");

  var losers_text = "Losers: " + _formatPlayers(shuffle_result.losers);

  return opponents_text + "\n" + losers_text;
}

String _formatOpponents(Opponents opponents) {
  return _formatTeam(opponents.teams[0]) + " VS " + _formatTeam(opponents.teams[1]);
}

String _formatTeam(Team team) {
  return _formatPlayers(team.players);
}

String _formatPlayers(List<Player> players) {
  return players.map((player) => player.name).join(" + ");
}
