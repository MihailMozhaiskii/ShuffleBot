import 'package:ShuffleBot/game.dart';
import 'package:ShuffleBot/util.dart';

class Parser {

  static int parseStrategy(String strategy_data) {
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

  static Game parseGame(List<String> arguments) {
    var strategy_data = arguments[0];
    var players_data = arguments.sublist(1);

    var strategy = parseStrategy(strategy_data);

    var players = players_data.map((name) => removePrefixIfNeeded(name)).map((name) => Player(name: name)).toList();

    return Game(strategy, players);
  }
}
