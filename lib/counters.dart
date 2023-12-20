class Counters{
  int limit = 1;
  int num = 0;
  DateTime dateTime = DateTime.now();

  Counters._instantiate();

  static final Counters instance = Counters._instantiate();

  Counters(this.limit);

  void increment () {
    num++;
  }

  bool atLimit () {
    return (limit == num);
  }
}