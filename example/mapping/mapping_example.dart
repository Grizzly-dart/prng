import 'package:grizzly_prng/grizzly_prng.dart';

void main() {
  final mapping = RandomMapping(13453);
  final set = <int>{};
  for (int i = 0; i < mapping.max; i++) {
    final image = mapping.transform(i);
    print('$i => $image ${set.contains(image)?'repeat':''}');
    set.add(image);
  }
}
