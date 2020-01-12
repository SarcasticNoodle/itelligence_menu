import 'package:dio/dio.dart';
import 'package:itelligence_menu/src/models/menu_entry.dart';
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart';

class ItelligenceMenuClient {
  final Dio _client = Dio();

  Stream<MenuEntry> getMenuEntries() async* {
    var response = await _client.get<String>('https://speiseplan.app.itelligence.org/', options: Options(responseType: ResponseType.plain));
    var data = parser.parse(response.data);
    var tables = data.querySelectorAll('#tabelle > table')..removeAt(0);
    for (var table in tables) {
      yield _getEntryFromTable(table);
    }
  }

  MenuEntry _getEntryFromTable(Element element) {
    // Make the date parseable
    var date = element.querySelector('b').text.replaceAll(RegExp(r'[^0-9]'), '').replaceAll('.', '').reversed;
    for (var i = 0; i < date.length; i+=2) {
      date = date.swapChars(i, i+1);
    }

    var selections = element.querySelectorAll('tr').map((e) => e.children.last.text.replaceAll('\n', '')).toList();
    var supplements = element.querySelectorAll('tr > td.essen').last.innerHtml.split('<br>').map((s) => s.replaceAll('\n', '')).toList();

    return MenuEntry(date: DateTime.parse(date), selectionOne: selections.first, campaignMeal: selections[1], selectionTwo: selections[2], supplements: supplements);
  }
}

extension on String {
  String swapChars(int first, int last) {
    var firstChar = this[first];
    var lastChar = this[last];
    var firstPart = substring(0, first) + lastChar;
    var secondPart = substring(first + 1, last) + firstChar;
    var lastPart = substring(last + 1);
    return firstPart + secondPart + lastPart;
  }

  String get reversed {
    var s = StringBuffer();
    for (var i = length - 1; i >= 0; i--) {
      s.write(this[i]);
    }
    return s.toString();
  }
}