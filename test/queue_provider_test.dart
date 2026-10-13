import 'package:flutter_test/flutter_test.dart';
import 'package:waiting_room_app/queue_provider.dart';

void main() {
  test('should add a client', () {
    final provider = QueueProvider();
    provider.addClient('Client A');
    expect(provider.clients, ['Client A']);
  });

  test('should remove the first client when nextClient() is called', () {
    // ARRANGE
    final provider = QueueProvider();
    provider.addClient('Client A');
    provider.addClient('Client B');

    // ACT
    provider.nextClient();

    // ASSERT
    expect(provider.clients.length, 1);
    expect(provider.clients.first, 'Client B');
  });

  test('nextClient() on an empty queue does nothing', () {
    final provider = QueueProvider();
    provider.nextClient();
    expect(provider.clients, isEmpty);
  });

  test('should notify listeners when a client is added', () {
    final provider = QueueProvider();
    var notified = 0;
    provider.addListener(() => notified++);

    provider.addClient('Client A');

    expect(notified, 1);
  });
}