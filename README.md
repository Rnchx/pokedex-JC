# 🐾 Pokédex JC

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Cloud%20Firestore-orange.svg)](https://firebase.google.com)
[![Dart](https://img.shields.io/badge/Dart-3.0+-teal.svg)](https://dart.dev)

---

# 📱 Sobre o Projeto

A **Pokédex JC** é um aplicativo mobile/web desenvolvido em **Flutter** com integração ao **Firebase Firestore**, permitindo criar e gerenciar uma coleção personalizada de Pokémon.

O projeto foi desenvolvido com foco em:

- Interface moderna
- Experiência visual inspirada em Pokédex
- Sincronização em tempo real
- Organização de dados no Firebase
- Aprendizado prático de Flutter + Firebase

---

# ✨ Funcionalidades

## 🐉 Pokémon

- ✅ Listagem dinâmica de Pokémon
- ✅ Adicionar novos Pokémon
- ✅ Visualizar detalhes completos
- ✅ Remover Pokémon da coleção
- ✅ Cards estilizados por tipo
- ✅ Exibição de sprites oficiais
- ✅ Níveis personalizados
- ✅ Tipos com cores e emojis

---

## 👤 Perfil do Treinador

- ✅ Tela de perfil do treinador
- ✅ Escolha de avatar
- ✅ Nome personalizado
- ✅ Card do treinador na Home
- ✅ Salvamento no Firebase

---

## 🔥 Firebase

- ✅ Cloud Firestore
- ✅ Sincronização em tempo real
- ✅ CRUD completo
- ✅ Estrutura organizada por coleções

---

# 🏗️ Estrutura do Projeto

```text
📁 lib/
├── main.dart
├── home_screen.dart
├── pokemon_screen.dart
├── new_pokemon_screen.dart
├── trainer_profile_screen.dart
├── pokemon.dart
└── firebase_options.dart
```

# 🚀 Como Executar

📋 Pré-requisitos
Flutter SDK 3.0+
Dart SDK
Android Studio / VSCode
Chrome ou Emulador Android

## ⚙️ Instalação

# Clone o repositório
git clone https://github.com/Rnchx/pokedex-JC.git

# Entre na pasta
cd pokedex-JC

# Instale as dependências
flutter pub get

# ▶️ Executando o Projeto
Web
flutter run -d chrome
Android
flutter run -d android
Desktop
flutter run -d windows
🔥 Configuração do Firebase

O projeto já possui configuração Firebase para Web.

Para Android/iOS:

# 1️⃣ Crie um projeto no Firebase

Acesse:

https://console.firebase.google.com/

# 2️⃣ Ative o Cloud Firestore
Vá em Firestore Database
Clique em “Criar banco”
Escolha modo de teste
# 3️⃣ Configure o FlutterFire
dart pub global activate flutterfire_cli

Depois:

flutterfire configure

📦 Dependências Principais
dependencies:
  flutter:
    sdk: flutter

  firebase_core: ^2.24.2
  cloud_firestore: ^4.14.0

🎨 Design System
🎨 Paleta de Cores
Cor	Código	Uso
Azul Escuro	#15202E	Botões/AppBar
Azul Médio	#1E3957	Destaques
Azul Claro	#87A9C4	Background
Branco	#FFFFFF	Cards

🧩 Estilo Visual
Material 3
Cards arredondados
Sombras suaves
Gradientes
Layout responsivo
Interface inspirada em Pokédex

🗄️ Banco de Dados (Firestore)

📁 Coleção: pokemons
{
  "name": "Charizard",
  "spriteUrl": "https://...",
  "types": ["Fire", "Flying"],
  "level": 36
}

📁 Coleção: config
Documento: treinador
{
  "name": "João",
  "avatarIndex": 2
}

# ⚡ Tipos de Pokémon
Tipo	Emoji	Cor
Normal	⚪	#A8A77A
Fire	🔥	#EE8130
Water	💧	#6390F0
Grass	🌿	#7AC74C
Electric	⚡	#F7D02C
Fairy	✨	#D685AD

# 📸 Capturas de Tela
📁 screenshots/
├── home.png
├── details.png
├── add.png
└── trainer.png

Você pode adicionar imagens do projeto na pasta screenshots/.




# 👨‍💻 Desenvolvedor
Nome	Função
João Pedro Rocha (Rnchx)	Desenvolvedor Full Stack