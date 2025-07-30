import 'package:flutter/material.dart';
import 'package:gestor_uso_projetores_ufrpe/presentation/providers/emprestimos_dia_provider.dart';
import 'package:provider/provider.dart';
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

  @override
  void initState() {
    super.initState();
    // Salvar a posição do scroll quando ela mudar
    _scrollController.addListener(() {
      _lastScrollPosition = _scrollController.position.pixels;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Função para restaurar a posição do scroll
  void restoreScrollPosition() {
    if (_lastScrollPosition != null && _scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.jumpTo(_lastScrollPosition!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => EmprestimosDiaProvider()),
      ],
      child: ListView(
        controller: _scrollController,
        children: const [
          DashboardHeader(),
          SizedBox(height: 16),
          ChartsSection(),
          SizedBox(height: 16),
          ProjectorLoanTable(),
        ],
      ),
    );
  }
}
