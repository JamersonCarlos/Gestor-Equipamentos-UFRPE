import 'package:flutter/material.dart';

class TagsAssociatedsScreen extends StatefulWidget {
  const TagsAssociatedsScreen({super.key});

  @override
  State<TagsAssociatedsScreen> createState() => _TagsAssociatedsScreenState();
}

class _TagsAssociatedsScreenState extends State<TagsAssociatedsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tags Associadas'),
      ),
      body: const Center(
        child: Text('Tags Associadas'),
      ),
    );
  }
}