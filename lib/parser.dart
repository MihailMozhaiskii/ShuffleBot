import 'package:ShuffleBot/game.dart';
import 'package:ShuffleBot/util.dart';

class Parser {

  static bool validateStrategy(String strategy) {
    for (var number in strategy.split("x")) {
      if (int.tryParse(number) == null) {
        return false;
      }
    }
    
    return true;
  }

  static Game parseGame(List<String> arguments) {
    var strategyData = arguments[0];
    var playersData = arguments.sublist(1).toSet();

    if (!validateStrategy(strategyData)) {
      return null;
    }

    var players = playersData.map((name) => removePrefixIfNeeded(name)).map((name) => Player(name: name)).toList();

    return Game(strategyData, players);
  }
}
