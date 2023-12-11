class Counters{
  int limit = 1;
  int curr = 0;

  Counters._instantiate();

  static final Counters instance = Counters._instantiate();

  Counters(this.limit, this.curr);

  void increment () {
    curr++;
  }

  bool atLimit () {
    return (limit == curr);
  }
}