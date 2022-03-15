import 'dart:math';
import 'dart:typed_data';

import 'package:ninja/ninja.dart';

class CRTDrbgAES128 {
  Random _entropySource;

  Uint8List _k = Uint8List(keyLenBytes);
  Uint8List _v = Uint8List(blockLenBytes);
  int _reseedCounter = 1;

  CRTDrbgAES128(Uint8List personalization, {Random? entropySource})
      : _entropySource = entropySource ?? Random.secure() {
    if (personalization.length != seedLenBytes) {
      throw ArgumentError(
          'should be exactly seedlen (32) bytes long', 'personalization');
    }
    // TODO initialize
    final entropyInput = Uint8List.fromList(
        List.generate(seedLenBytes, (index) => _entropySource.nextInt(256)));

    final seedMaterial = Uint8List.fromList(List.generate(
        seedLenBytes, (i) => personalization[i] ^ entropyInput[i]));

    _update(seedMaterial);
  }

  void _update(Uint8List seedMaterial) {
    if (seedMaterial.length != seedLenBytes) {
      throw ArgumentError(
          'should be exactly seedlen (32) bytes long', 'seedMaterial');
    }

    BigInt v = _v.asBigInt();

    final temp = <int>[];

    while (temp.length < seedLenBytes) {
      v = (v + BigInt.one) % twoPowBlockLen;
      final block = Uint8List(16);
      AESFastEncryptionEngine(_k).processBlock(
          v.asBytes(outLen: blockLenBytes).buffer.asByteData(),
          block.buffer.asByteData());
      temp.addAll(block);
    }

    temp.removeRange(seedLenBytes, temp.length);
    for (int i = 0; i < seedLenBytes; i++) {
      temp[i] ^= seedMaterial[i];
    }

    for (int i = 0; i < keyLenBytes; i++) {
      _k[i] = temp[i];
    }
    for (int i = 0; i < blockLenBytes; i++) {
      _v[i] = temp[i + keyLenBytes];
    }
  }

  int generateU32({Uint8List? additionalEntropy}) {
    return generateBytes(4, additionalEntropy: additionalEntropy).asBigInt().toInt();
  }

  Uint8List generateBytes(int byteLen, {Uint8List? additionalEntropy}) {
    if(_reseedCounter > reseedInterval) {
      // TODO reseed
    }

    if(additionalEntropy != null) {
      if(additionalEntropy.length != seedLenBytes) {
        throw ArgumentError('', 'additionalEntropy');
      }
      _update(additionalEntropy);
      throw UnimplementedError();
    } else {
      additionalEntropy = Uint8List(seedLenBytes);
    }

    BigInt v = _v.asBigInt();

    final temp = <int>[];
    while(temp.length < byteLen) {
      v = (v + BigInt.one) % twoPowBlockLen;
      final block = Uint8List(16);
      AESFastEncryptionEngine(_k).processBlock(
          v.asBytes(outLen: blockLenBytes).buffer.asByteData(),
          block.buffer.asByteData());
      temp.addAll(block);
    }

    temp.removeRange(byteLen, temp.length);
    _update(additionalEntropy);
    _reseedCounter++;

    return Uint8List.fromList(temp);
  }

  // TODO reseed

  static const seedLenBits = 256;
  static const seedLenBytes = 32;
  static const keyLenBytes = 16;
  static const blockLenBits = 128;
  static const blockLenBytes = 16;
  static final twoPowBlockLen = BigInt.one << blockLenBits;
  static const reseedInterval = 1 << 48;
}
