import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewPokemonScreen extends StatefulWidget {
  final Map<String, dynamic>? pokemonToEdit;
  final String? docId;

  const NewPokemonScreen({super.key, this.pokemonToEdit, this.docId});

  @override
  State<NewPokemonScreen> createState() => _NewPokemonScreenState();
}

class _NewPokemonScreenState extends State<NewPokemonScreen> {
  final List<Map<String, dynamic>> tipos = [
    {'id': 1, 'nome': 'Normal', 'cor': const Color(0xFFA8A77A), 'emoji': '⚪'},
    {'id': 10, 'nome': 'Fire', 'cor': const Color(0xFFEE8130), 'emoji': '🔥'},
    {'id': 11, 'nome': 'Water', 'cor': const Color(0xFF6390F0), 'emoji': '💧'},
    {'id': 12, 'nome': 'Grass', 'cor': const Color(0xFF7AC74C), 'emoji': '🌿'},
    {'id': 13, 'nome': 'Electric', 'cor': const Color(0xFFF7D02C), 'emoji': '⚡'},
    {'id': 18, 'nome': 'Fairy', 'cor': const Color(0xFFD685AD), 'emoji': '✨'},
  ];

  late TextEditingController nameController;
  late TextEditingController spriteController;
  late TextEditingController levelController;
  late TextEditingController movesController;
  late int? tipoSelecionado;

  final collection = FirebaseFirestore.instance.collection('pokemons');

  @override
  void initState() {
    super.initState();
    
    if (widget.pokemonToEdit != null) {
      nameController = TextEditingController(text: widget.pokemonToEdit!['name']);
      spriteController = TextEditingController(text: widget.pokemonToEdit!['spriteId'].toString());
      levelController = TextEditingController(text: widget.pokemonToEdit!['level'].toString());
      tipoSelecionado = widget.pokemonToEdit!['typeIds'][0];
      movesController = TextEditingController(
        text: (widget.pokemonToEdit!['moves'] as List).join(', '),
      );
    } else {
      nameController = TextEditingController();
      spriteController = TextEditingController();
      levelController = TextEditingController();
      movesController = TextEditingController();
      tipoSelecionado = null;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    spriteController.dispose();
    levelController.dispose();
    movesController.dispose();
    super.dispose();
  }

  Future<void> _salvarPokemon() async {
    if (nameController.text.isEmpty ||
        spriteController.text.isEmpty ||
        levelController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha todos os campos!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final moves = movesController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final pokemonData = {
      'name': nameController.text,
      'spriteId': int.parse(spriteController.text),
      'level': int.parse(levelController.text),
      'typeIds': [tipoSelecionado ?? 1],
      'moves': moves,
    };

    try {
      if (widget.pokemonToEdit != null && widget.docId != null) {
        await collection.doc(widget.docId).update(pokemonData);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Pokémon atualizado com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        await collection.add(pokemonData);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Pokémon adicionado com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
      
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.pokemonToEdit != null;
    
    return Scaffold(
      backgroundColor: const Color(0xFF87A9C4),
      appBar: AppBar(
        title: Text(
          isEditing ? 'Editar Pokémon' : 'Novo Pokémon',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF15202E),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, Color(0xFF87A9C4)],
              ),
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF15202E).withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Icon(
                    Icons.pets,
                    size: 64,
                    color: Color(0xFF15202E),
                  ),
                  const SizedBox(height: 20),
                  
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nome do Pokémon',
                      prefixIcon: Icon(Icons.abc, color: Color(0xFF1E3957)),
                      hintText: 'Ex: Pikachu',
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  TextField(
                    controller: spriteController,
                    decoration: const InputDecoration(
                      labelText: 'Sprite ID',
                      prefixIcon: Icon(Icons.image, color: Color(0xFF1E3957)),
                      hintText: 'Ex: 25 (para Pikachu)',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  
                  TextField(
                    controller: levelController,
                    decoration: const InputDecoration(
                      labelText: 'Level',
                      prefixIcon: Icon(Icons.arrow_upward, color: Color(0xFF1E3957)),
                      hintText: '1 a 100',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  
                  DropdownButtonFormField<int>(
                    decoration: const InputDecoration(
                      labelText: 'Tipo Principal',
                      prefixIcon: Icon(Icons.category, color: Color(0xFF1E3957)),
                    ),
                    value: tipoSelecionado,
                    items: tipos.map((tipo) {
                      return DropdownMenuItem<int>(
                        value: tipo['id'],
                        child: Row(
                          children: [
                            Text(
                              tipo['emoji'],
                              style: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              tipo['nome'],
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: tipo['cor'],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        tipoSelecionado = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  TextField(
                    controller: movesController,
                    decoration: const InputDecoration(
                      labelText: 'Golpes',
                      prefixIcon: Icon(Icons.sports_mma, color: Color(0xFF1E3957)),
                      hintText: 'Ex: Thunderbolt, Quick Attack, Iron Tail',
                      helperText: 'Separe os golpes por vírgula',
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 32),
                  
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF15202E),
                            side: const BorderSide(color: Color(0xFF15202E), width: 2),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancelar'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF15202E),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: _salvarPokemon,
                          child: Text(
                            isEditing ? 'Atualizar' : 'Salvar',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
