import 'dart:collection';

class Player {
  String name;

  Player({ 
    this.name 
  });

  Map toJson() => {
    'name': name
  };
}

class Team {
  List<Player> players;

  Team(List<Player> players) {
    this.players = players;
  }
}

class Opponents {
  List<Team> teams;

  Opponents(List<Team> teams) {
    this.teams = teams;
  }
}

class ShuffleResult {
  List<Opponents> opponents;
  List<Player> losers;

  ShuffleResult(List<Opponents> opponents, List<Player> losers) {
    this.opponents = opponents;
    this.losers = losers;
  }
}

class GameProperties {
  String strategy;
  List<Player> players;

  GameProperties({
    this.strategy,
    this.players
  });

  factory GameProperties.fromJson(Map<String, dynamic> json) {
    return GameProperties(
      strategy: json['strategy'],
      players: (json['players'] as List).map((item) => item['name']).map((name) => Player(name: name)).toList()
    );
  }

  Map toJson() => {
    'strategy': strategy,
    'players': players
  };
}

class Game {

  String strategy;
  List<Player> players;

  List<int> _players_division;

  Game(String strategy, List<Player> players) {
    this.strategy = strategy;
    this.players = players;

    this._players_division = strategy.split("x").map((number) => int.parse(number)).toList();
  }

  ShuffleResult shuffle() {
    final minMembersCount = _players_division.reduce((acc, value) => acc + value);
    final opponentsCount = _players_division.length;

    players.shuffle();
    Queue<Player> playersQueue = Queue.from(players);

    List<Opponents> allOpponents = [];
    while(playersQueue.length >= minMembersCount) {
      List<Team> teams = [];
      for(var i = 0; i < opponentsCount; i++) {
        List<Player> team_players = [];
        for(var j = 0; j < _players_division[i]; j++) {
          Player player = playersQueue.removeLast();
          team_players.add(player);
        }

        Team team = Team(team_players);
        teams.add(team);
      }

      Opponents opponents = Opponents(teams);
      allOpponents.add(opponents);
    }

    return ShuffleResult(allOpponents, playersQueue.toList());
  }
}
