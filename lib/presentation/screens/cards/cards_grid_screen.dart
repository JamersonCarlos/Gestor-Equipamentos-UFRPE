import 'package:flutter/material.dart';
import 'package:gestor_uso_projetores_ufrpe/presentation/providers/cards_provider.dart';
import 'package:gestor_uso_projetores_ufrpe/presentation/screens/cards/widgets/add_card_modal.dart';
import 'package:gestor_uso_projetores_ufrpe/presentation/screens/cards/widgets/rfid_card_item.dart';
import 'package:provider/provider.dart';

class ResponsiveRfidCardGrid extends StatefulWidget {
  const ResponsiveRfidCardGrid({super.key});

  @override
  State<ResponsiveRfidCardGrid> createState() => _ResponsiveRfidCardGridState();
}

class _ResponsiveRfidCardGridState extends State<ResponsiveRfidCardGrid> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CardsProvider>(context, listen: false).getCards();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cardsProvider = Provider.of<CardsProvider>(context);
    const double maxCardWidth = 390.0;
    const double cardAspectRatio = 1.8; // Mais largo do que alto

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<RfidCardInfo>>(
          future: cardsProvider.rfidCards(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Nenhum cartão encontrado.'));
            }
            final cards = snapshot.data!;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: maxCardWidth,
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
                childAspectRatio: cardAspectRatio,
              ),
              itemCount: cards.length,
              itemBuilder: (context, index) {
                final cardInfo = cards[index];
                return RfidCardItem(cardInfo: cardInfo);
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
         showDialog(
            context: context,
            builder: (context) => AddCardModal(cardsProvider: cardsProvider),
          );
        },
        child: const Icon(Icons.add),
        tooltip: 'Adicionar cartão',
      ),
    );
  }
}
