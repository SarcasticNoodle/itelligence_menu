import 'dart:async';

import 'package:dio/dio.dart';
import 'package:itelligence_menu/itelligence_menu.dart';
import 'package:itelligence_menu/src/exceptions/invalid_status_code_exception.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:itelligence_menu/src/string.dart';

void main() {
  group('String extension test', () {
    test('Return null if whitespace', () {
      final whitespace = ' \t\n  ';
      expect(whitespace.nullIfWhiteSpace, null);
    });

    test('Return actual if not whitespace', () {
      final letters = '\n t est_string \t';
      expect(letters.nullIfWhiteSpace, letters);
    });
  });

  group('Production env test', () {
    ItelligenceMenuClient productionClient;

    setUpAll(() {
      productionClient = ItelligenceMenuClient();
    });

    test('Get all/cached', () async {
      final entries = await productionClient.getMenuEntries().toList();
      expect(entries.isEmpty, false);
      for (var i = 0; i < entries.length; i++) {
        expect(entries[i].date.weekday, i + 1);
        expect(entries[i].supplements, isNotEmpty);
        expect(
            entries[i].campaignMeal == null ||
                entries[i].campaignMeal.isNotEmpty,
            true);
        expect(
            entries[i].selectionOne == null ||
                entries[i].selectionOne.isNotEmpty,
            true);
        expect(
            entries[i].selectionTwo == null ||
                entries[i].selectionTwo.isNotEmpty,
            true);
      }
      final response = await productionClient.getMenuEntries().toList();
      expect(response, isNotEmpty);
      expect(response.length, entries.length);
    });

    tearDownAll(() {
      productionClient = null;
    });
  });

  group('Mock response test', () {
    MockClient mockClient;
    ItelligenceMenuClient mockedClient;

    setUpAll(() {
      mockClient = MockClient();
      mockedClient = ItelligenceMenuClient.private(mockClient);
    });

    test('Invalid Status code', () async {
      when(mockClient.get<String>(
        any,
        options: captureThat(isNotNull, named: 'options'),
      )).thenAnswer(
        (_) => Future.value(
          Response(
            data: 'Invalid',
            statusCode: 401,
            statusMessage: 'Unauthorized',
            headers: Headers.fromMap({}),
          ),
        ),
      );
      expect(mockedClient.getMenuEntries().toList(),
          throwsA(TypeMatcher<InvalidStatusCodeException>()));
    });

    test('Exception toString', () {
      final exception =
          InvalidStatusCodeException(502, 'invalid', 'Bad Gateway');
      expect(
          exception.toString(),
          'InvalidStatusCodeException:'
          ' Server returned status code '
          '${exception.statusCode}:${exception.reason}');
    });

    tearDownAll(() {
      mockClient = null;
      mockedClient = null;
    });
  });
}

class MockClient extends Mock implements Dio {}
