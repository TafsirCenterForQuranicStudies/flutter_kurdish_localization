import 'package:flutter/material.dart';
import 'package:flutter_kurdish_localization_example/localization/language_constants.dart';
import 'package:flutter_kurdish_localization_example/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('MyApp builds and respects saved locale', (tester) async {
    SharedPreferences.setMockInitialValues({langCode: 'ckb'});

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.locale?.languageCode, 'ckb');
  });
}
