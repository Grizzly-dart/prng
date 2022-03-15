import 'dart:math';

import 'package:grizzly_prng/grizzly_prng.dart';
import 'package:ninja_hex/ninja_hex.dart';

void main() {
  final rnd = Random(345);
  final ctrDrbg = CRTDrbgAES128(('AE' * 32).decodeHex, entropySource: rnd);

  final clock = Stopwatch();
  clock.start();
  for(int i = 0; i < 1000000; i++) {
    int v = ctrDrbg.generateU32();
    // print(v);
  }
  clock.stop();
  print(clock.elapsed);
  print(1000000/clock.elapsed.inSeconds);
}