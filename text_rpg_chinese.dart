// text_rpg_language_learning.dart
import 'dart:io';
import 'dart:math';

// ----------------------------
// 1. 数据模型 (Data Models)
// ----------------------------

class Item {
  final String name;
  final String namePinyin;
  final String description;
  final String descriptionPinyin;
  final String descriptionEn;

  Item({
    required this.name,
    required this.namePinyin,
    required this.description,
    required this.descriptionPinyin,
    required this.descriptionEn,
  });

  // Add this method to the Item class
  String nameEn() {
    if (name == '剑') return 'Sword';
    if (name == '金杯') return 'Golden Chalice';
    return name;
  }
}

class Player {
  int health = 100;
  List<Item> inventory = [];
  String currentRoomId = 'entrance';

  void addItem(Item item) {
    inventory.add(item);
    print('\n${item.name}');
    print('${item.namePinyin}');
    print('You picked up: ${item.nameEn()}');
  }

  bool hasItem(String itemName) {
    return inventory.any((item) => item.name == itemName);
  }

  void removeItem(String itemName) {
    inventory.removeWhere((item) => item.name == itemName);
  }

  void showInventory() {
    if (inventory.isEmpty) {
      print('\n你的背包是空的。');
      print('Nǐ de bēibāo shì kōng de.');
      print('Your backpack is empty.');
    } else {
      print('\n你携带的物品：');
      print('Nǐ xiédài de wùpǐn:');
      print('You are carrying:');
      for (var item in inventory) {
        print('  - ${item.name} (${item.namePinyin}) - ${item.nameEn()}');
      }
    }
  }

  void showStatus() {
    print('\n=== 状态 / Zhuàngtài ===');
    print('生命值：$health/100');
    print('Shēngmìng zhí: $health/100');
    print('Health: $health/100');
    showInventory();
  }
}
class Room {
  final String id;
  final String name;
  final String namePinyin;
  final String description;
  final String descriptionPinyin;
  final String descriptionEn;
  final Map<String, String> exits;
  final Item? item;
  final String? monster;
  final String? monsterPinyin;

  Room({
    required this.id,
    required this.name,
    required this.namePinyin,
    required this.description,
    required this.descriptionPinyin,
    required this.descriptionEn,
    required this.exits,
    this.item,
    this.monster,
    this.monsterPinyin,
  });

  void describe() {
    print('\n=== $name ===');
    print('$namePinyin');
    print('$nameEn()');
    
    print('\n$description');
    print('$descriptionPinyin');
    print('$descriptionEn');
    
    if (monster != null) {
      print('\n一只野生$monster挡住了你的去路！');
      print('Yī zhī yěshēng $monster dǎngzhùle nǐ de qùlù!');
      print('A wild $monsterEn() blocks your path!');
    }
    
    if (item != null) {
      print('\n你看到这里有一个${item!.name}。');
      print('Nǐ kàndào zhèlǐ yǒu yī gè ${item!.namePinyin}。');
      print('You see a ${item!.nameEn()} here.');
    }
    
    print('\n出口：${exits.keys.join('、')}');
    print('Chūkǒu: ${exits.keys.join('、')}');
    print('Exits: ${exits.keys.join(', ')}');
  }
  
  String nameEn() {
    if (name == '洞穴入口') return 'Cave Entrance';
    if (name == '洞外') return 'Outside the Cave';
    if (name == '黑暗走廊') return 'Dark Hallway';
    if (name == '废弃军械库') return 'Abandoned Armory';
    if (name == '宝藏室') return 'Treasure Chamber';
    return name;
  }
  
  String monsterEn() {
    if (monster == '哥布林') return 'Goblin';
    if (monster == '巨魔') return 'Troll';
    return monster ?? 'Monster';
  }
}

// ----------------------------
// 2. 游戏世界 (Game World)
// ----------------------------

final Map<String, Room> world = {
  'entrance': Room(
    id: 'entrance',
    name: '洞穴入口',
    namePinyin: 'Dòngxué rùkǒu',
    description: '你站在一个黑暗阴森的洞穴入口。冰冷的风从深处呼啸而出。',
    descriptionPinyin: 'Nǐ zhàn zài yī gè hēi\'àn yīnsēn de dòngxué rùkǒu. Bīnglěng de fēng cóng shēnchù hūxiào ér chū.',
    descriptionEn: 'You stand at the mouth of a dark, foreboding cave. Cold wind whistles out from the depths.',
    exits: {'北': 'hallway', '出': 'outside'},
  ),
  'outside': Room(
    id: 'outside',
    name: '洞外',
    namePinyin: 'Dòng wài',
    description: '你回到了阳光明媚的草地上。洞穴入口在南边。',
    descriptionPinyin: 'Nǐ huí dào le yángguāng míngmèi de cǎodì shàng. Dòngxué rùkǒu zài nánbiān.',
    descriptionEn: 'You are back in the sunny meadow. The cave entrance is to the south.',
    exits: {'南': 'entrance'},
  ),
  'hallway': Room(
    id: 'hallway',
    name: '黑暗走廊',
    namePinyin: 'Hēi\'àn zǒuláng',
    description: '一条由粗糙石头凿成的狭长走廊。滴水声在远处回荡。',
    descriptionPinyin: 'Yī tiáo yóu cūcāo shítou záo chéng de xiácháng zǒuláng. Dīshuǐ shēng zài yuǎnchù huídàng.',
    descriptionEn: 'A long, narrow hallway carved from rough stone. Dripping water echoes in the distance.',
    exits: {'南': 'entrance', '东': 'treasury', '西': 'armory'},
    monster: '哥布林',
    monsterPinyin: 'Gēbùlín',
  ),
  'armory': Room(
    id: 'armory',
    name: '废弃军械库',
    namePinyin: 'Fèiqì jūnxièkù',
    description: '生锈的武器挂在墙上。角落里放着一个破损的铁砧。',
    descriptionPinyin: 'Shēngxiù de wǔqì guà zài qiáng shàng. Jiǎoluò lǐ fàng zhe yī gè pòsǔn de tiězhēn.',
    descriptionEn: 'Rusted weapons hang on the walls. A broken anvil sits in the corner.',
    exits: {'东': 'hallway'},
    item: Item(
      name: '剑',
      namePinyin: 'Jiàn',
      description: '一把生锈但仍然锋利的剑。（战斗伤害+10）',
      descriptionPinyin: 'Yī bǎ shēngxiù dàn réngrán fēnglì de jiàn. (Zhàndòu shānghài +10)',
      descriptionEn: 'A rusty but still sharp sword. (+10 attack damage in combat)',
    ),
  ),
  'treasury': Room(
    id: 'treasury',
    name: '宝藏室',
    namePinyin: 'Bǎozàng shì',
    description: '金币和珠宝散落一地。中央立着一个 pedestal。',
    descriptionPinyin: 'Jīnbì hé zhūbǎo sànluò yī dì. Zhōngyāng lì zhe yī gè pedestal.',
    descriptionEn: 'Gold coins and jewels are scattered across the floor. A pedestal stands in the center.',
    exits: {'西': 'hallway'},
    monster: '巨魔',
    monsterPinyin: 'Jùmó',
    item: Item(
      name: '金杯',
      namePinyin: 'Jīn bēi',
      description: '一个华丽的金杯，散发着古老的魔法光芒。这就是你寻找的目标！',
      descriptionPinyin: 'Yī gè huálì de jīn bēi, sànfā zhe gǔlǎo de mófǎ guāngmáng. Zhè jiù shì nǐ xúnzhǎo de mùbiāo!',
      descriptionEn: 'A magnificent golden chalice, glowing with ancient magic. This is what you came for!',
    ),
  ),
};

// Helper function to get item English name
extension ItemExtension on Item {
  String nameEn() {
    if (name == '剑') return 'Sword';
    if (name == '金杯') return 'Golden Chalice';
    return name;
  }
}

// ----------------------------
// 3. 战斗系统 (Combat System)
// ----------------------------

final Map<String, int> monsterHealth = {
  '哥布林': 40,
  '巨魔': 80,
};

final Random _random = Random();

bool fightMonster(String monsterName, Player player) {
  String monsterPinyin = monsterName == '哥布林' ? 'Gēbùlín' : 'Jùmó';
  String monsterEn = monsterName == '哥布林' ? 'Goblin' : 'Troll';
  
  print('\n⚔️ 战斗开始：$monsterName 攻击了你！ ⚔️');
  print('Zhàndòu kāishǐ: $monsterPinyin gōngjí le nǐ!');
  print('Combat begins: $monsterEn attacks you!');
  
  int monsterHp = monsterHealth[monsterName]!;
  
  while (monsterHp > 0 && player.health > 0) {
    print('\n你的生命值：${player.health} | $monsterName 生命值：$monsterHp');
    print('Nǐ de shēngmìng zhí: ${player.health} | $monsterPinyin shēngmìng zhí: $monsterHp');
    print('Your HP: ${player.health} | $monsterEn HP: $monsterHp');
    
    stdout.write('\n(攻)击 或 逃(跑)？ ');
    stdout.write('(Gōng)jī huò táo(pǎo)? ');
    stdout.write('(A)ttack or (R)un? ');
    
    String? action = stdin.readLineSync()?.toLowerCase();
    
    if (action == '攻' || action == 'a' || action == '攻击') {
      int damage = _random.nextInt(20) + 10;
      if (player.hasItem('剑')) {
        damage += 10;
        print('\n你的剑闪耀着寒光！');
        print('Nǐ de jiàn shǎnyào zhe hán guāng!');
        print('Your sword gleams!');
      }
      print('\n你对$monsterName造成了 $damage 点伤害！');
      print('Nǐ duì $monsterPinyin zàochéng le $damage diǎn shānghài!');
      print('You deal $damage damage to the $monsterEn!');
      monsterHp -= damage;
      
      if (monsterHp <= 0) {
        print('\n你击败了$monsterName！胜利属于你！');
        print('Nǐ jībài le $monsterPinyin! Shènglì shǔyú nǐ!');
        print('You defeated the $monsterEn! Victory is yours!\n');
        return true;
      }
      
      int monsterDamage = _random.nextInt(15) + 5;
      print('\n$monsterName 对你造成了 $monsterDamage 点伤害！');
      print('$monsterPinyin duì nǐ zàochéng le $monsterDamage diǎn shānghài!');
      print('The $monsterEn hits you for $monsterDamage damage!');
      player.health -= monsterDamage;
      
      if (player.health <= 0) {
        print('\n你被$monsterName杀死了... 游戏结束。');
        print('Nǐ bèi $monsterPinyin shā sǐ le... Yóuxì jiéshù.');
        print('You have been slain by the $monsterEn... Game over.\n');
        return false;
      }
    } 
    else if (action == '跑' || action == 'r' || action == '逃跑') {
      print('\n你向来路逃了回去！');
      print('Nǐ xiàng láilù táo le huíqù!');
      print('You flee back the way you came!\n');
      return false;
    } 
    else {
      print('\n无效命令。请输入 "攻" 或 "跑"。');
      print('Wúxiào mìnglìng. Qǐng shūrù "gōng" huò "pǎo".');
      print('Invalid command. Please enter "A" or "R".');
    }
  }
  return true;
}

// ----------------------------
// 4. 命令解析器 (Command Parser)
// ----------------------------

String? parseMoveCommand(String input) {
  if (input.length < 3) return null;
  if (!input.startsWith('往')) return null;
  if (input.length < 2) return null;
  
  String directionChar = input[1];
  List<String> validDirections = ['北', '南', '东', '西', '出'];
  if (!validDirections.contains(directionChar)) return null;
  
  String endPattern = input.substring(2);
  if (endPattern == '走' || endPattern == '去') {
    return directionChar;
  }
  return null;
}

String? parseTakeCommand(String input) {
  if (input.startsWith('拿')) {
    return input.substring(1);
  } else if (input.startsWith('取')) {
    return input.substring(1);
  }
  return null;
}

void printHelp() {
  print('\n=== 可用命令 / Kěyòng mìnglìng ===');
  print('=== Available Commands ===\n');
  
  print('移动：往<方向>走 或 往<方向>去');
  print('Yídòng: wǎng <fāngxiàng> zǒu huò wǎng <fāngxiàng> qù');
  print('Move: wǎng <direction> zǒu or wǎng <direction> qù');
  print('方向：北、南、东、西、出');
  print('Fāngxiàng: běi, nán, dōng, xī, chū');
  print('Directions: north, south, east, west, out\n');
  
  print('拿取物品：拿<物品名> 或 取<物品名>');
  print('Náqǔ wùpǐn: ná <wùpǐn míng> huò qǔ <wùpǐn míng>');
  print('Take item: ná <item name> or qǔ <item name>\n');
  
  print('查看：看 或 查看');
  print('Chákàn: kàn huò chákàn');
  print('Look: kàn or chákàn\n');
  
  print('背包：背包 或 物品');
  print('Bēibāo: bēibāo huò wùpǐn');
  print('Inventory: bēibāo or wùpǐn\n');
  
  print('状态：状态');
  print('Zhuàngtài: zhuàngtài');
  print('Status: zhuàngtài\n');
  
  print('帮助：帮助 或 命令');
  print('Bāngzhù: bāngzhù huò mìnglìng');
  print('Help: bāngzhù or mìnglìng\n');
  
  print('退出：退出 或 结束');
  print('Tuìchū: tuìchū huò jiéshù');
  print('Quit: tuìchū or jiéshù');
}

void processCommand(String input, Player player) {
  String trimmed = input.trim();
  if (trimmed.isEmpty) return;
  
  Room currentRoom = world[player.currentRoomId]!;
  
  // 1. Movement commands
  String? direction = parseMoveCommand(trimmed);
  if (direction != null) {
    if (currentRoom.exits.containsKey(direction)) {
      String nextRoomId = currentRoom.exits[direction]!;
      player.currentRoomId = nextRoomId;
      Room newRoom = world[nextRoomId]!;
      newRoom.describe();
    } else {
      print('\n那个方向不能走。');
      print('Nàgè fāngxiàng bùnéng zǒu.');
      print('You cannot go that way.');
    }
    return;
  }
  
  // 2. Take commands
  String? itemName = parseTakeCommand(trimmed);
  if (itemName != null && itemName.isNotEmpty) {
    if (currentRoom.item != null && 
        currentRoom.item!.name == itemName) {
      if (currentRoom.monster != null) {
        print('\n${currentRoom.monster}还在，你无法拿走${currentRoom.item!.name}！');
        print('${currentRoom.monsterPinyin} hái zài, nǐ wúfǎ ná zǒu ${currentRoom.item!.namePinyin}！');
        print('The ${currentRoom.monsterEn()} is still here, you cannot take the ${currentRoom.item!.nameEn()}!');
      } else {
        player.addItem(currentRoom.item!);
        world[player.currentRoomId] = Room(
          id: currentRoom.id,
          name: currentRoom.name,
          namePinyin: currentRoom.namePinyin,
          description: currentRoom.description,
          descriptionPinyin: currentRoom.descriptionPinyin,
          descriptionEn: currentRoom.descriptionEn,
          exits: currentRoom.exits,
          item: null,
          monster: currentRoom.monster,
          monsterPinyin: currentRoom.monsterPinyin,
        );
      }
    } else {
      print('\n这里没有 "$itemName"。');
      print('Zhèlǐ méiyǒu "$itemName"。');
      print('There is no "$itemName" here.');
    }
    return;
  }
  
  // 3. Other commands
  if (trimmed == '看' || trimmed == '查看') {
    currentRoom.describe();
  }
  else if (trimmed == '背包' || trimmed == '物品') {
    player.showInventory();
  }
  else if (trimmed == '状态') {
    player.showStatus();
  }
  else if (trimmed == '帮助' || trimmed == '命令') {
    printHelp();
  }
  else if (trimmed == '退出' || trimmed == '结束') {
    print('\n感谢游玩！再见，冒险者。');
    print('Gǎnxiè yóuwán! Zàijiàn, màoxiǎn zhě.');
    print('Thanks for playing! Farewell, adventurer.');
    exit(0);
  }
  else {
    print('\n我不理解 "$trimmed"。输入 "帮助" 查看命令。');
    print('Wǒ bù lǐjiě "$trimmed"。Shūrù "bāngzhù" chákàn mìnglìng。');
    print('I don\'t understand "$trimmed". Type "帮助" for commands.');
  }
}

// ----------------------------
// 5. 主游戏 (Main Game)
// ----------------------------

void main() {
  print('=' * 60);
  print('黑暗洞穴 - 文字冒险游戏 / Hēi\'àn dòngxué');
  print('Hēi\'àn dòngxué - Wénzì màoxiǎn yóuxì');
  print('Dark Caverns - Text Adventure RPG');
  print('=' * 60);
  
  print('\n你是一位寻找传说中金杯的冒险者。');
  print('Nǐ shì yī wèi xúnzhǎo chuánshuō zhōng jīn bēi de màoxiǎn zhě.');
  print('You are an adventurer seeking the legendary Golden Chalice.');
  
  print('\n【重要】移动命令格式：往<方向>走 或 往<方向>去');
  print('【Zhòngyào】Yídòng mìnglìng géshì: wǎng <fāngxiàng> zǒu huò wǎng <fāngxiàng> qù');
  print('【Important】Movement format: wǎng <direction> zǒu or wǎng <direction> qù');
  print('例如："往北走" 或 "往东去"');
  print('Lìrú: "wǎng běi zǒu" huò "wǎng dōng qù"');
  print('Example: "wǎng běi zǒu" or "wǎng dōng qù"');
  
  print('\n输入 "帮助" 查看所有命令。');
  print('Shūrù "bāngzhù" chákàn suǒyǒu mìnglìng。');
  print('Type "帮助" to see all commands.\n');
  
  Player player = Player();
  
  world['entrance']!.describe();
  
  while (true) {
    if (player.hasItem('金杯')) {
      print('\n✨✨✨ 胜利！ Shènglì！ ✨✨✨');
      print('Nǐ chénggōng qǔdé le jīn bēi bìng táolí le hēi\'àn dòngxué.');
      print('You have successfully retrieved the Golden Chalice and escaped the dark caverns.');
      print('村民们欢呼着你的名字！恭喜你！');
      print('Cūnmínmen huānhū zhe nǐ de míngzì! Gōngxǐ nǐ!');
      print('The villagers cheer your name! Congratulations!');
      break;
    }
    
    if (player.health <= 0) {
      print('\n☠️ 游戏结束 / Yóuxì jiéshù ☠️');
      print('Nǐ de lǚchéng zài hēi\'àn zhōng zhōngjié.');
      print('Your journey ends here in the darkness.');
      break;
    }
    
    Room currentRoom = world[player.currentRoomId]!;
    if (currentRoom.monster != null) {
      String monster = currentRoom.monster!;
      bool defeated = fightMonster(monster, player);
      if (defeated) {
        world[player.currentRoomId] = Room(
          id: currentRoom.id,
          name: currentRoom.name,
          namePinyin: currentRoom.namePinyin,
          description: currentRoom.description,
          descriptionPinyin: currentRoom.descriptionPinyin,
          descriptionEn: currentRoom.descriptionEn,
          exits: currentRoom.exits,
          item: currentRoom.item,
          monster: null,
          monsterPinyin: null,
        );
        print('\n房间现在安全了。');
        print('Fángjiān xiànzài ānquán le.');
        print('The room is now safe.');
        
        currentRoom = world[player.currentRoomId]!;
        if (currentRoom.item != null) {
          print('\n怪物消失后，你注意到这里有一个${currentRoom.item!.name}。');
          print('Guàiwù xiāoshī hòu, nǐ zhùyì dào zhèlǐ yǒu yī gè ${currentRoom.item!.namePinyin}。');
          print('After the monster disappears, you notice a ${currentRoom.item!.nameEn()} here.');
        }
      } else {
        if (player.health > 0) {
          print('\n你撤退到了入口。');
          print('Nǐ chè tuì dào le rùkǒu.');
          print('You retreat to the entrance.');
          player.currentRoomId = 'entrance';
          world['entrance']!.describe();
        }
      }
      continue;
    }
    
    stdout.write('\n> ');
    String? input = stdin.readLineSync();
    if (input == null || input.isEmpty) continue;
    processCommand(input, player);
  }
}