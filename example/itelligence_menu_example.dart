import 'package:itelligence_menu/itelligence_menu.dart';

void main() async {
  final it = ItelligenceMenuClient();
  // Await the items in the stream
  final entries = await it.getMenuEntries().toList();
  // Or listen to the stream
  it.getMenuEntries().listen((entry) {
    // Handle the current entry
  });
}
