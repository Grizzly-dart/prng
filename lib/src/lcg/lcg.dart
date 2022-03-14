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
