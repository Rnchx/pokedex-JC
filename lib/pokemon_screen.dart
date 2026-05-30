import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pokemon.dart';
import 'package:provider/provider.dart';
import 'battle_provider.dart';
import 'stat_bar.dart';

class PokemonScreen extends StatefulWidget {
  final Pokemon pokemon;
  final String docId;

  const PokemonScreen({super.key, required this.pokemon, required this.docId});

  @override
  State<PokemonScreen> createState() => _PokemonScreenState();
}

class _PokemonScreenState extends State<PokemonScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticIn),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showLevelUpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('🎉 Level Up!'),
        content: Text(
          '${widget.pokemon.name} subiu para o nível ${context.read<BattleProvider>().level}!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Incrível!'),
          ),
        ],
      ),
    );
  }

  Future<void> _encerrarBatalha() async {
    await FirebaseFirestore.instance
        .collection('pokemons')
        .doc(widget.docId)
        .update({'level': context.read<BattleProvider>().level});

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BattleProvider(
        pokemonName: widget.pokemon.name,
        level: widget.pokemon.level,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFF87A9C4),
        appBar: AppBar(
          title: Text(
            widget.pokemon.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: const Color(0xFF15202E),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: Builder(
          builder: (context) {
            final battle = context.watch<BattleProvider>();

            final level = context.select((BattleProvider p) => p.level);

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Card principal do Pokémon
                    AnimatedBuilder(
                      animation: _shakeAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(_shakeAnimation.value, 0),
                          child: child,
                        );
                      },
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
                              Hero(
                                tag: widget.pokemon.spriteUrl,
                                child: Image.network(
                                  widget.pokemon.spriteUrl,
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                widget.pokemon.name,
                                style: GoogleFonts.poppins(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF15202E),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF15202E,
                                  ).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'Nível $level',
                                  style: const TextStyle(
                                    color: Color(0xFF15202E),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Tipos do Pokémon com EMOJIS
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: widget.pokemon.types.map((tipo) {
                                  String emoji;
                                  Color iconColor;

                                  // Tipos em PORTUGUÊS
                                  switch (tipo) {
                                    case 'fire':
                                      emoji = '🔥';
                                      iconColor = const Color(0xFFEE8130);
                                      break;
                                    case 'water':
                                      emoji = '💧';
                                      iconColor = const Color(0xFF6390F0);
                                      break;
                                    case 'grass':
                                      emoji = '🌿';
                                      iconColor = const Color(0xFF7AC74C);
                                      break;
                                    case 'electric':
                                      emoji = '⚡';
                                      iconColor = const Color(0xFFF7D02C);
                                      break;
                                    case 'fairy':
                                      emoji = '✨';
                                      iconColor = const Color(0xFFD685AD);
                                      break;
                                    case 'normal':
                                      emoji = '⚪';
                                      iconColor = const Color(0xFFA8A77A);
                                      break;
                                    case 'poison':
                                      emoji = '💥';
                                      iconColor = const Color(0xFFA8A77A);
                                      break;
                                    default:
                                      emoji = '❓';
                                      iconColor = const Color(0xFFA8A77A);
                                  }

                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: iconColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          emoji,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          tipo,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: iconColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Barras de status
                    StatBar(
                      label: 'HP',
                      value: battle.hp,
                      maxValue: 100,
                      color: battle.hpColor,
                    ),
                    const SizedBox(height: 16),
                    StatBar(
                      label: 'XP',
                      value: battle.xp,
                      maxValue: 100,
                      color: const Color(0xFF15202E),
                    ),

                    const SizedBox(height: 24),

                    // Botões de ação
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: battle.hp > 0
                                ? () {
                                    _animationController.forward().then(
                                      (_) => _animationController.reset(),
                                    );

                                    final oldLevel = battle.level;

                                    context.read<BattleProvider>().attack();

                                    final newLevel = context
                                        .read<BattleProvider>()
                                        .level;

                                    if (newLevel > oldLevel) {
                                      _showLevelUpDialog();
                                    }
                                  }
                                : null,
                            icon: const Icon(
                              Icons.flash_on,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'Atacar',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF15202E),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              elevation: 2,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: battle.hp < 100
                                ? () {
                                    context.read<BattleProvider>().heal();

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('💊 Poção usada! +30 HP'),
                                        backgroundColor: Color(0xFF4CAF50),
                                        duration: Duration(seconds: 1),
                                      ),
                                    );
                                  }
                                : null,
                            icon: const Icon(
                              Icons.healing,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'Poção',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1E3957),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              elevation: 2,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final level = context.read<BattleProvider>().level;

                          await FirebaseFirestore.instance
                              .collection('pokemons')
                              .doc(widget.docId)
                              .update({'level': level});

                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        },
                        icon: const Icon(Icons.exit_to_app),
                        label: const Text(
                          'Encerrar Batalha',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF15202E),
                          side: const BorderSide(
                            color: Color(0xFF15202E),
                            width: 2,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
