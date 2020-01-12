import 'package:test/test.dart';
import 'package:itelligence_menu/src/extensions.dart';

void main() {
  group('String extension tests', () {
    test('SwapChar test', () {
      var toSwap = 'Test String to Swap Chars';
      expect(toSwap.swapChars(0, toSwap.length - 1), 'sest String to Swap CharT');
    });

    test('Reversed test', () {
      var toReverse = 'test_string';
      expect(toReverse.reversed, 'gnirts_tset');
    });

    
  });
}
