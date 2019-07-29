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
  int strategy;
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

  int strategy;
  List<Player> players;

  Game(int strategy, List<Player> players) {
    this.strategy = strategy;
    this.players = players;
  }

  ShuffleResult shuffle() {
    int team_members_count = strategy;

    int opponents_count = 2;

    players.shuffle();
    Queue<Player> players_queue = Queue.from(players);

    List<Opponents> all_opponents = [];
    while(players_queue.length >= team_members_count * opponents_count) {
      List<Team> teams = [];
      for(var i = 0; i < opponents_count; i++) {
        List<Player> team_players = [];
        for(var j = 0; j < team_members_count; j++) {
          Player player = players_queue.removeLast();
          team_players.add(player);
        }

        Team team = Team(team_players);
        teams.add(team);
      }

      Opponents opponents = Opponents(teams);
      all_opponents.add(opponents);
    }

    return ShuffleResult(all_opponents, players_queue.toList());
  }
}
