import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'pokemon_service.dart';

class NewPokemonScreen extends StatefulWidget {
  const NewPokemonScreen({super.key});

  @override
  State<NewPokemonScreen> createState() => _NewPokemonScreenState();
}

class _NewPokemonScreenState extends State<NewPokemonScreen> {
  late Future<List<String>> _searchFuture;

  final _queryController = TextEditingController();

  Map<String, dynamic>? _selected;

  bool _loadingDetails = false;

  final _levelController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final collection = FirebaseFirestore.instance.collection('pokemons');

  @override
  void initState() {
    super.initState();

    _searchFuture = PokemonService.fetchPokemonNames();
  }

  @override
  void dispose() {
    _queryController.dispose();
    _levelController.dispose();
    super.dispose();
  }

  void _buscar() {
    final query = _queryController.text.trim();

    setState(() {
      if (query.isEmpty) {
        _searchFuture = PokemonService.fetchPokemonNames();
      } else {
        _searchFuture = PokemonService.fetchPokemonByName(query);
      }
    });
  }

  Future<void> _selectPokemon(String name) async {
    setState(() {
      _loadingDetails = true;
    });

    try {
      final data = await PokemonService.fetchPokemonDetails(name);

      setState(() {
        _selected = data;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    } finally {
      setState(() {
        _loadingDetails = false;
      });
    }
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    await collection.add({
      'name': _selected!['name'],
      'spriteUrl': _selected!['spriteUrl'],
      'types': _selected!['types'],
      'level': int.parse(_levelController.text),
    });

    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF87A9C4),
      appBar: AppBar(
        title: const Text(
          'Novo Pokémon',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF15202E),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _selected == null ? _buildList() : _buildForm(),
    );
  }

  Widget _buildList() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _queryController,
                  decoration: const InputDecoration(hintText: 'Buscar Pokémon'),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(onPressed: _buscar, child: const Text('Buscar')),
            ],
          ),

          const SizedBox(height: 20),

          Expanded(
            child: FutureBuilder<List<String>>(
              future: _searchFuture,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('${snapshot.error}'));
                }

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final names = snapshot.data!;

                return ListView.builder(
                  itemCount: names.length,
                  itemBuilder: (context, index) {
                    final name = names[index];

                    return Card(
                      child: ListTile(
                        title: Text(name),
                        trailing: const Icon(Icons.catching_pokemon),
                        onTap: () => _selectPokemon(name),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    if (_loadingDetails) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Image.network(
                      _selected!['spriteUrl'],
                      width: 140,
                      height: 140,
                    ),

                    const SizedBox(height: 16),

                    Text(
                      _selected!['name'],
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),

                    Wrap(
                      spacing: 8,
                      children: (_selected!['types'] as List<dynamic>)
                          .map((t) => Chip(label: Text(t as String)))
                          .toList(),
                    ),

                    const SizedBox(height: 20),

                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _selected = null;
                        });
                      },
                      child: const Text('Trocar'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            TextFormField(
              controller: _levelController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Nível'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Digite um nível';
                }

                final level = int.tryParse(value);

                if (level == null || level < 1 || level > 100) {
                  return 'Nível deve ser entre 1 e 100';
                }

                return null;
              },
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _salvar,
                child: const Text('Cadastrar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
