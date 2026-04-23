import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'pokemon.dart';
import 'pokemon_screen.dart';
import 'new_pokemon_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final collection = FirebaseFirestore.instance.collection('pokemons');

  final List<Map<String, dynamic>> tipos = [
    {'id': 1, 'nome': 'Normal', 'cor': const Color(0xFFA8A77A), 'emoji': '⚪'},
    {'id': 10, 'nome': 'Fire', 'cor': const Color(0xFFEE8130), 'emoji': '🔥'},
    {'id': 11, 'nome': 'Water', 'cor': const Color(0xFF6390F0), 'emoji': '💧'},
    {'id': 12, 'nome': 'Grass', 'cor': const Color(0xFF7AC74C), 'emoji': '🌿'},
    {'id': 13, 'nome': 'Electric', 'cor': const Color(0xFFF7D02C), 'emoji': '⚡'},
    {'id': 18, 'nome': 'Fairy', 'cor': const Color(0xFFD685AD), 'emoji': '✨'},
  ];

  void _navegarParaNovoPokemon({Map<String, dynamic>? pokemonToEdit, String? docId}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NewPokemonScreen(
          pokemonToEdit: pokemonToEdit,
          docId: docId,
        ),
      ),
    ).then((result) {
      if (result == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lista atualizada!'),
            duration: Duration(seconds: 1),
            backgroundColor: Color(0xFF4CAF50),
          ),
        );
      }
    });
  }

  Future<void> _deletarPokemon(String docId, String nome) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Excluir Pokémon'),
        content: Text('Tem certeza que deseja excluir $nome?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await collection.doc(docId).delete();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$nome foi excluído!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
        // Ícone de informações REMOVIDO
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navegarParaNovoPokemon(),
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
                    const SizedBox(height: 8),
                    const Text(
                      'Toque no botão + para adicionar',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final data = docs[index].data();
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
                            // Imagem do Pokémon - AGORA COM AZUL MARINHO (#15202E)
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: const Color(0xFF15202E), // VOLTOU PARA AZUL MARINHO
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
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(
                                      child: Icon(Icons.catching_pokemon, size: 40, color: Colors.white70),
                                    );
                                  },
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
                            // Menu de opções (Editar e Deletar)
                            PopupMenuButton<String>(
                              icon: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF15202E).withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.more_vert, color: Color(0xFF15202E), size: 20),
                              ),
                              onSelected: (value) {
                                if (value == 'edit') {
                                  final Map<String, dynamic> pokemonData = {};
                                  (data as Map).forEach((key, value) {
                                    pokemonData[key.toString()] = value;
                                  });
                                  
                                  _navegarParaNovoPokemon(
                                    pokemonToEdit: pokemonData,
                                    docId: docId,
                                  );
                                } else if (value == 'delete') {
                                  _deletarPokemon(docId, pokemon.name);
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit, size: 20, color: Color(0xFF1E3957)),
                                      SizedBox(width: 12),
                                      Text('Editar'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete_outline, size: 20, color: Colors.red),
                                      SizedBox(width: 12),
                                      Text('Excluir', style: TextStyle(color: Colors.red)),
                                    ],
                                  ),
                                ),
                              ],
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
