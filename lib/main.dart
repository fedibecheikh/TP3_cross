import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waiting_room_app/queue_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => QueueProvider(),
      child: const WaitingRoomApp(),
    ),
  );
}

class WaitingRoomApp extends StatelessWidget {
  const WaitingRoomApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Local Waiting Room',
      home: WaitingRoomScreen(),
    );
  }
}

class WaitingRoomScreen extends StatelessWidget {
  const WaitingRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // watch : le widget se reconstruit quand le provider notifie
    final queueProvider = context.watch<QueueProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Local Waiting Room'),
        actions: [
          IconButton(
            key: const Key('nextClientButton'),
            icon: const Icon(Icons.skip_next),
            tooltip: 'Next Client',
            // read : appel d'une méthode, sans écouter les changements
            onPressed: () => context.read<QueueProvider>().nextClient(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const AddClientForm(),
            const SizedBox(height: 16),
            Text('Clients in Queue: ${queueProvider.clients.length}'),
            Expanded(
              child: ListView.builder(
                itemCount: queueProvider.clients.length,
                itemBuilder: (context, index) {
                  final clientName = queueProvider.clients[index];
                  return Card(
                    child: ListTile(
                      title: Text(clientName),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => context
                            .read<QueueProvider>()
                            .removeClient(clientName),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Seul rôle : posséder le TextEditingController (état purement local à l'UI).
class AddClientForm extends StatefulWidget {
  const AddClientForm({super.key});

  @override
  State<AddClientForm> createState() => _AddClientFormState();
}

class _AddClientFormState extends State<AddClientForm> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _controller.text.trim();
    if (name.isNotEmpty) {
      context.read<QueueProvider>().addClient(name);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(labelText: 'Client Name'),
            onSubmitted: (_) => _submit(),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Add'),
        ),
      ],
    );
  }
}