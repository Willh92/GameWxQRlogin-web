class Menu {
  int? version;
  List<String>? helpList;
  List<Game>? game;

  Menu({this.version, this.helpList, this.game});

  Menu.fromJson(Map<String, dynamic> json) {
    version = json['version'];
    helpList = json['helpList'].cast<String>();
    if (json['game'] != null) {
      game = <Game>[];
      json['game'].forEach((v) {
        game!.add(new Game.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['version'] = this.version;
    data['helpList'] = this.helpList;
    if (this.game != null) {
      data['game'] = this.game!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Game {
  String? name;
  String? py;
  String? appId;
  String? bundleId;
  String? pkg;
  String? cls;
  String? help;
  String? icon;
  int? helpIndex;

  Game(
      {this.name,
        this.py,
        this.appId,
        this.bundleId,
        this.pkg,
        this.cls,
        this.help,
        this.icon,
        this.helpIndex});

  Game.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    py = json['py'];
    appId = json['appId'];
    bundleId = json['bundleId'];
    pkg = json['pkg'];
    cls = json['cls'];
    help = json['help'];
    icon = json['icon'];
    helpIndex = json['helpIndex'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['py'] = this.py;
    data['appId'] = this.appId;
    data['bundleId'] = this.bundleId;
    data['pkg'] = this.pkg;
    data['cls'] = this.cls;
    data['help'] = this.help;
    data['icon'] = this.icon;
    data['helpIndex'] = this.helpIndex;
    return data;
  }
}