import 'dart:collection';
import 'dart:convert';
import 'dart:html';

import 'package:dio/dio.dart';

import 'bean/menu.dart';

LinkedHashMap<String, Game> gameList = LinkedHashMap();

final Dio _dio = Dio();

Future initMenu() async {
  return Future(() async {
    gameList.clear();
    Response response = await _dio.get(
        "https://qr.willh.cn/graw/Willh92/GameWxQRlogin/main/games/gameList2-min.json");
    if (response.statusCode == 200) {
      for (var element
          in Menu.fromJson(jsonDecode(response.data.toString())).game!) {
        gameList[element.py!] = element;
      }
    }
  });
}

bool isWeChatBrowser() {
  final ua = window.navigator.userAgent.toLowerCase();
  return ua.indexOf('micromessenger') != -1;
}
