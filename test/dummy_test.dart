import 'package:test/test.dart';

void main() {
  group('Dummy Test', () {
    test('Always Passes 1', () {
      // This test always passes
      expect(1, equals(1));
    });

    test('Always Passes 2', () {
      // This test always passes
      expect(true, isTrue);
    });

    // test('Always Fails', () {
    //   // This test always fails
    //   expect(1, equals(2));
    // });
  });
}