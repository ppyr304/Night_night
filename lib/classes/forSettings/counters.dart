class Counters {
  //limit
  int maxVideos = 1;
  Duration maxDuration = const Duration(minutes: 30);
  //current video num
  int num = 0;

  Counters._instantiate();
  static final Counters instance = Counters._instantiate();

  void increment() {
    num++;
  }

  bool atLimit() {
    return (maxVideos == num);
  }
}
