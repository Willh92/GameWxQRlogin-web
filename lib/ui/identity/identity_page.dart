import 'package:flutter/material.dart';
import 'package:wakelock/wakelock.dart';

class IdentityPage extends StatefulWidget {
  const IdentityPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _IdentityViewState();
  }
}

class _IdentityViewState extends State<IdentityPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Wakelock.enable();
    });
  }

  @override
  void dispose() {
    Wakelock.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final qrSize = (size.width >= 500 ? 400 : size.width * 0.7).toDouble();
    return Scaffold(
      appBar: AppBar(
        title: const Text("解除人脸限制"),
      ),
      body: Column(
        children: [
          const Padding(
              padding: EdgeInsets.all(40),
              child: Text(
                "扫码登录过程中，出现人脸验证情况，将下方二维码截图发给号主，让号主使用微信识别二维码后，手动进行人脸验证。验证完成后，重新生成游戏二维码让号主扫码登录",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                ),
              )),
          Image.asset(
            "images/identity_qr.png",
            height: qrSize,
            width: qrSize,
          ),
        ],
      ),
    );
  }
}
