import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:qr_login/constant.dart';
import 'package:qr_login/web.dart';
import 'package:qr_login/widget/manu_item.dart';
import 'package:url_launcher/url_launcher.dart';

import 'bean/menu.dart';

void main() async {
  await initMenu();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '扫码登录',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      initialRoute: "/",
      onGenerateRoute: (settings) {
        final settingsUri = Uri.parse(settings.name!);
        switch (settingsUri.path) {
          case "/game":
            String? g = settingsUri.queryParameters["g"];
            if (g != null) {
              Game? game = gameList[g];
              if (game != null) {
                if (isWeChatBrowser()) {
                  launch(
                      "https://open.weixin.qq.com/connect/app/qrconnect?appid=${game.appId!}&bundleid=${game.bundleId!}&scope=snsapi_base,snsapi_userinfo,snsapi_friend,snsapi_message&state=weixin",
                      forceSafariVC: false,
                      webOnlyWindowName: "_self");
                  return null;
                }
                return MaterialPageRoute(
                    builder: (context) => WebPage(
                          game: game,
                        ),
                    settings: settings);
              }
            }
            return null;
          default:
        }
        return MaterialPageRoute(
            builder: (context) => const MyHomePage(title: '扫码登录'),
            settings: settings);
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // final Dio _dio = Dio();

  void _itemClick(Game game) {
    Navigator.pushNamed(context, "/game?g=${game.py}");
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) {
    //     return WebPage(game: game);
    //   }),
    // );
  }

  @override
  Widget build(BuildContext context) {
    List<Game> game = gameList.values.toList();
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: (width / 120).truncate(),
          childAspectRatio: 1.0,
        ),
        itemCount: game.length,
        itemBuilder: (context, index) {
          Game g = game.elementAt(index);
          return GestureDetector(
            onTap: () {
              _itemClick(g);
            },
            child: MenuItem(game: g),
          );
        },
      ),
      // body: FutureBuilder(
      //     future: _dio.get(
      //         "https://qr.willh.cn/graw/Willh92/GameWxQRlogin/main/games/gameList2-min.json"),
      //     builder: (BuildContext context, AsyncSnapshot snapshot) {
      //       //请求完成
      //       if (snapshot.connectionState == ConnectionState.done) {
      //         //发生错误
      //         if (snapshot.hasError) {
      //           return Text(snapshot.error.toString());
      //         }
      //         //请求成功
      //         List<Game> game =
      //             Menu.fromJson(jsonDecode(snapshot.data.toString())).game!;
      //         return GridView.builder(
      //           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      //             crossAxisCount: 3, //每行三列
      //             childAspectRatio: 1.0,
      //           ),
      //           itemCount: game.length,
      //           itemBuilder: (context, index) {
      //             Game g = game.elementAt(index);
      //             return GestureDetector(
      //               onTap: () {
      //                 _itemClick(g);
      //               },
      //               child: MenuItem(game: g),
      //             );
      //           },
      //         );
      //       }
      //       //请求未完成时弹出loading
      //       return const Center(child: CircularProgressIndicator());
      //     }),
    );
  }
}
