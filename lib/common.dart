import 'dart:collection';
import 'dart:convert';
import 'dart:html';

import 'package:dio/dio.dart';

import 'bean/menu.dart';

const baseURL = "https://q.willh.cn";

LinkedHashMap<String, Game> gameList = LinkedHashMap();

final Dio _dio = Dio();

Future initMenu() async {
  return Future(() async {
    gameList.clear();
    Response response = await _dio.get("$baseURL/graw/Willh92/GameWxQRlogin/main/games/gameList2-min.json");
    if (response.statusCode == 200)
    {
      for (var element
      in Menu
          .fromJson(jsonDecode(response.data.toString()))
          .game!) {
        gameList[element.py!] = element;
      }
    }
  });
}

bool isWx() {
  final ua = window.navigator.userAgent.toLowerCase();
  return ua.contains('micromessenger');
}

bool isAndroid() {
  final ua = window.navigator.userAgent.toLowerCase();
  return ua.contains('android') || ua.contains('linux');
}

bool isIos() {
  final ua = window.navigator.userAgent.toLowerCase();
  return ua.contains('iphone') || ua.contains('ipad') || ua.contains('ipod');
}

