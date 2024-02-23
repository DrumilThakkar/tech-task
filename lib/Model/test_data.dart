// ignore_for_file: public_member_api_docs, sort_constructors_first
class TestData {
  List<Test> test;
  TestData({
    required this.test,
  });
}

class Test {
  String action;
  String source;
  String destination;
  int volume;
  String duration;
  String input;
  int repetitions;
  bool isValidTest;
  Test({
    required this.action,
    required this.source,
    required this.destination,
    required this.volume,
    required this.duration,
    required this.input,
    required this.repetitions,
    this.isValidTest = true,
  });
}
