import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:avantswift_portfolio/models/Analytic.dart';
import 'package:mockito/mockito.dart';

// ignore: subtype_of_sealed_class
class DocumentSnapshotMock extends Mock implements DocumentSnapshot {
  DocumentSnapshotMock({required this.d});
  final Map<String, dynamic> d;
  @override
  Map<String, dynamic> data() => d;
}

void main() {

  group('Analytic Model tests', () {
    test('fromDocumentSnapshot should return an Analytic object', () {
      final data = {
        'analyticId': '123',
        'month': Timestamp.now(),
        'views': 420,
        'messages': 13,
        'lastEdit': Timestamp.now(),
      };
      final snapshot = DocumentSnapshotMock(d: data);

      final result = Analytic.fromDocumentSnapshot(snapshot);

      expect(result.analyticId, data['analyticId']);
      expect(result.month, data['month']);
      expect(result.views, data['views']);
      expect(result.messages, data['messages']);
      expect(result.lastEdit, data['lastEdit']);
    });

    test('Analytic.toMap should convert analytic to a map', () {
      final analytic = Analytic(
        analyticId: '123',
        month: Timestamp.now(),
        views: 420,
        messages: 13,
        lastEdit: Timestamp.now(),
      );
      final analyticMap = analytic.toMap();

      expect(analyticMap['analyticId'], analytic.analyticId);
      expect(analyticMap['month'], analytic.month);
      expect(analyticMap['views'], analytic.views);
      expect(analyticMap['messages'], analytic.messages);
      expect(analyticMap['lastEdit'], analytic.lastEdit);
    });
  });
}
