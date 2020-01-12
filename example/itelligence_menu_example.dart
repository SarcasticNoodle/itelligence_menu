import 'package:itelligence_menu/itelligence_menu.dart';

void main() {
  var it = ItelligenceMenuClient();
  it.getMenuEntries().listen(print);
}
