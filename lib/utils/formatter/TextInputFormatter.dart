import 'package:flutter/services.dart';

/// 自定义兼容中文拼音输入法长度限制输入框
class LengthTextInputFormatter extends TextInputFormatter {
  final int maxLength;

  LengthTextInputFormatter(this.maxLength);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    if (newValue.isComposingRangeValid) return newValue;
    return LengthLimitingTextInputFormatter(maxLength)
        .formatEditUpdate(oldValue, newValue);
  }
}

/// 自定义兼容中文拼音输入法正则校验输入框
class FilterTextInputFormatter extends TextInputFormatter {
  final Pattern filterPattern;

  FilterTextInputFormatter({required this.filterPattern});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    if (newValue.isComposingRangeValid) return newValue;
    return FilteringTextInputFormatter.allow(filterPattern)
        .formatEditUpdate(oldValue, newValue);
  }
}