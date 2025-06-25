import 'package:flutter/material.dart';
import 'package:gestor_uso_projetores_ufrpe/presentation/providers/projector_provider.dart';
import 'package:gestor_uso_projetores_ufrpe/presentation/providers/tags_provider.dart';
import 'package:gestor_uso_projetores_ufrpe/presentation/screens/tags/widgets/add_tag_modal.dart';
import 'package:gestor_uso_projetores_ufrpe/utils/format_date.util.dart';
import 'package:provider/provider.dart';

class TagInfo {
  final String id;
  final String equipmentName;
  final String lastActivity;
  final bool isActive;

  TagInfo({
    required this.id,
    required this.equipmentName,
    required this.lastActivity,
    required this.isActive,
  });
}

// Tela principal do Dashboard
class ElegantTagDashboard extends StatefulWidget {
  const ElegantTagDashboard({super.key});

  @override
  State<ElegantTagDashboard> createState() => _ElegantTagDashboardState();
}

class _ElegantTagDashboardState extends State<ElegantTagDashboard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TagsProvider>(context, listen: false).fetchTags();
    });
  }

  @override
  Widget build(BuildContext context) {
    final tagsProvider = Provider.of<TagsProvider>(context);
    final projectorProvider = Provider.of<ProjectorProvider>(context);
    return Scaffold(
      body: Row(
        children: [
          // Conteúdo Principal
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cabeçalho e Pesquisa
                  const Header(),
                  const SizedBox(height: 30),
                  // Títulos da Lista
                  const ListHeader(),
                  const SizedBox(height: 10),
                  // Lista de Tags
                  Expanded(
                    child: tagsProvider.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : tagsProvider.tags.isEmpty
                            ? const Center(
                                child: Text('Nenhuma tag encontrada'))
                            : TagListView(tags: tagsProvider.tags),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
         showDialog(
            context: context,
            builder: (context) => AddTagModal(tagsProvider: tagsProvider, projectorProvider: projectorProvider),
          );
        },
        child: const Icon(Icons.add),
        tooltip: 'Adicionar tag',
      ),
    );
  }
}

// Widget do Cabeçalho (Título e Pesquisa)
class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Tags de Equipamentos',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

// Widget dos Títulos da Lista
class ListHeader extends StatelessWidget {
  const ListHeader({super.key});

  @override
  Widget build(BuildContext context) {
    // Esses 'Expanded' garantem que o alinhamento das colunas seja consistente com os itens da lista
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        children: [
          Expanded(
              flex: 3,
              child: Text('ID da Tag',
                  style: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.w500))),
          Expanded(
              flex: 4,
              child: Text('Equipamento Associado',
                  style: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.w500))),
          Expanded(
              flex: 3,
              child: Text('Última Atividade',
                  style: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.w500))),
          Expanded(
              flex: 2,
              child: Text('Status',
                  style: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.w500))),
          SizedBox(width: 50), // Espaço para o botão de menu
        ],
      ),
    );
  }
}

// Widget da Lista de Tags
class TagListView extends StatefulWidget {
  final List<TagInfo> tags;
  const TagListView({super.key, required this.tags});

  @override
  State<TagListView> createState() => _TagListViewState();
}

class _TagListViewState extends State<TagListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: widget.tags.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return TagListItem(tagInfo: widget.tags[index]);
      },
    );
  }
}

// Widget de um Item da Lista de Tags
class TagListItem extends StatelessWidget {
  final TagInfo tagInfo;
  const TagListItem({super.key, required this.tagInfo});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 22.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Pipe colorido
          Container(
            width: 5,
            height: 40,
            decoration: BoxDecoration(
              color: tagInfo.isActive ? Colors.purple : Colors.grey,
              borderRadius: BorderRadius.circular(4),
            ),
            margin: const EdgeInsets.only(right: 16),
          ),
          Expanded(
              flex: 3,
              child: Text(tagInfo.id,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15))),
          Expanded(
              flex: 4,
              child: Text(tagInfo.equipmentName,
                  style: const TextStyle(color: Colors.grey))),
          Expanded(
              flex: 3,
              child: Text(formatRelativeDate(DateTime.parse(tagInfo.lastActivity)),
                  style: const TextStyle(color: Colors.grey))),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: tagInfo.isActive ? Colors.green : Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  tagInfo.isActive ? 'Ativa' : 'Inativa',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: tagInfo.isActive ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 50,
            child: IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.grey),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
