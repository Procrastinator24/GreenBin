import 'package:flutter/material.dart';

extension HexColor on Colors {
  /// Строка может иметь формат "aabbcc" или "ffaabbcc" с необязательным префиксом "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Флаг leadingHashSign, отвечающий за наличие знака решетки в начале по умолчанию равен `true`.

}