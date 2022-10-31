class LCG {
  final int a;

  final int c;

  final int m;

  int _state;

  LCG({required this.a, required this.c, required this.m, required int seed})
      : _state = seed % m;

  int next() {
    int nextState = (a * _state + c) % m;
    _state = nextState;
    return _state;
  }
}

class LCGMapping {
  final int a;
  final int c;
  final int m;

  LCGMapping(this.a, this.c, this.m);

  int transform(int i) => (i * a + c) % m;
}