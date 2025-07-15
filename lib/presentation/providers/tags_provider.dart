import 'package:flutter/material.dart';
import 'package:gestor_uso_projetores_ufrpe/domain/entities/rfid_tag.dart';
import 'package:gestor_uso_projetores_ufrpe/presentation/screens/tags/tags_associateds_screen.dart';
import 'package:gestor_uso_projetores_ufrpe/services/tag_service.dart';

class TagsProvider extends ChangeNotifier {
  final TagService _tagService = TagService();
  bool _isLoading = false;

  List<TagInfo> _tags = [];

  List<TagInfo> get tags => _tags;
  bool get isLoading => _isLoading;

  Future<void> fetchTags() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _tagService.getTags();
      _tags = response
          .map((tag) => TagInfo(
                id: tag['rfid'] ?? '',
                equipmentName: tag['nome'] ?? '',
                lastActivity: tag['ultima_leitura'] ?? '',
                isActive: tag['status'] == 'ATIVO',
              ))
          .toList();
    } catch (e) {
      debugPrint('Erro ao buscar tags: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTag(RfidTag tag) async {
    try {
      await _tagService.addTag(tag);
      fetchTags();
      notifyListeners();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> toggleTagStatus(TagInfo tag) async {
    // Altere o status localmente
    //tag.isActive = !tag.isActive;
    tags.firstWhere((element) => element.id == tag.id).isActive = !tag.isActive;
    notifyListeners();

    // Faça a chamada para atualizar no backend, se necessário
    await _tagService.updateTagStatus(tag.id, tag.isActive);
  }
}
