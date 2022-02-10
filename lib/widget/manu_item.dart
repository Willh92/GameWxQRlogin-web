import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
import 'package:flutter/widgets.dart';
import 'package:qr_login/bean/menu.dart';

import '../common.dart';

@immutable
class MenuItem extends StatelessWidget {
  final Game game;

  MenuItem({
    Key? key,
    required this.game,
  }) : super(key: key) {
    game.icon = game.icon!
        .replaceAll("https://mmbiz.qpic.cn/", "$baseURL/mm/")
        .replaceAll("https://mmgame.qpic.cn/image/", "$baseURL/m/")
        .replaceAll("https://mmocgame.qpic.cn/wechatgame/", "$baseURL/w/");
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          child: game.py == "azsmxz"
              ? Image.asset(
                  "images/icon.png",
                  width: 60,
                  height: 60,
                )
              : CachedNetworkImage(
                  width: 60,
                  height: 60,
                  imageUrl: game.icon!,
                  placeholder: (context, url) => Image.asset(
                        "images/pic_default.png",
                        width: 60,
                        height: 60,
                      ),
                  errorWidget: (context, url, error) => Image.asset(
                        "images/pic_default.png",
                        width: 60,
                        height: 60,
                      ),
                  imageRenderMethodForWeb: ImageRenderMethodForWeb.HtmlImage),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6, left: 24, right: 24),
          child: Text(
            game.name! + "\n",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              height: 1.1,
              fontSize: 12,
            ),
          ),
        ),
      ],
    ));
  }
}
