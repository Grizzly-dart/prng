import 'package:grizzly_prng/grizzly_prng.dart';

void main() {
  final lfsr32 = LFSR32.create(DateTime.now().millisecondsSinceEpoch);
  for(int i = 0; i < 100; i++) {
    print(lfsr32.next());
  }
}