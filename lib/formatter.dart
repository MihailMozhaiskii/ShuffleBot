import 'package:ShuffleBot/game.dart';
import 'package:ShuffleBot/util.dart';

class Formatter {

  static String _formatOpponents(Opponents opponents) {
    return _formatTeam(opponents.teams[0]) + " VS " + _formatTeam(opponents.teams[1]);
  }

  static String _formatTeam(Team team) {
    return _formatPlayers(team.players, " + ");
  }

  static String _formatPlayers(List<Player> players, String separator) {
    return players.map((player) => formatName(player.name)).join(separator);
  }

  static String formatName(String name) {
    return "*${removePrefixIfNeeded(name)}*";
  }

  static String _formatStrategy(int strategy) {
    switch (strategy) {
      case 1 : return "1x1";
        break;
      case 2 : return "2x2";
        break;
    }

    return null;
  }

  static String formatGame(Game game) {
    var players = game.players.isNotEmpty ? _formatPlayers(game.players, ", ") : "empty";
    var players_text = "Players: $players";

    var strategy_text = "Strategy: *${_formatStrategy(game.strategy)}*";
    
    if (players_text.isEmpty && strategy_text.isEmpty) return null;

    if (strategy_text.isEmpty) return players_text;

    return "$players_text\n\n$strategy_text"; 
  }

  static String formatShuffle(ShuffleResult result) {
    if (result == null || result.opponents.isEmpty) return "Can not create opponent pairs. Please add more players\n\nUse `/add` command to add player";

    var opponents = result
      .opponents
      .map((opponent) => _formatOpponents(opponent))
      .join("\n");

    var opponents_text = "Opponents\n" + opponents;

    if (result.losers.isEmpty) return opponents_text;

    var losers_text = "Wasted: ${_formatPlayers(result.losers, ", ")} :(";

    return opponents_text + "\n\n" + losers_text;
  }
}
