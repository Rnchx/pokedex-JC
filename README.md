# 🐾 Pokédex JC

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Cloud%20Firestore-orange.svg)](https://firebase.google.com)
[![Dart](https://img.shields.io/badge/Dart-3.0+-teal.svg)](https://dart.dev)
[![Plataforma](https://img.shields.io/badge/Plataforma-Web%20|%20Mobile-brightgreen.svg)]()

## 📱 Sobre o Projeto

A **Pokédex JC** é um aplicativo mobile/web desenvolvido em **Flutter** que permite gerenciar uma coleção personalizada de Pokémon. Diferente de uma Pokédex tradicional, este aplicativo permite que o usuário **adicione, edite e remova** seus próprios Pokémon, criando uma experiência de gerenciamento de equipe única.

### 🎯 Funcionalidades Principais

- ✅ **Listagem de Pokémon** - Visualize todos os Pokémon cadastrados
- ✅ **Adicionar Pokémon** - Cadastre novos Pokémon com nome, nível, tipo e moves
- ✅ **Detalhes do Pokémon** - Visualize informações completas de cada Pokémon
- ✅ **Remover Pokémon** - Delete Pokémon da sua coleção
- ✅ **Sincronização em Tempo Real** - Dados sincronizados com o Firebase Cloud Firestore
- ✅ **Design Temático** - Interface inspirada no universo Pokémon

## 🏗️ Arquitetura do Projeto
📁 lib/
├── main.dart # Ponto de entrada e configuração do app
├── home_screen.dart # Tela principal (listagem de Pokémon)
├── pokemon_screen.dart # Tela de detalhes do Pokémon
├── pokemon.dart # Modelo de dados Pokémon
└── firebase_options.dart # Configuração do Firebase

text

## 🚀 Tecnologias Utilizadas

| Tecnologia | Finalidade |
|------------|------------|
| **Flutter** | Framework para desenvolvimento multiplataforma |
| **Dart** | Linguagem de programação |
| **Firebase Cloud Firestore** | Banco de dados em tempo real |
| **Firebase Core** | Inicialização e configuração do Firebase |
| **PokéAPI (Sprite)** | Imagens oficiais dos Pokémon |

## 📦 Estrutura de Dados

### Pokémon

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `name` | String | Nome do Pokémon |
| `spriteId` | int | ID para buscar a imagem oficial |
| `typeIds` | List<int> | IDs dos tipos (ex: 10 = Fire) |
| `level` | int | Nível do Pokémon |
| `moves` | List<String> | Lista de golpes/movimentos |

### Tipos de Pokémon Suportados

| Tipo | ID | Cor | Emoji |
|------|-----|-----|-------|
| Normal | 1 | #A8A77A | ⚪ |
| Fire | 10 | #EE8130 | 🔥 |
| Water | 11 | #6390F0 | 💧 |
| Grass | 12 | #7AC74C | 🌿 |
| Electric | 13 | #F7D02C | ⚡ |
| Fairy | 18 | #D685AD | ✨ |

## 🖼️ Funcionalidades em Detalhe

### 1. Tela Principal (HomeScreen)

- Lista todos os Pokémon cadastrados
- Cada Pokémon exibe:
  - Imagem oficial (via PokéAPI)
  - Nome
  - Nível
  - Tipos (com cores e emojis)
- Botão para adicionar novo Pokémon
- Botão para deletar Pokémon
- Sincronização em tempo real com Firebase

### 2. Adicionar Pokémon

Formulário com campos:
- **Nome** - Nome do Pokémon
- **Sprite ID** - ID para buscar a imagem oficial
- **Level** - Nível (1-100)
- **Tipo** - Seleção do tipo principal
- **Moves** - Movimentos separados por vírgula

### 3. Tela de Detalhes (PokemonScreen)

- Exibe informações completas do Pokémon
- Visualização ampliada da imagem
- Lista de movimentos/golpes
- (Em desenvolvimento - estrutura preparada)

## 🔧 Como Executar o Projeto

### Pré-requisitos

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (versão 3.0+)
- [Dart SDK](https://dart.dev/get-dart)
- Dispositivo físico ou emulador (Android/iOS)
- Navegador para testar versão web

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

# Para rodar especificamente na web:
flutter run -d chrome

# Para rodar no Android:
flutter run -d android
Configuração do Firebase
O projeto já está configurado com o Firebase para a plataforma Web. Para rodar em dispositivos móveis:

Crie um projeto no Firebase Console

Adicione um aplicativo Android/iOS

Baixe o arquivo de configuração (google-services.json ou GoogleService-Info.plist)

Coloque o arquivo na pasta android/app/ ou ios/Runner/

Execute flutterfire configure para gerar novas configurações

📦 Dependências Principais
yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^2.24.2
  cloud_firestore: ^4.14.0
🎨 Design System
Cores
Cor	Código	Uso
Azul Escuro	#15202E	AppBar, botões principais
Azul Médio	#1E3957	Detalhes, elementos secundários
Azul Claro	#87A9C4	Background principal
Branco	#FFFFFF	Cards, formulários
Temas
Material 3 - Design moderno e responsivo

Cards com sombra - Profundidade e hierarquia visual

Gradientes - Fundos com degradê para maior imersão

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
📸 Capturas de Tela
Adicione aqui imagens do aplicativo rodando

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
📚 O que Aprendi
Com este projeto, foi possível consolidar conhecimentos em:

Flutter - Widgets, navegação, estados

Firebase - Cloud Firestore, operações CRUD em tempo real

Integração de APIs - PokéAPI para sprites oficiais

Design System - Temas, cores, Material 3

Arquitetura - Separação de concerns (models, screens, services)

📄 Licença
Este projeto foi desenvolvido para fins educacionais e de portfólio.

⭐ Como Contribuir
Faça um Fork do projeto

Crie uma branch (git checkout -b feature/nova-feature)

Commit suas mudanças (git commit -m 'Adiciona nova feature')

Push para a branch (git push origin feature/nova-feature)

Abra um Pull Request

Desenvolvido com Flutter e muita paixão por Pokémon ⚡🐾

text

## 📝 Como adicionar no GitHub:

1. Acesse seu repositório: `https://github.com/Rnchx/pokedex-JC`
2. Clique em **"Add file"** > **"Create new file"**
3. Nomeie como `README.md`
4. Copie e cole o conteúdo acima
5. Role para baixo e clique em **"Commit changes"**

## 🎨 Dica extra:

Se quiser, pode adicionar **capturas de tela** do aplicativo. Crie uma pasta `screenshots/` no repositório e adicione as imagens. Depois no README, descomente a seção:

```markdown
## 📸 Capturas de Tela

<div align="center">
  <img src="screenshots/home.jpg" width="250" alt="Tela Principal">
  <img src="screenshots/add.jpg" width="250" alt="Adicionar Pokémon">
  <img src="screenshots/details.jpg" width="250" alt="Detalhes">
</div>
