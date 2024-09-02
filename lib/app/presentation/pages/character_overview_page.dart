import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CharacterOverviewPage extends StatefulWidget {
  const CharacterOverviewPage({super.key});

  @override
  State<CharacterOverviewPage> createState() => _CharacterOverviewPageState();
}

class _CharacterOverviewPageState extends State<CharacterOverviewPage> {
  final int characterId = Get.arguments as int;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do personagem'),
      ),
      body: Center(
        child: Text('Detalhes do personagem $characterId'),
      ),
    );
  }
}
