import 'dart:math';

abstract class RandomStringGenerator {
  String generateAlphanumeric(int len);
}

class RandomStringGeneratorImpl implements RandomStringGenerator {
  @override
  String generateAlphanumeric(int len) {
    var r = Random();
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
  }
}
