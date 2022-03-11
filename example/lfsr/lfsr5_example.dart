import 'package:grizzly_prng/grizzly_prng.dart';

void main() {
  final lfsr5 = LFSR5.create(0xa);
  for(int i = 0; i < 100; i++) {
    print(lfsr5.next());
  }
}