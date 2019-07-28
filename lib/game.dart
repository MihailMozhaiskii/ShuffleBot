import 'dart:collection';

enum ShuffleStrategy { SINGLE, PAIR }

class Player {
  String name;

  Player(String name) {
    this.name = name;
  }
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

class Game {

  ShuffleStrategy _strategy;
  List<Player> _players;

  Game(ShuffleStrategy strategy, List<Player> players) {
    this._strategy = strategy;
    this._players = players;
  }

  ShuffleResult shuffle() {
    int team_members_count;
    switch (_strategy) {
      case ShuffleStrategy.PAIR:
        team_members_count = 2;
        break;
      case ShuffleStrategy.SINGLE:
        team_members_count = 1;
        break;
    }

    int opponents_count = 2;

    _players.shuffle();
    Queue<Player> players = Queue.from(_players);

    List<Opponents> all_opponents = [];
    while(players.length >= team_members_count * opponents_count) {
      List<Team> teams = [];
      for(var i = 0; i < opponents_count; i++) {
        List<Player> team_players = [];
        for(var j = 0; j < team_members_count; j++) {
          Player player = players.removeLast();
          team_players.add(player);
        }

        Team team = Team(team_players);
        teams.add(team);
      }

      Opponents opponents = Opponents(teams);
      all_opponents.add(opponents);
    }

    return ShuffleResult(all_opponents, players.toList());
  }
}
