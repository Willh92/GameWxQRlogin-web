import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:qr_login/common.dart';
import 'package:qr_login/web.dart';
import 'package:qr_login/widget/edit_widget.dart';
import 'package:qr_login/widget/manu_item.dart';
import 'package:url_launcher/url_launcher.dart';

import 'bean/menu.dart';

void main() async {
  await initMenu();
  setUrlStrategy(PathUrlStrategy());
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
                if (isWx()) {
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

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late List<Game> allGame;
  late List<Game> game;

  @override
  void initState() {
    super.initState();
    if (isAndroid()) {
      Future.delayed(Duration.zero, () {
        showAlertDialog(
            context,
            isWx()
                ? "由于安卓系统限制,需点击右上角在浏览器打开，下载扫码APP才能正常扫码登录"
                : "由于安卓系统限制,需下载扫码APP才能正常扫码登录");
      });
    }
    allGame = gameList.values.toList();
    if (!isIos()) {
      allGame.insert(0, Game(py: "azsmxz", name: "安卓扫码下载", icon: ""));
    }
    game = allGame.toList();
  }

  void _itemClick(Game game) {
    if (game.py == "azsmxz") {
      launch("https://dl.willh.cn/qrlogin.apk");
      return;
    }
    Navigator.pushNamed(context, "/game?g=${game.py}");
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) {
    //     return WebPage(game: game);
    //   }),
    // );
  }

  void _filter(String str) {
    List<Game> filter = allGame.where((g) {
      return g.py == "azsmxz" || g.name!.contains(str) || g.py!.contains(str);
    }).toList();
    setState(() {
      game = filter;
    });
  }

  showAlertDialog(BuildContext context, String msg) {
    //设置对话框
    AlertDialog alert = AlertDialog(
      title: const Text("温馨提示"),
      content: Text(msg),
      actions: const [],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    int crossAxisCount = (width / 120).truncate();
    return Scaffold(
        appBar: isWx()
            ? null
            : AppBar(
                title: Text(widget.title),
              ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: EditWidget(
                    onChanged: (str) {
                      _filter(str.toLowerCase());
                    },
                    hintText: "搜索游戏\"王者荣耀\"或\"wzry\"",
                    iconWidget: Icon(
                      Icons.search,
                      size: 24,
                      color: Theme.of(context).primaryColor,
                    )),
              ),
              Expanded(
                  child: CustomScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.only(top: 0, bottom: 12),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: 1.25,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          Game g = game[index];
                          return GestureDetector(
                            key: ValueKey(g.name),
                            onTap: () {
                              _itemClick(g);
                            },
                            child: MenuItem(game: g),
                          );
                        },
                        childCount: game.length,
                      ),
                    ),
                  )
                ],
              )),
            ],
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
          ),
        );
  }
}
