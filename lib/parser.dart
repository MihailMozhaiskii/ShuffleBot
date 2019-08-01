import 'package:ShuffleBot/game.dart';
import 'package:ShuffleBot/util.dart';

class Parser {

  static bool _validateStartegy(String strategy) {
    for (var number in strategy.split("x")) {
      if (int.tryParse(number) == null) {
        return false;
      }
    }
    
    return true;
  }

  static Game parseGame(List<String> arguments) {
    var strategy_data = arguments[0];
    var players_data = arguments.sublist(1).toSet();

    if (!_validateStartegy(strategy_data)) {
      return null;
    }

    var players = players_data.map((name) => removePrefixIfNeeded(name)).map((name) => Player(name: name)).toList();

    return Game(strategy_data, players);
  }
}
