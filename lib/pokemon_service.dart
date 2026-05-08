import 'dart:convert';
import 'package:http/http.dart' as http;

class PokemonService {
  static const String baseUrl = 'https://pokeapi.co/api/v2';

  static Future<List<String>> fetchPokemonNames() async {
    final response = await http.get(Uri.parse('$baseUrl/pokemon?limit=20'));

    if (response.statusCode != 200) {
      throw Exception('Erro ao buscar Pokémon');
    }

    final data = jsonDecode(response.body);

    final results = data['results'] as List<dynamic>;

    return results.map((item) => item['name'] as String).toList();
  }

  static Future<List<String>> fetchPokemonByName(String name) async {
    final response = await http.get(
      Uri.parse('$baseUrl/pokemon/${name.toLowerCase()}'),
    );

    if (response.statusCode == 404) {
      throw Exception('Pokémon não encontrado');
    }

    if (response.statusCode != 200) {
      throw Exception('Erro ao buscar Pokémon');
    }

    final data = jsonDecode(response.body);

    return [data['name']];
  }

  static Future<Map<String, dynamic>> fetchPokemonDetails(String name) async {
    final response = await http.get(
      Uri.parse('$baseUrl/pokemon/${name.toLowerCase()}'),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao buscar detalhes');
    }

    final data = jsonDecode(response.body);

    final sprites = data['sprites'];
    final id = data['id'];

    final spriteUrl =
        sprites['front_default'] ??
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';

    final rawTypes = data['types'] as List<dynamic>;

    final types = rawTypes
        .map(
          (t) =>
              ((t as Map<String, dynamic>)['type']
                      as Map<String, dynamic>)['name']
                  as String,
        )
        .toList();

    return {'name': data['name'], 'spriteUrl': spriteUrl, 'types': types};
  }
}
