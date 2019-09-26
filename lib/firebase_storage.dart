import 'dart:async';
import 'dart:convert';
import 'package:ShuffleBot/game.dart';
import 'package:http/http.dart' as http;

class FirebaseStorage {

  static Future createGame(String chat_id, Game game) async {
    final properties = GameProperties(strategy: game?.strategy, players: game?.players ?? []);
    final data = json.encode(properties);

    final url = 'https://chu-wa-chi.firebaseio.com/games/$chat_id/game.json';
    await http.put(url, body: data);
  }

  static Future<Game> getGame(String chat_id) async {
    final url = 'https://chu-wa-chi.firebaseio.com/games/$chat_id/game.json';
    final response = await http.get(url);

    final body = response.body;
    final result = json.decode(body);

    final properties = result != null ? GameProperties.fromJson(result) : null;
    return properties != null ? Game(properties.strategy, properties.players) : null;
  }

  static Future addPotentialPlayer(String chat_id, Player player) async {
    final players = <Player>[];
    var savedPlayers = await getPotentialPlayers(chat_id);
    if (savedPlayers != null) {
      players.addAll(savedPlayers);
    } else {
      return;
    }

    final isExist = players.firstWhere((p) => player.name == p.name) != null;
    if (isExist) return;

    players.add(player);

    await savePotentialPlayers(chat_id, players);
  }

  static Future savePotentialPlayers(String chat_id, List<Player> players) async {
    final data = json.encode({ 'players': players });

    final url = 'https://chu-wa-chi.firebaseio.com/games/$chat_id/potential.json';
    await http.put(url, body: data);
  }

  static Future<List<Player>> getPotentialPlayers(String chat_id) async {
    final url = 'https://chu-wa-chi.firebaseio.com/games/$chat_id/potential.json';
    final response = await http.get(url);

    final body = response.body;
    final result = json.decode(body);

    return result != null
        ? (result['players'] as List).map((item) => item['name']).map((name) => Player(name: name)).toList()
        : null;
  }

  static Future saveDefaultStrategy(String strategy, String chat_id) async {
    final data = json.encode({ 'strategy': strategy });

    final url = 'https://chu-wa-chi.firebaseio.com/games/$chat_id/default_strategy.json';
    await http.put(url, body: data);
  }

  static Future<String> getDefaultStrategy(String chat_id) async {
    final url = 'https://chu-wa-chi.firebaseio.com/games/$chat_id/default_strategy.json';
    final response = await http.get(url);

    final body = response.body;
    final result = json.decode(body);

    return result != null ? result['strategy'] : null;
  }

  static Future<bool> addPlayer(String chat_id, Player player) async {
    final game = await getGame(chat_id);

    if (game == null) return false;

    final containsPlayer = game.players.firstWhere((p) => player.name == p.name) != null;
    if (containsPlayer) return false;

    game.players.add(player);

    await createGame(chat_id, game);

    return true;
  }

  static Future<bool> removePlayer(String chat_id, Player player) async {
    final game = await getGame(chat_id);
    if (game == null) return false;

    final playersLength = game.players.length;
    game.players.removeWhere((p) => p.name == player.name);
    
    if(playersLength != game.players.length) {
      await createGame(chat_id, game);
      return true;
    } else {
      return false;
    }
  }
}
