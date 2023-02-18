import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:campus_plus/controller/card_controller.dart';

void main() {
  group('CardController', () {
    late CardController cardController;

    setUpAll(() async { // Use setUpAll instead of setUp
      // Initialize Firebase
      await Firebase.initializeApp();

      cardController = CardController();
    });

    test('createCard() should create a card successfully', () async {
      final result = await cardController.createCard(
        event: 'Test Event',
        audience: 'Test Audience',
        attendeeLimit: 10,
        dateCreated: DateTime.now(),
        eventStart: DateTime.now(),
        eventEnd: DateTime.now().add(Duration(hours: 2)),
        tags: ['tag1', 'tag2'],
      );

      expect(result, true);
    });
  });
}
