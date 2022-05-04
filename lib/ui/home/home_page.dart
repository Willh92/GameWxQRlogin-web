import 'package:flutter/material.dart';
import 'package:qr_login/common.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/application.dart';
import '../../bean/menu.dart';
import '../../route/routes.dart';
import '../../utils/formatter/TextInputFormatter.dart';
import '../../widget/edit_widget.dart';
import '../../widget/manu_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    allGame.insert(0, Game(py: "grlxz", name: "解除人脸限制", icon: ""));
    if (!isIos()) {
      allGame.insert(0, Game(py: "azsmxz", name: "安卓扫码下载", icon: ""));
    }
    game = allGame.toList();
  }

  void _itemClick(Game game) {
    if (game.py == "azsmxz") {
      launch("https://dl.willh.cn/qrlogin.apk");
      return;
    } else if (game.py == "grlxz") {
      if (isWx()) {
        launch(
            "https://jiazhang.qq.com/healthy/dist/faceRecognition/recognition.html?from=openlink&isNew=1&hA=&hasLogin=true",
            forceSafariVC: false,
            webOnlyWindowName: "_self");
      } else {
        Navigator.pushNamed(context, Routes.identity);
      }
      return;
    }
    if (isWx()) {
      launch(
          "https://open.weixin.qq.com/connect/app/qrconnect?appid=${game.appId!}&bundleid=${game.bundleId!}&scope=snsapi_base,snsapi_userinfo,snsapi_friend,snsapi_message&state=weixin",
          forceSafariVC: false,
          webOnlyWindowName: "_self");
      return;
    }
    Navigator.pushNamed(context, "/game?name=${game.py}");
  }

  void _filter(String str) async {
    List<Game> filter = allGame.where((g) {
      return g.name!.contains(str) ||
          g.py!.contains(str) ||
          g.py == "azsmxz" ||
          g.py == "grlxz";
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
                hintText: "搜索王者荣耀(wzry)",
                inputFormatters: [
                  LengthTextInputFormatter(100),
                  FilterTextInputFormatter(
                    filterPattern: RegExp("[a-zA-Z]|[\u4e00-\u9fa5]|[0-9]|'"),
                  ),
                ],
                iconWidget: Icon(
                  Icons.search,
                  size: 24,
                  color: Theme.of(context).primaryColor,
                )),
          ),
          Expanded(
              child: CustomScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
