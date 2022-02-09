import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:qr_login/common.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webviewx/webviewx.dart';

import 'bean/menu.dart';

class WebPage extends StatefulWidget {
  final String _userAgent =
      "Mozilla/5.0 (Linux; Android 7.0; Mi-4c Build/NRD90M; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/53.0.2785.49 Mobile MQQBrowser/6.2 TBS/043632 Safari/537.36 MicroMessenger/6.6.1.1220(0x26060135) NetType/WIFI Language/zh_CN MicroMessenger/6.6.1.1220(0x26060135) NetType/WIFI Language/zh_CN miniProgram";

  final Game? game;
  final String url;

  WebPage({
    Key? key,
    this.game,
  })  : url = "$baseURL/q/connect/app/qrconnect?appid=${game!.appId!}&bundleid=${game.bundleId!}"
            "&scope=snsapi_base,snsapi_userinfo,snsapi_friend,snsapi_message&state=weixin",
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _WebViewState();
  }
}

class _WebViewState extends State<WebPage> {
  final Dio _dio = Dio();

  late WebViewXController webviewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.game!.name!),
        ),
        body: FutureBuilder(
            future: _dio.get(widget.url),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              final size = MediaQuery.of(context).size;
              final width = size.width;
              final height = size.height;
              //请求完成
              if (snapshot.connectionState == ConnectionState.done) {
                //发生错误
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                //请求成功
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
                              if ("oauth" == uri.authority) {
                                String? code = uri.queryParameters["code"];
                                launch(
                                    "${uri.scheme}://${uri.authority}?code=$code",
                                    forceSafariVC: false,
                                    webOnlyWindowName: "_self");
                              }
                            }
                          })
                    },
                    width: width,
                    height: height,
                    javascriptMode: JavascriptMode.unrestricted);
              }
              //请求未完成时弹出loading
              return const Center(child: CircularProgressIndicator());
            }));
  }
}

String _modifyHtml(String data) {
  data = data
      .replaceAll(
          "https://mmocgame.qpic.cn/wechatgame/", "$baseURL/w/")
      .replaceAll(
          "https://res.wx.qq.com/connect/zh_CN/htmledition/js/padauth.js",
          "$baseURL/js/padauth.js");
  return data;
}
