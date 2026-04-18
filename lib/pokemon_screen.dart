import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pokemon.dart';

class PokemonScreen extends StatefulWidget {
  final Pokemon pokemon;
  final String docId;

  const PokemonScreen({
    super.key,
    required this.pokemon,
    required this.docId,
  });

  @override
  State<PokemonScreen> createState() => _PokemonScreenState();
}

class _PokemonScreenState extends State<PokemonScreen>
    with SingleTickerProviderStateMixin {
  int hp = 100;
  int xp = 0;
  late int level;
  late AnimationController _animationController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    level = widget.pokemon.level;
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

  Color get hpColor {
    if (hp > 60) return const Color(0xFF4CAF50);
    if (hp > 30) return const Color(0xFFFF9800);
    return const Color(0xFFF44336);
  }

  void _atacar() {
    _animationController.forward().then((_) => _animationController.reset());
    setState(() {
      hp = (hp - 20).clamp(0, 100);
      xp += 10;

      if (xp >= 100) {
        level++;
        xp -= 100;
        _showLevelUpDialog();
      }
    });
  }

  void _showLevelUpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('🎉 Level Up!'),
        content: Text('${widget.pokemon.name} subiu para o nível $level!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Incrível!'),
          ),
        ],
      ),
    );
  }

  void _usarPocao() {
    setState(() {
      hp = (hp + 30).clamp(0, 100);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('💊 Poção usada! +30 HP'),
        backgroundColor: Color(0xFF4CAF50),
        duration: Duration(seconds: 1),
      ),
    );
  }

  Future<void> _encerrarBatalha() async {
    await FirebaseFirestore.instance
        .collection('pokemons')
        .doc(widget.docId)
        .update({'level': level});

    if (mounted) {
      Navigator.pop(context);
    }
  }

  Widget _buildModernBar(String label, int value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Color(0xFF15202E),
              ),
            ),
            Text(
              '$value / 100',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E3957),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: value / 100,
            color: color,
            backgroundColor: const Color(0xFF87A9C4).withOpacity(0.3),
            minHeight: 10,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: SingleChildScrollView(
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
                            width: 160,
                            height: 160,
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
                            color: const Color(0xFF15202E).withOpacity(0.1),
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
                          children: widget.pokemon.tipoNomes.map((tipo) {
                            String emoji;
                            Color iconColor;
                            
                            // Tipos em PORTUGUÊS
                            switch (tipo) {
                              case 'Fire':
                                emoji = '🔥';
                                iconColor = const Color(0xFFEE8130);
                                break;
                              case 'Water':
                                emoji = '💧';
                                iconColor = const Color(0xFF6390F0);
                                break;
                              case 'Grass':
                                emoji = '🌿';
                                iconColor = const Color(0xFF7AC74C);
                                break;
                              case 'Electric':
                                emoji = '⚡';
                                iconColor = const Color(0xFFF7D02C);
                                break;
                              case 'Fairy':
                                emoji = '✨';
                                iconColor = const Color(0xFFD685AD);
                                break;
                              case 'Normal':
                                emoji = '⚪';
                                iconColor = const Color(0xFFA8A77A);
                                break;
                              default:
                                emoji = '❓';
                                iconColor = const Color(0xFFA8A77A);
                            }
                            
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
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
              _buildModernBar('HP', hp, hpColor),
              const SizedBox(height: 16),
              _buildModernBar('XP', xp, const Color(0xFF15202E)),

              const SizedBox(height: 24),

              // Botões de ação
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: hp > 0 ? _atacar : null,
                      icon: const Icon(Icons.flash_on, color: Colors.white),
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
                      onPressed: hp < 100 ? _usarPocao : null,
                      icon: const Icon(Icons.healing, color: Colors.white),
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
                  onPressed: _encerrarBatalha,
                  icon: const Icon(Icons.exit_to_app),
                  label: const Text(
                    'Encerrar Batalha',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF15202E),
                    side: const BorderSide(color: Color(0xFF15202E), width: 2),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Seção de golpes
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF15202E).withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.sports_mma, size: 22, color: Color(0xFF15202E)),
                        SizedBox(width: 10),
                        Text(
                          'Golpes',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF15202E),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ...widget.pokemon.moves.map(
                      (move) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: Color(0xFF15202E),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Text(
                              move,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1E3957),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}