import 'package:ShuffleBot/game.dart';
import 'package:test/test.dart';

void main() {
  test('Single shuffle strategy work correctly', () {
    var strategy = "1x1";
    var players = [Player(name: "one"), Player(name: "two")];

    var result = Game(strategy, players).shuffle();

    var opponents = result.opponents;
    var losers = result.losers;

    var player1 = opponents[0].teams[0].players[0];
    var player2 = opponents[0].teams[1].players[0];

    expect(opponents.length, 1);
    expect(opponents[0].teams[0].players.length, 1);
    expect(opponents[0].teams[1].players.length, 1);
    expect(player1 != player2, true);
    expect(losers.length, 0);
  });

  test('Single shuffle strategy return loses correctly', () {
    var strategy = "1x1";
    var players = [Player(name: "one"), Player(name: "two"), Player(name: "three")];

    var result = Game(strategy, players).shuffle();

    var opponents = result.opponents;
    var losers = result.losers;

    var player1 = opponents[0].teams[0].players[0];
    var player2 = opponents[0].teams[1].players[0];

    expect(opponents.length, 1);
    expect(opponents[0].teams[0].players.length, 1);
    expect(opponents[0].teams[1].players.length, 1);
    expect(player1 != player2, true);
    expect(losers.length, 1);
  });

  test('Single shuffle strategy work correctly with large data', () {
    var strategy = "1x1";
    var players = [Player(name: "one"), Player(name: "two"), Player(name: "three"), Player(name: "four")];

    var result = Game(strategy, players).shuffle();

    var opponents = result.opponents;
    var losers = result.losers;

    expect(opponents.length, 2);
    expect(opponents[0].teams[0].players.length, 1);
    expect(opponents[0].teams[1].players.length, 1);
    expect(opponents[1].teams[0].players.length, 1);
    expect(opponents[1].teams[1].players.length, 1);
    expect(losers.length, 0);
  });

  test('Pair shuffle strategy work correctly', () {
    var strategy = "2x2";
    var players = [Player(name: "one"), Player(name: "two")];

    var result = Game(strategy, players).shuffle();

    var opponents = result.opponents;
    var losers = result.losers;

    expect(opponents.length, 0);
    expect(losers.length, 2);
  });

  test('Pair shuffle strategy return loses correctly', () {
    var strategy = "2x2";
    var players = [Player(name: "one"), Player(name: "two"), Player(name: "three"), Player(name: "four"), Player(name: "five")];

    var result = Game(strategy, players).shuffle();

    var opponents = result.opponents;
    var losers = result.losers;

    expect(opponents.length, 1);
    expect(opponents[0].teams[0].players.length, 2);
    expect(opponents[0].teams[1].players.length, 2);
    expect(losers.length, 1);
  });

  test('Pair shuffle strategy work correctly with large data', () {
    var strategy = "2x2";
    var players = [Player(name: "one"), Player(name: "two"), Player(name: "three"), Player(name: "four"), Player(name: "five"), Player(name: "six")];

    var result = Game(strategy, players).shuffle();

    var opponents = result.opponents;
    var losers = result.losers;

    expect(opponents.length, 1);
    expect(opponents[0].teams[0].players.length, 2);
    expect(opponents[0].teams[1].players.length, 2);
    expect(losers.length, 2);
  });

  test('Multiply shuffle strategy work correctly with large data', () {
    var strategy = "2x2x2";
    var players = [Player(name: "one"), Player(name: "two"), Player(name: "three"), Player(name: "four"), Player(name: "five"), Player(name: "six"), Player(name: "seven")];

    var result = Game(strategy, players).shuffle();

    var opponents = result.opponents;
    var losers = result.losers;

    expect(opponents.length, 1);
    expect(opponents[0].teams[0].players.length, 2);
    expect(opponents[0].teams[1].players.length, 2);
    expect(opponents[0].teams[2].players.length, 2);
    expect(losers.length, 1);
  });

}
