import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../presentation/providers/projector_provider.dart';

class ProjectorsScreen extends StatefulWidget {
  const ProjectorsScreen({super.key});

  @override
  State<ProjectorsScreen> createState() => _ProjectorsScreenState();
}

class _ProjectorsScreenState extends State<ProjectorsScreen> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      Provider.of<ProjectorProvider>(context, listen: false).loadProjectors();
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProjectorProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.error != null) {
          return Center(child: Text(provider.error!));
        }

        if (provider.projectors.isEmpty) {
          return const Center(child: Text('Nenhum projetor cadastrado.'));
        }

        return ListView.builder(
          itemCount: provider.projectors.length,
          itemBuilder: (context, index) {
            final projector = provider.projectors[index];
            return Card(
              child: ListTile(
                leading: const Icon(Icons.video_camera_front),
                title: Text(projector.model),
                subtitle: Text(projector.serialNumber),
                trailing: Chip(
                  label: Text(
                    projector.isAvailable ? 'Disponível' : 'Em Uso',
                    style: TextStyle(
                      color:
                          projector.isAvailable ? Colors.green : Colors.orange,
                    ),
                  ),
                  backgroundColor: projector.isAvailable
                      ? Colors.green.withOpacity(0.1)
                      : Colors.orange.withOpacity(0.1),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
