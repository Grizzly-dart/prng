import 'dart:typed_data';

import 'package:ninja/ninja.dart';

class CRTDrbg {
  Uint8List _seed;
  final _aes = AESKey(keyBytes);

  CRTDrbg(this._seed);
}