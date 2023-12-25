class Counters {
  //limit
  int maxVideos = 1;
  Duration maxDuration = const Duration(minutes: 30);
  //current video num
  int curr = 0;

  //condition to save data
  bool toSave = false;
  //temporary data and data for saving
  int num = 0;
  Duration dur = const Duration();
  int h = 0;
  int m = 0;
  int s = 0;

  Counters._instantiate();
  static final Counters instance = Counters._instantiate();

  void increment() {
    curr++;
  }

  bool atLimit() {
    return (maxVideos == curr);
  }

  void clearTemp () {
    num = 0;
    dur = const Duration();
    h = 0;
    m = 0;
    s = 0;
  }
}
