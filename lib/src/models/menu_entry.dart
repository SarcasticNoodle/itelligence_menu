import 'package:html/dom.dart';
import 'package:intl/intl.dart';

import '../string.dart';

/// An entry for the menu
class MenuEntry {
  final Element _root;

  /// The day for for the available menu
  DateTime get date {
    var rawDate = _root.querySelector('b').text.split(' ').last;
    return DateFormat('dd.MM.yyyy').parse(rawDate);
  }

  Iterable<String> get _selections => _root
      .querySelectorAll('tr > td:not(.menue)')
      .map((e) => e.innerHtml.trim());

  /// The first meal
  ///
  /// Its always a vegetarian menu
  String get selectionOne => _selections.first.nullIfWhiteSpace;

  /// The advertised meal
  String get campaignMeal => _selections.elementAt(1).nullIfWhiteSpace;

  /// The second meal
  String get selectionTwo => _selections.elementAt(2).nullIfWhiteSpace;

  /// The possible supplements
  ///
  /// This can be e.g. salad or fries
  Iterable<String> get supplements => _selections.last.split('<br>');

  ///
  MenuEntry(this._root);
}
