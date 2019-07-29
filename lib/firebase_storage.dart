import 'dart:async';
import 'dart:convert';
import 'package:ShuffleBot/game.dart';
import 'package:http/http.dart' as http;

class FirebaseStorage {

  static Future createGame(String chat_id, Game game) async {
    var properties = GameProperties(strategy: game.strategy, players: game.players);
    var data = json.encode(properties.toJson());

    var url = 'https://chu-wa-chi.firebaseio.com/games/$chat_id.json';
    var responce = await http.put(url, body: data);

    print("CHAT::$chat_id : new game : ${responce.statusCode} ${responce.body}");
  }

  static Future<Game> getGame(String chat_id) async {
    var url = 'https://chu-wa-chi.firebaseio.com/games/$chat_id.json';
    var responce = await http.get(url);

    var body = responce.body;
    var result = json.decode(body);

    var game_properties = GameProperties.fromJson(result);
    return Game(game_properties.strategy, game_properties.players);
  }

  static Future addPlayer(String chat_id, Player player) async {
    var game = await getGame(chat_id);
    if (game == null) return;

    game.players.add(player);

    await createGame(chat_id, game);
  }

  static Future<bool> removePlayer(String chat_id, Player player) async {
    var game = await getGame(chat_id);
    if (game == null) return false;

    var length = game.players.length;
    game.players.removeWhere((p) => p.name == player.name);
    
    if(length != game.players.length) {
      await createGame(chat_id, game);
      return true;
    } else {
      return false;
    }
  }
}
