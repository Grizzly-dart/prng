import 'dart:math';
import 'package:grizzly_prng/src/lcg/lcg.dart';
import 'package:ninja_prime/ninja_prime.dart';

abstract class RandomMapping {
  factory RandomMapping(m) => LCGRandomMapping.make(m);
  int get max;
  int transform(int i);
}

class LCGRandomMapping implements RandomMapping {
  final int a;
  final int c;
  final int m;

  LCGRandomMapping(this.a, this.c, this.m);

  @override
  int get max => m;

  factory LCGRandomMapping.make(int m, {Random? random}) {
    random ??= Random();
    int c = random.nextInt(m);

    final primes = m.primeFactors;

    int a = random.nextInt(1 << 32);
    do {
      for (final p in primes) {
        if (a % p == 0) {
          a = a ~/ p;
        }
      }
    } while (a == 1);

    print('$a $c $m');

    return LCGRandomMapping(a, c, m);
  }

  int transform(int i) => (i * a + c) % m;
}
