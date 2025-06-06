import 'package:flutter/material.dart';

// Modelo de dados para a Tag
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
class ElegantTagDashboard extends StatelessWidget {
  ElegantTagDashboard({super.key});

  final List<TagInfo> _tags = [
    TagInfo(id: 'TAG-001-A', equipmentName: 'Torno CNC-102', lastActivity: 'Hoje, 14:30', isActive: true),
    TagInfo(id: 'TAG-002-B', equipmentName: 'Prensa Hidráulica P-45', lastActivity: 'Ontem, 09:15', isActive: true),
    TagInfo(id: 'TAG-003-C', equipmentName: 'Esteira Transportadora E-12', lastActivity: '2 dias atrás', isActive: false),
    TagInfo(id: 'TAG-004-D', equipmentName: 'Compressor de Ar C-03', lastActivity: 'Hoje, 11:05', isActive: true),
    TagInfo(id: 'TAG-005-E', equipmentName: 'Gerador G-01', lastActivity: '1 dia atrás', isActive: true),
    TagInfo(id: 'TAG-006-F', equipmentName: 'Empilhadeira Emp-05', lastActivity: '5 dias atrás', isActive: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC), // Um cinza bem claro para o fundo
      body: Row(
        children: [

          // Conteúdo Principal
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 30.0),
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
                    child: TagListView(tags: _tags),
                  ),
                ],
              ),
            ),
          ),
        ],
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
        Text('Tags de Equipamentos', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
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
          Expanded(flex: 3, child: Text('ID da Tag', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500))),
          Expanded(flex: 4, child: Text('Equipamento Associado', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500))),
          Expanded(flex: 3, child: Text('Última Atividade', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500))),
          Expanded(flex: 2, child: Text('Status', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500))),
          SizedBox(width: 50), // Espaço para o botão de menu
        ],
      ),
    );
  }
}

// Widget da Lista de Tags
class TagListView extends StatelessWidget {
  final List<TagInfo> tags;
  const TagListView({super.key, required this.tags});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: tags.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return TagListItem(tagInfo: tags[index]);
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
          Expanded(flex: 3, child: Text(tagInfo.id, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
          Expanded(flex: 4, child: Text(tagInfo.equipmentName, style: const TextStyle(color: Colors.grey))),
          Expanded(flex: 3, child: Text(tagInfo.lastActivity, style: const TextStyle(color: Colors.grey))),
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