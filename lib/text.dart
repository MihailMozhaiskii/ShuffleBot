final Map<String, dynamic> ENG = {
  'greeting': (username) => "Hi, ${username}\n\n"
    + "*This bot can help you to shuffle players to teams during tournament.*\n\n" 
    + "`/create` - command which create new game. *Type* - required argument (example 1x1, 2x2, 3x3x3). It is type of your team by members count.\n"
    + "`/shuffle` - command which create new *random* teams each time.\n"
    + "`/add` - command which add new players.\n"
    + "`/remove` - command which remove players.\n"
    + "`/current` - info about current game.\n"
    + "`/info` - info about available commands.\n"
    + "\n*Group chat features*\n\n"
    + "You can tap `/go` command which notify other members about coming event. Each of members can send *+* message which notify bot what "
    + "this member want to join coming event. After that user tap `/run` command with *type* argument and bot will create new game.",
  'info': () => "*Commands*\n\n"
    + "`/create` - command which create new game. *Type* - required argument (example 1x1, 2x2, 3x3x3). It is type of your team by members count.\n"
    + "`/shuffle` - command which create new *random* teams each time.\n"
    + "`/add` - command which add new players.\n"
    + "`/remove` - command which remove players.\n"
    + "`/current` - info about current game.\n"
    + "`/info` - info about available commands.\n"
    + "\n*Group chat features*\n\n"
    + "You can tap `/go` command which notify other members about coming event. Each of members can send *+* message which mean  member want to " 
    + "join coming event. After entering `/shuffle` command with *type* argument bot will create new game.",
  'create.fail.argument': () => "Failed arguments.\n\nUse `/create *type*(example 1x1, 2x2, 3x3x3) players...`.",
  'shuffle.fail.argument': () => "Failed arguments.\n\nUse `/shuffle` or `/shuffle` *type*",
  'new.game.created': (player_length) => "New game was created. *${player_length}* players\n\nUse `/add` and `/remove` commands to edit count of players.",
  'empty.game': () => "Please create game firstly.\n\nUse `/create` command.",
  'illegal.arguments.add': () => "Illegal arguments.\n\nUse `/add player`.",
  'illegal.arguments.remove': () => "Illegal arguments.\n\nUse `/remove player`.",
  'was.added': (player) => "$player was added.",
  'were.added': (players) => "$players were added.",
  'already.exist': (player) => "$player already exist.",
  'already.exists': (players) => "$players already exists.",
  'was.removed': (player) => "$player was removed.",
  'were.removed': (players) => "$players were removed.",
  'not.found': (player) => "$player not found.",
  'plus.message.description': () => "Please send *+* message to join.",
  'illegal.argument.run': () => "Illegal arguments.\n\nUse `/run type(`*1x1*` or `*2x2*`)`.",
  'no.games': () => "Can not find any game. Create one.\n\nUse `/create` command."
};
