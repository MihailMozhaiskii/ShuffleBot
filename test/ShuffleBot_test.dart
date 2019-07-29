import 'package:ShuffleBot/ShuffleBot.dart';
import 'package:test/test.dart';

void main() {
  test('Single shuffle strategy work correctly', () {
    int strategy = 1;

    List<Player> players = [Player(name: "one"), Player(name: "two")];

    ShuffleResult result = Game(strategy, players).shuffle();

    List<Opponents> opponents = result.opponents;
    List<Player> losers = result.losers;

    Player player1 = opponents[0].teams[0].players[0];
    Player player2 = opponents[0].teams[1].players[0];
  

    expect(opponents.length, 1);
    expect(opponents[0].teams[0].players.length, 1);
    expect(opponents[0].teams[1].players.length, 1);
    expect(player1 != player2, true);
    expect(losers.length, 0);
  });

  test('Single shuffle strategy return loses correctly', () {
    int strategy = 1;

    List<Player> players = [Player("one"), Player("two"), Player("three")];

    ShuffleResult result = Game(strategy, players).shuffle();

    List<Opponents> opponents = result.opponents;
    List<Player> losers = result.losers;

    Player player1 = opponents[0].teams[0].players[0];
    Player player2 = opponents[0].teams[1].players[0];
  

    expect(opponents.length, 1);
    expect(opponents[0].teams[0].players.length, 1);
    expect(opponents[0].teams[1].players.length, 1);
    expect(player1 != player2, true);
    expect(losers.length, 1);
  });

  test('Single shuffle strategy work correctly with large data', () {
    int strategy = 1;

    List<Player> players = [Player("one"), Player("two"), Player("three"), Player("four")];

    ShuffleResult result = Game(strategy, players).shuffle();

    List<Opponents> opponents = result.opponents;
    List<Player> losers = result.losers;

    expect(opponents.length, 2);
    expect(opponents[0].teams[0].players.length, 1);
    expect(opponents[0].teams[1].players.length, 1);
    expect(opponents[1].teams[0].players.length, 1);
    expect(opponents[1].teams[1].players.length, 1);
    expect(losers.length, 0);
  });

  test('Pair shuffle strategy work correctly', () {
    int strategy = 2;

    List<Player> players = [Player("one"), Player("two")];

    ShuffleResult result = Game(strategy, players).shuffle();

    List<Opponents> opponents = result.opponents;
    List<Player> losers = result.losers;

    expect(opponents.length, 0);
    expect(losers.length, 2);
  });

  test('Pair shuffle strategy return loses correctly', () {
    int strategy = 2;

    List<Player> players = [Player("one"), Player(name: "two"), Player(name: "three"), Player(name: "four"), Player(name: "five")];

    ShuffleResult result = Game(strategy, players).shuffle();

    List<Opponents> opponents = result.opponents;
    List<Player> losers = result.losers;

    expect(opponents.length, 1);
    expect(opponents[0].teams[0].players.length, 2);
    expect(opponents[0].teams[1].players.length, 2);
    expect(losers.length, 1);
  });

  test('Single shuffle strategy work correctly with large data', () {
    int strategy = 2;

    List<Player> players = [Player("one"), Player("two"), Player("three"), Player("four"), Player("five"), Player("six")];

    ShuffleResult result = Game(strategy, players).shuffle();

    List<Opponents> opponents = result.opponents;
    List<Player> losers = result.losers;

    expect(opponents.length, 1);
    expect(opponents[0].teams[0].players.length, 2);
    expect(opponents[0].teams[1].players.length, 2);
    expect(losers.length, 2);
  });
}
