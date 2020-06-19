import 'dart:io';

import 'package:dio/dio.dart';
import 'package:html/dom.dart';
import 'package:meta/meta.dart';

import '../itelligence_menu.dart';
import 'exceptions/invalid_status_code_exception.dart';
import 'models/menu_entry.dart';

//TODO: Add ö as offending char
const _offendingChars = {'Ã¼': 'ü', 'Ã¤': 'ä'};

/// Scraper to get the data from
class ItelligenceMenuClient {
  Dio _client = Dio();
  List<MenuEntry> _lastResponse;
  String _eTag;

  /// Initialize with a standard http client
  ItelligenceMenuClient();

  /// Testing interface
  @visibleForTesting
  ItelligenceMenuClient.private(Dio client) {
    _client = client;
  }

  /// Replace all wrong decoded chars with utf8 characters
  String _cleanUpResponse(String response) {
    _offendingChars.forEach((key, value) {
      response = response.replaceAll(key, value);
    });
    return response;
  }

  Map<String, String> get _cacheHeader {
    if (_eTag != null) {
      return {HttpHeaders.ifNoneMatchHeader: _eTag};
    }
    return {};
  }

  void _setETag(Headers headers) {
    _eTag = headers.value(HttpHeaders.etagHeader);
  }

  /// Get the latest menu from the website
  ///
  /// This method throws a [InvalidStatusCodeException] if the response code is
  /// not equal to 200 (OK) or 304 (NOT MODIFIED).
  /// The cache can be overridden with [ignoreCache].
  Stream<MenuEntry> getMenuEntries({bool ignoreCache = false}) async* {
    final headers = ignoreCache ? {} : _cacheHeader;
    final response = await _client.get<String>(
      'https://speiseplan.app.itelligence.org/',
      options: Options(headers: headers),
    );
    _setETag(response.headers);
    if (response.statusCode == HttpStatus.notModified) {
      yield* Stream.fromIterable(_lastResponse);
    } else if (response.statusCode != HttpStatus.ok) {
      throw InvalidStatusCodeException(
        response.statusCode,
        response.data,
        response.statusMessage,
      );
    } else {
      _lastResponse = [];
      final data = Document.html(_cleanUpResponse(response.data));
      // The first element is always empty
      final tables = data.querySelectorAll('#tabelle > table')..removeAt(0);
      for (final table in tables) {
        final entry = MenuEntry(table);
        _lastResponse.add(entry);
        yield entry;
      }
    }
  }
}
