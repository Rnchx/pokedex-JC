# 🐾 Pokédex JC

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Cloud%20Firestore-orange.svg)](https://firebase.google.com)
[![Dart](https://img.shields.io/badge/Dart-3.0+-teal.svg)](https://dart.dev)

## 📱 Sobre o Projeto

A **Pokédex JC** é um aplicativo mobile/web desenvolvido em **Flutter** que permite gerenciar uma coleção personalizada de Pokémon. O aplicativo permite adicionar, visualizar e remover Pokémon com sincronização em tempo real com o Firebase.

## 🎯 Funcionalidades

- ✅ Listagem de Pokémon cadastrados
- ✅ Adicionar novos Pokémon (nome, nível, tipo, moves)
- ✅ Visualizar detalhes de cada Pokémon
- ✅ Remover Pokémon da coleção
- ✅ Sincronização em tempo real com Firebase
- ✅ Imagens oficiais via PokéAPI

## 🏗️ Estrutura do Projeto
📁 lib/
├── main.dart # Ponto de entrada
├── home_screen.dart # Tela principal (listagem)
├── pokemon_screen.dart # Tela de detalhes
├── pokemon.dart # Modelo Pokémon
└── firebase_options.dart # Configuração Firebase

text

## 🚀 Como Executar

### Pré-requisitos

- Flutter SDK (3.0+)
- Dart SDK
- Dispositivo/emulador ou navegador

### Passo a Passo

```bash
# 1. Clone o repositório
git clone https://github.com/Rnchx/pokedex-JC.git

# 2. Entre no diretório
cd pokedex-JC

# 3. Baixe as dependências
flutter pub get

# 4. Execute o projeto
flutter run

# Para rodar na web:
flutter run -d chrome

# Para rodar no Android:
flutter run -d android
Configuração do Firebase
O projeto já está configurado para a Web. Para dispositivos móveis:

Crie um projeto no Firebase Console

Adicione um aplicativo Android/iOS

Baixe o arquivo de configuração

Coloque na pasta android/app/ ou ios/Runner/

Execute flutterfire configure

📦 Dependências
yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^2.24.2
  cloud_firestore: ^4.14.0
🎨 Design System
Cores
Cor	Código	Uso
Azul Escuro	#15202E	AppBar, botões
Azul Médio	#1E3957	Detalhes
Azul Claro	#87A9C4	Background
Branco	#FFFFFF	Cards, formulários
Temas
Material 3

Cards com sombra

Gradientes

🗄️ Banco de Dados (Firestore)
Estrutura da Coleção pokemons
json
{
  "name": "Charizard",
  "spriteId": 6,
  "typeIds": [10, 3],
  "level": 36,
  "moves": ["Flamethrower", "Fly", "Dragon Claw", "Earthquake"]
}
Tipos de Pokémon
Tipo	ID	Cor	Emoji
Normal	1	#A8A77A	⚪
Fire	10	#EE8130	🔥
Water	11	#6390F0	💧
Grass	12	#7AC74C	🌿
Electric	13	#F7D02C	⚡
Fairy	18	#D685AD	✨
📸 Capturas de Tela
<div align="center"> <img src="screenshots/home.jpg" width="250" alt="Tela Principal"> <img src="screenshots/add.jpg" width="250" alt="Adicionar Pokémon"> <img src="screenshots/details.jpg" width="250" alt="Detalhes"> </div>
Adicione suas capturas de tela na pasta screenshots/

🔮 Melhorias Futuras
Editar Pokémon existentes

Filtrar por tipo

Buscar por nome

Sistema de evolução

Comparar Pokémon

Suporte para Android e iOS

Autenticação de usuários

👨‍💻 Desenvolvedor
Nome	Papel
João Pedro (Rnchx)	Desenvolvedor Full Stack
📚 Aprendizados
Flutter - Widgets, navegação, estados

Firebase - Cloud Firestore, CRUD em tempo real

Integração de APIs - PokéAPI

Design System - Temas, Material 3

Arquitetura - Separação de concerns

📄 Licença
Projeto desenvolvido para fins educacionais e de portfólio.

⭐ Como Contribuir
Fork o projeto

Crie uma branch (git checkout -b feature/nova-feature)

Commit (git commit -m 'Adiciona nova feature')

Push (git push origin feature/nova-feature)

Abra um Pull Request

Desenvolvido com Flutter e muita paixão por Pokémon ⚡🐾

text

## O que estava errado antes:

Os **blocos de código** (como o YAML e o JSON) não estavam fechados corretamente, o que fez o restante do texto ser "engolido" como se fizesse parte do código.

## Agora está correto:

- ✅ Código YAML do `pubspec.yaml` isolado
- ✅ JSON do Firestore isolado
- ✅ Tabelas formatadas corretamente
- ✅ Seções bem separadas
- ✅ Estrutura limpa e legível
