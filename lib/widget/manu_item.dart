import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
import 'package:flutter/widgets.dart';
import 'package:qr_login/bean/menu.dart';

@immutable
class MenuItem extends StatelessWidget {
  final Game game;

  MenuItem({
    Key? key,
    required this.game,
  }) : super(key: key) {
    game.icon = game.icon!.replaceAll(
        "https://mmbiz.qpic.cn/", "https://qr.willh.cn/mm/");
    game.icon = game.icon!
        .replaceAll("https://mmgame.qpic.cn/image/", "https://qr.willh.cn/m/");
    game.icon = game.icon!.replaceAll(
        "https://mmocgame.qpic.cn/wechatgame/", "https://qr.willh.cn/w/");
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius:const BorderRadius.all(Radius.circular(12)),
          child:CachedNetworkImage(
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
        Text(game.name!)
      ],
    ));
  }
}
