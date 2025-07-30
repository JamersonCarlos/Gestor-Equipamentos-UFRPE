import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gestor_uso_projetores_ufrpe/presentation/providers/emprestimos_dia_provider.dart';
import 'package:gestor_uso_projetores_ufrpe/presentation/providers/projector_provider.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/charts_section.dart';
import 'widgets/projector_loan_table.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ScrollController _scrollController = ScrollController();
  double? _lastScrollPosition;
  WebSocketChannel? _channel;
  bool _isUpdating = false;
  bool _initialDataLoaded = false;
  bool _shouldRestoreScroll = false;

  @override
  void initState() {
    super.initState();
    // Salvar a posição do scroll quando ela mudar
    _scrollController.addListener(() {
      _lastScrollPosition = _scrollController.position.pixels;
    });

    // Configurar WebSocket para atualizações do dashboard
    _channel =
        WebSocketChannel.connect(Uri.parse('ws://localhost:8000/newuso'));
    _channel!.stream.listen((message) {
      try {
        final data = json.decode(message);
        if (data is Map && data['codigo_equipamento'] != '') {
          _handleDashboardUpdate();
        }
      } catch (e) {
        // Erro ao processar mensagem do WebSocket
      }
    });

    // Carregar dados iniciais após o primeiro frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_initialDataLoaded) {
        _loadInitialData();
        _initialDataLoaded = true;
      }
    });
  }

  void _loadInitialData() {
    // Carregar dados iniciais do dashboard
    final emprestimosProvider = context.read<EmprestimosDiaProvider>();
    emprestimosProvider.carregarEmprestimosPorDia();

    // Carregar dados iniciais da tabela
    final projectorProvider = context.read<ProjectorProvider>();
    projectorProvider.getUsos(page: 1, limit: 10);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _channel?.sink.close();
    super.dispose();
  }

  // Função para restaurar a posição do scroll
  void _restoreScrollPosition() {
    if (_lastScrollPosition != null && _scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _scrollController.hasClients) {
          _scrollController.jumpTo(_lastScrollPosition!);
        }
      });
    }
  }

  void _handleDashboardUpdate() {
    if (!_isUpdating && mounted) {
      _isUpdating = true;
      _shouldRestoreScroll = true;

      // Usar Future.delayed para dar tempo do scroll se estabilizar
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          // Atualizar dados do dashboard
          final emprestimosProvider = context.read<EmprestimosDiaProvider>();
          emprestimosProvider.refreshDashboardData();

          // Atualizar dados da tabela de projetores
          final projectorProvider = context.read<ProjectorProvider>();
          projectorProvider.refreshUsos();

          // Restaurar posição do scroll após as atualizações
          if (_shouldRestoreScroll) {
            Future.delayed(const Duration(milliseconds: 100), () {
              _restoreScrollPosition();
              _shouldRestoreScroll = false;
            });
          }

          _isUpdating = false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: _scrollController,
      children: const [
        DashboardHeader(),
        SizedBox(height: 16),
        ChartsSection(),
        SizedBox(height: 16),
        ProjectorLoanTable(),
      ],
    );
  }
}
