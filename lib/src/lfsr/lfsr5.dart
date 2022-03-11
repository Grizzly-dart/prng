class LFSR5 {
  int _state;
  int _seed;

  LFSR5._(this._state, this._seed);

  factory LFSR5.create(int seed) {
    seed = mask5(seed);
    return LFSR5._(seed, seed);
  }

  int next() {
    int s = _state;
    int bit = ((s >> 0) ^ (s >> 2)) & 0x01;
    _state = mask5((_state >> 1) | (bit << 4));
    return _state;
  }
}

int mask5(int input) => input & 0x1F;
