import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'pokemon.dart';
import 'pokemon_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final collection = FirebaseFirestore.instance.collection('pokemons');

  final List<Map<String, dynamic>> tipos = [
    {'id': 1, 'nome': 'Normal', 'cor': Color(0xFFA8A77A), 'emoji': '⚪'},
    {'id': 10, 'nome': 'Fire', 'cor': Color(0xFFEE8130), 'emoji': '🔥'},
    {'id': 11, 'nome': 'Water', 'cor': Color(0xFF6390F0), 'emoji': '💧'},
    {'id': 12, 'nome': 'Grass', 'cor': Color(0xFF7AC74C), 'emoji': '🌿'},
    {'id': 13, 'nome': 'Electric', 'cor': Color(0xFFF7D02C), 'emoji': '⚡'},
    {'id': 18, 'nome': 'Fairy', 'cor': Color(0xFFD685AD), 'emoji': '✨'},
  ];

  void _mostrarDialogAdicionar(BuildContext context) {
    final nameController = TextEditingController();
    final spriteController = TextEditingController();
    final levelController = TextEditingController();

    int? tipoSelecionado;
    final movesController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, Color(0xFF87A9C4)],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Novo Pokémon',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF15202E),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                    prefixIcon: Icon(Icons.abc, color: Color(0xFF1E3957)),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: spriteController,
                  decoration: const InputDecoration(
                    labelText: 'Sprite ID',
                    prefixIcon: Icon(Icons.image, color: Color(0xFF1E3957)),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: levelController,
                  decoration: const InputDecoration(
                    labelText: 'Level',
                    prefixIcon: Icon(Icons.arrow_upward, color: Color(0xFF1E3957)),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  decoration: const InputDecoration(
                    labelText: 'Tipo',
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
                    tipoSelecionado = value;
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: movesController,
                  decoration: const InputDecoration(
                    labelText: 'Moves (separados por vírgula)',
                    prefixIcon: Icon(Icons.sports_mma, color: Color(0xFF1E3957)),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF15202E),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text('Cancelar'),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF15202E),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text('Salvar'),
                        onPressed: () async {
                          final moves = movesController.text
                              .split(',')
                              .map((e) => e.trim())
                              .toList();

                          await collection.add({
                            'name': nameController.text,
                            'spriteId': int.parse(spriteController.text),
                            'level': int.parse(levelController.text),
                            'typeIds': [tipoSelecionado ?? 1],
                            'moves': moves,
                          });

                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getTipoCor(int typeId) {
    final tipo = tipos.firstWhere((t) => t['id'] == typeId, orElse: () => {'cor': Color(0xFFA8A77A)});
    return tipo['cor'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF87A9C4),
      appBar: AppBar(
        title: const Text(
          'Pokédex JC',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _mostrarDialogAdicionar(context),
        icon: const Icon(Icons.add),
        label: const Text('Adicionar'),
        backgroundColor: const Color(0xFF15202E),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: StreamBuilder(
          stream: collection.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.white70),
                    const SizedBox(height: 16),
                    Text('Erro: ${snapshot.error}', style: const TextStyle(color: Colors.white)),
                  ],
                ),
              );
            }

            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF15202E)),
                ),
              );
            }

            final docs = snapshot.data!.docs;

            if (docs.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.pets, size: 64, color: Colors.white70),
                    const SizedBox(height: 16),
                    const Text(
                      'Nenhum Pokémon cadastrado',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final data = docs[index].data() as Map;
                final docId = docs[index].id;

                final pokemon = Pokemon(
                  name: data['name'],
                  spriteId: data['spriteId'],
                  typeIds: List<int>.from(data['typeIds']),
                  level: data['level'],
                  moves: List<String>.from(data['moves']),
                );

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PokemonScreen(
                              pokemon: pokemon,
                              docId: docId,
                            ),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF15202E).withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Imagem do Pokémon - Fundo com a cor do tipo
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: const Color(0xFF15202E),
                                // color: _getTipoCor(pokemon.typeIds.first),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(24),
                                  bottomLeft: Radius.circular(24),
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(24),
                                  bottomLeft: Radius.circular(24),
                                ),
                                child: Image.network(
                                  pokemon.spriteUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            // Informações
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      pokemon.name,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF15202E),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF15202E).withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            'Nível ${pokemon.level}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: const Color(0xFF15202E),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        ...pokemon.tipoNomes.map((tipo) {
                                          // Pega o emoji correspondente ao tipo
                                          String emoji = '';
                                          Color tipoCor = const Color(0xFFA8A77A);
                                          for (var t in tipos) {
                                            if (t['nome'] == tipo) {
                                              emoji = t['emoji'];
                                              tipoCor = t['cor'];
                                              break;
                                            }
                                          }
                                          return Container(
                                            margin: const EdgeInsets.only(right: 4),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: tipoCor.withOpacity(0.2),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  emoji,
                                                  style: const TextStyle(fontSize: 10),
                                                ),
                                                const SizedBox(width: 2),
                                                Text(
                                                  tipo,
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w600,
                                                    color: tipoCor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Botão deletar
                            IconButton(
                              icon: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF15202E).withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.delete_outline, color: Color(0xFF15202E), size: 20),
                              ),
                              onPressed: () async {
                                await collection.doc(docId).delete();
                              },
                            ),
                            const SizedBox(width: 8),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}