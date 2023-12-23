class Counters{
  //limit
  int maxVideos = 1;
  Duration maxDuration = const Duration(minutes: 30);
  //current
  int num = 0;
  //by videos or duration
  bool byVideos = true;

  Counters._instantiate();
  static final Counters instance = Counters._instantiate();

  void increment () {
    num++;
  }

  bool atLimit () {
    return (maxVideos == num);
  }
}