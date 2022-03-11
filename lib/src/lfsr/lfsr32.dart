class LFSR32 {
  int _state;
  int _seed;

  LFSR32._(this._state, this._seed);

  factory LFSR32.create(int seed) {
    seed = mask32(seed);
    return LFSR32._(seed, seed);
  }

  int next() {
    int s = _state;
    int bit = ((s >> 0) ^ (s >> 2) ^ (s >> 6) ^ (s >> 7)) & 0x01;
    _state = mask32((_state >> 1) | (bit << 31));
    return _state;
  }
}

int mask32(int input) => input & 0xFFFFFFFF;
