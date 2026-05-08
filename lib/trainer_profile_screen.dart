import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TrainerProfileScreen extends StatefulWidget {
  const TrainerProfileScreen({super.key});

  @override
  State<TrainerProfileScreen> createState() => _TrainerProfileScreenState();
}

class _TrainerProfileScreenState extends State<TrainerProfileScreen> {
  final TextEditingController _nameController = TextEditingController();

  int _selectedAvatar = 0;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final doc = await FirebaseFirestore.instance
        .collection('config')
        .doc('treinador')
        .get();

    if (doc.exists) {
      final data = doc.data()!;

      setState(() {
        _nameController.text = data['name'] as String? ?? '';

        _selectedAvatar = data['avatarIndex'] as int? ?? 0;
      });
    }
  }

  Future<void> _saveProfile() async {
    final nome = _nameController.text.trim();

    if (nome.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Digite um nome válido!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    await FirebaseFirestore.instance.collection('config').doc('treinador').set({
      'name': nome,
      'avatarIndex': _selectedAvatar,
    }, SetOptions(merge: true));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Perfil salvo!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF87A9C4),

      appBar: AppBar(
        title: const Text(
          'Perfil do Treinador',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF15202E),
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),

        child: Container(
          padding: const EdgeInsets.all(24),

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
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),

          child: Column(
            children: [
              const Icon(Icons.person, size: 70, color: Color(0xFF15202E)),

              const SizedBox(height: 24),

              TextField(
                controller: _nameController,

                decoration: InputDecoration(
                  labelText: 'Nome do treinador',

                  prefixIcon: const Icon(Icons.badge, color: Color(0xFF1E3957)),

                  filled: true,
                  fillColor: Colors.white,

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              const Text(
                'Escolha seu avatar',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF15202E),
                ),
              ),

              const SizedBox(height: 20),

              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),

                children: List.generate(6, (i) {
                  final isSelected = _selectedAvatar == i;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedAvatar = i;
                      });
                    },

                    child: Container(
                      margin: const EdgeInsets.all(8),

                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF15202E).withOpacity(0.15)
                            : Colors.white,

                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF15202E)
                              : Colors.transparent,
                          width: 3,
                        ),

                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: Padding(
                        padding: const EdgeInsets.all(8),

                        child: Image.asset(
                          'assets/trainers/trainer_${i + 1}.png',
                        ),
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,

                child: ElevatedButton(
                  onPressed: _saveProfile,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF15202E),

                    foregroundColor: Colors.white,

                    padding: const EdgeInsets.symmetric(vertical: 18),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),

                  child: const Text(
                    'Salvar Perfil',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
