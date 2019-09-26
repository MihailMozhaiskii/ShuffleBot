import 'package:ShuffleBot/game.dart';
import 'package:ShuffleBot/util.dart';

class Formatter {

  static String _formatOpponents(Opponents opponents) {
    return opponents.teams.map((team) => _formatTeam(team)).join(" VS ");
  }

  static String _formatTeam(Team team) {
    return formatPlayers(team.players, " + ");
  }

  static String formatPlayers(List<Player> players, String separator) {
    return players.map((player) => formatName(player.name)).join(separator);
  }

  static String formatName(String name) {
    return "*${removePrefixIfNeeded(name)}*";
  }

  static String formatGame(Game game) {
    final players = game.players.isNotEmpty ? formatPlayers(game.players, ", ") : "empty";
    final playersText = "Players: $players";

    final strategyText = "Strategy: *${game.strategy}*";
    
    if (playersText.isEmpty && strategyText.isEmpty) return null;

    if (strategyText.isEmpty) return playersText;

    return "$playersText\n\n$strategyText";
  }

  static String formatShuffle(ShuffleResult result) {
    if (result == null || result.opponents.isEmpty) return "Can not create opponent pairs. Please add more players\n\nUse `/add` command to add player";

    final opponents = result
      .opponents
      .map((opponent) => _formatOpponents(opponent))
      .join("\n");

    final opponentsText = "Opponents\n" + opponents;

    if (result.losers.isEmpty) return opponentsText;

    final losersText = "Wasted: ${formatPlayers(result.losers, ", ")} :(";

    return opponentsText + "\n\n" + losersText;
  }
}
