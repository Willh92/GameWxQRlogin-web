import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditWidget extends StatefulWidget {
  ///输入框文字改变
  final ValueChanged<String>? onChanged;

  ///提示文字
  String hintText = "";

  ///图标Widget
  Widget? iconWidget;

  ///图标Widget
  bool passwordType = false;

  List<TextInputFormatter>? inputFormatters;

  EditWidget({
    Key? key,
    this.onChanged,
    this.hintText = "",
    this.passwordType = false,
    this.iconWidget,
    this.inputFormatters,
  }) : super(key: key);

  @override
  State<EditWidget> createState() => _EditWidgetState();
}

class _EditWidgetState extends State<EditWidget> {
  bool showPassWord = false;
  bool eyeExpand = true;

  String input = '';
  TextEditingController mController = TextEditingController();

  @override
  void dispose() {
    mController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.centerStart,
      children: [
        Container(
          width: double.infinity,
          height: 40,
          alignment: AlignmentDirectional.center,
          child: TextFormField(
            controller: mController,
            keyboardType: TextInputType.visiblePassword,
            textAlign: TextAlign.left,
            autofocus: false,
            maxLines: 1,
            minLines: 1,
            style: const TextStyle(
                height: 1, fontSize: 14, overflow: TextOverflow.ellipsis),
            obscureText: eyeExpand && widget.passwordType,
            onChanged: (text) {
              if (widget.onChanged != null) {
                widget.onChanged!(text);
              }
              setState(() {
                showPassWord = text.isNotEmpty;
                input = text;
              });
            },
            inputFormatters: widget.inputFormatters,

            ///样式
            decoration: InputDecoration(
                fillColor: Colors.transparent,
                filled: true,
                hintText: widget.hintText,
                hintStyle: TextStyle(
                    height: 1,
                    fontSize: 14,
                    color: Colors.grey[400],
                    overflow: TextOverflow.ellipsis),
                border: _getEditBorder(false),
                focusedBorder: _getEditBorder(true),
                disabledBorder: _getEditBorder(false),
                enabledBorder: _getEditBorder(false),
                contentPadding: const EdgeInsets.only(
                    top: 0, bottom: 0, left: 60, right: 60)),
          ),
          margin: const EdgeInsets.only(top: 8, bottom: 8, left: 25, right: 25),
        ),
        if (widget.iconWidget != null)
          Positioned(
            width: 36,
            height: 36,
            left: 36,
            child: widget.iconWidget!,
          ),
        Positioned(
          left: 76,
          child: Container(
            width: 1,
            height: 18,
            color: Colors.white54,
          ),
        ),
        Positioned(
          right: 40,
          child: Visibility(
            visible: showPassWord && widget.passwordType,
            child: IconButton(
              icon: Icon(
                eyeExpand ? Icons.remove_red_eye : Icons.visibility_off,
                size: 24,
                color: Colors.green,
              ),
              onPressed: () {
                setState(() {
                  eyeExpand = !eyeExpand;
                });
              },
            ),
          ),
        ),
        Positioned(
            right: 30,
            child: GestureDetector(
                onTap: () {
                  if (widget.onChanged != null) {
                    widget.onChanged!('');
                  }
                  setState(() {
                    input = '';
                    mController.clear(); //清除textfield的值
                  });
                },
                child: Visibility(
                  visible: input.isNotEmpty,
                  child: SizedBox(
                    width: 45,
                    height: 45,
                    child: Icon(
                      Icons.cancel,
                      color: Colors.grey[400],
                      size: 17,
                    ),
                  ),
                ))),
      ],
    );
  }

  ///获取输入框的Border属性，可公用
  ///[isEdit]是否获取焦点
  OutlineInputBorder _getEditBorder(bool isEdit) {
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(
        color: isEdit ? Colors.blue : Colors.blue,
        width: 1,
      ),
    );
  }
}
