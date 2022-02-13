import 'dart:html';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:qr_login/app/application.dart';
import 'package:qr_login/common.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wakelock/wakelock.dart';
import 'package:webviewx/webviewx.dart';

import '../../bean/menu.dart';
import '../../route/routes.dart';

class GamePage extends StatefulWidget {
  final String _userAgent =
      "Mozilla/5.0 (Linux; Android 7.0; Mi-4c Build/NRD90M; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/53.0.2785.49 Mobile MQQBrowser/6.2 TBS/043632 Safari/537.36 MicroMessenger/6.6.1.1220(0x26060135) NetType/WIFI Language/zh_CN MicroMessenger/6.6.1.1220(0x26060135) NetType/WIFI Language/zh_CN miniProgram";

  final Game? game;
  String? url;

  GamePage({
    Key? key,
    this.game,
  }) : super(key: key) {
    if (game != null) {
      url =
          "$baseURL/q/connect/app/qrconnect?appid=${game!.appId!}&bundleid=${game!.bundleId!}"
          "&scope=snsapi_base,snsapi_userinfo,snsapi_friend,snsapi_message&state=weixin";
    }
  }

  @override
  State<StatefulWidget> createState() {
    return _WebViewState();
  }
}

class _WebViewState extends State<GamePage> {
  final Dio _dio = Dio();

  late WebViewXController webviewController;

  late Future<Response<String>> _myData;

  bool _loadSuccess = false;

  @override
  void initState() {
    super.initState();
    if (widget.game == null) {
      Future.delayed(Duration.zero, () {
        Application.router.navigateTo(context, Routes.home,
            clearStack: true, transition: TransitionType.none);
      });
    } else {
      Future.delayed(Duration.zero, () {
        Wakelock.enable();
      });
    }
    _myData = _dio.get(widget.url ?? "");
    _loadSuccess = false;
  }

  @override
  void dispose() {
    Wakelock.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: _loadSuccess
            ? WebViewAware(
                child: FloatingActionButton(
                    child: const Icon(Icons.refresh),
                    tooltip: "刷新",
                    onPressed: () {
                      _reload();
                    }),
              )
            : null,
        appBar: AppBar(
          title: Text(widget.game?.name ?? ""),
        ),
        body: widget.url == null
            ? const Text("游戏不存在")
            : FutureBuilder(
                future: _myData,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  final size = MediaQuery.of(context).size;
                  final width = size.width;
                  final height = size.height;
                  //请求完成
                  if (snapshot.connectionState == ConnectionState.done) {
                    //发生错误
                    if (snapshot.hasError) {
                      print(snapshot.error.toString());
                      Future.delayed(Duration.zero, () {
                        setState(() {
                          _loadSuccess = true;
                        });
                      });
                      return const Text("加载失败");
                    }
                    //请求成功
                    if (!_loadSuccess) {
                      Future.delayed(Duration.zero, () {
                        setState(() {
                          _loadSuccess = true;
                        });
                      });
                    }
                    return WebViewX(
                        initialContent: _modifyHtml(snapshot.data.toString()),
                        initialSourceType: SourceType.html,
                        onWebViewCreated: (controller) =>
                            webviewController = controller,
                        jsContent: const {
                          EmbeddedJsContent(
                            webJs: "function postMsg(msg) { Callback(msg) }",
                            mobileJs:
                                "function postMsg(msg) { Callback.postMessage(msg) }",
                          ),
                        },
                        dartCallBacks: {
                          DartCallback(
                              name: 'Callback',
                              callBack: (msg) {
                                Uri? uri = Uri.tryParse(msg.trimLeft());
                                if (uri != null) {
                                  switch (uri.authority) {
                                    case "oauth":
                                      String? code =
                                          uri.queryParameters["code"];
                                      launch(
                                          "${uri.scheme}://${uri.authority}?code=$code",
                                          forceSafariVC: false,
                                          webOnlyWindowName: "_self");
                                      break;
                                    case "refresh":
                                      _reload();
                                      break;
                                    default:
                                      break;
                                  }
                                }
                              })
                        },
                        width: width,
                        height: height,
                        javascriptMode: JavascriptMode.unrestricted);
                  }
                  return const Center(child: CircularProgressIndicator());
                }));
  }

  String _modifyHtml(String data) {
    data = data
        .replaceAll("https://mmbiz.qpic.cn/", "$baseURL/mm/")
        .replaceAll("https://mmgame.qpic.cn/image/", "$baseURL/m/")
        .replaceAll("https://mmocgame.qpic.cn/wechatgame/", "$baseURL/w/")
        .replaceAll(
            "https://res.wx.qq.com/connect/zh_CN/htmledition/js/padauth.js",
            "$baseURL/js/padauth.js");
    return data;
  }

  void _reload() {
    setState(() {
      _loadSuccess = false;
      _myData = _dio.get(widget.url!);
    });
  }
}
