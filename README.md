# Desafio Flutter - Bus2

Este projeto é a solução para o Desafio Técnico - Desenvolvedor(a) Flutter proposto pela Bus2. O objetivo é criar um aplicativo que consome a API pública `randomuser.me` para exibir, salvar e gerenciar perfis de usuários aleatórios.

-----

## 📋 Sumário

  * [O Desafio](#-o-desafio)
  * [Funcionalidades Implementadas](#-funcionalidades-implementadas)
  * [Arquitetura e Decisões Técnicas](#-arquitetura-e-decisões-técnicas)
  * [Como Executar](#-como-executar)
  * [Estrutura de Pastas](#-estrutura-de-pastas)

-----

## 🚀 O Desafio

O objetivo principal é construir um aplicativo Flutter que exiba informações de pessoas consumidas da API `https://randomuser.me/api/`.

### Requisitos Obrigatórios

O desafio especificou um conjunto de regras técnicas que nortearam o desenvolvimento:

  * **Padrão de Arquitetura:** Uso obrigatório do padrão **MVVM** (Model-View-ViewModel).
  * **Padrão de Dados:** Implementação obrigatória da **Repository Strategy**.
  * **Programação:** Uso obrigatório de **Orientação a Objetos (OO)**.
  * **Parsing de Dados:** O JSON da API deve ser parseado para modelos Dart e, posteriormente, convertido para um modelo de persistência.
  * **Persistência:** O aplicativo deve persistir dados localmente (tecnologia de livre escolha).
  * **Atualização de Dados:** Utilização de `Ticker` (explicitamente **não** `Timer`) para realizar novas requisições à API.
  * **Gerenciamento de Estado:** Livre escolha do desenvolvedor (ex: GetX, Cubit, Bloc, Provider).

## ✨ Funcionalidades Implementadas

O aplicativo foi estruturado em três telas principais, conforme solicitado.

### 1\. Tela Inicial

  * **Busca Contínua:** Ao iniciar a tela, um `Ticker` é ativado e, a cada 5 segundos, uma nova requisição busca um usuário na API.
  * **Listagem de Sessão:** Os usuários buscados pelo `Ticker` são adicionados a uma lista de sessão exibida na tela.
  * **Navegação:**
      * Cada item da lista é clicável, levando à Tela de Detalhes do usuário.
      * Um botão com ícone de "Database" no `AppBar` redireciona para a Tela de Usuários Persistidos.

### 2\. Tela de Detalhes

  * **Exibição Completa:** Exibe **todas** as informações do usuário selecionado, consumindo o modelo de dados completo da API.
  * **Organização por Grupos:** As informações são organizadas em grupos (ex: "Contato", "Localização", "Pessoal"), conforme o modelo da API.
  * **Ação de Persistência:** Um botão permite "Salvar" ou "Remover" o usuário da persistência local (banco de dados).

### 3\. Tela de Usuários Persistidos

  * **Listagem do DB:** Exibe uma lista de todos os usuários que foram salvos no banco de dados local.
  * **Ações na Lista:**
      * Permite acessar os detalhes de cada usuário salvo.
      * Permite remover o usuário da persistência diretamente pela lista.
  * **Atualização de Estado:** Ao retornar da tela de detalhes ou após uma remoção, a lista é atualizada automaticamente.

## 🛠️ Arquitetura e Decisões Técnicas

Para atender aos requisitos obrigatórios e criar um app robusto, as seguintes decisões foram tomadas:

  * **Arquitetura:** **MVVM + Repository**

      * **Model:** Modelos Dart puros que representam a resposta da API (ex: `User`, `Location`, `Name`) e os modelos de persistência.
      * **View:** Widgets (Telas) responsáveis apenas por exibir a UI e reagir a mudanças de estado.
      * **ViewModel:** (Usando **Provider** com `ChangeNotifier`) Contém a lógica de negócios, o estado da tela e a comunicação com o Repositório.
      * **Repository:** `UserRepositoryImpl` implementa a `Repository Strategy`, abstraindo as fontes de dados (`ApiDataSource` e `LocalDataSource`).

  * **Stack Tecnológica:**

      * **Gerenciamento de Estado:** `provider` (escolhido por ser leve e se adequar bem ao MVVM com `ChangeNotifier`).
      * **Requisições API:** `dio` (para chamadas de rede robustas e tratamento de erros).
      * **Persistência:** `hive` (escolhido por ser um banco de dados NoSQL rápido, leve e nativo em Dart, facilitando o armazenamento dos modelos OO).
      * **Design:** `google_fonts` (para uma tipografia mais sofisticada).

  * **`Ticker` vs `Timer`:**

      * O requisito de usar `Ticker` foi implementado na `HomeScreen` utilizando um `TickerProviderStateMixin`. O `Ticker` é mais eficiente que um `Timer` para animações ou atualizações de UI, pois ele se sincroniza com o *pipeline* de renderização do Flutter (vsync), evitando trabalho desnecessário quando a tela não está visível.

## 🚀 Como Executar

1.  **Clone o repositório:**

    ```bash
    git clone https://github.com/seu-usuario/bus2-flutter-challenge.git
    cd bus2-flutter-challenge
    ```

2.  **Instale as dependências:**

    ```bash
    flutter pub get
    ```

3.  **Execute o gerador de código (se usar Hive/Drift/Freezed):**
    *(Se estiver usando Hive, como sugerido)*

    ```bash
    flutter pub run build_runner build
    ```

4.  **Execute o aplicativo:**

    ```bash
    flutter run
    ```

## 📁 Estrutura de Pastas

O projeto segue uma estrutura de *feature-first*, separando as camadas de MVVM dentro de cada funcionalidade.

```
lib/
├── core/
│   ├── theme/
│   │   └── app_theme.dart      # Design System (Cores, Fontes, Tema)
│   └── utils/                  # Classes utilitárias
│
├── features/
│   ├── home/
│   │   ├── view/
│   │   │   └── home_screen.dart
│   │   └── viewmodel/
│   │       └── home_viewmodel.dart
│   │
│   ├── details/
│   │   ├── view/
│   │   │   └── details_screen.dart
│   │   └── viewmodel/
│   │       └── details_viewmodel.dart
│   Note: This structure is based on the provided PDF and general best practices.
│   ├── persisted/
│   │   ├── view/
│   │   │   └── persisted_screen.dart
│   │   └── viewmodel/
│   │       └── persisted_viewmodel.dart
│   │
│   └── user/                   # Feature "Cross" (compartilhada)
│       ├── model/
│       │   └── user_model.dart # Modelos OO (User, Name, Location...)
│       └── repository/
│           ├── datasource/
│           │   ├── user_api_data_source.dart
│           │   └── user_local_data_source.dart
│           ├── user_repository.dart        # Interface (Abstração)
│           └── user_repository_impl.dart   # Implementação
│
├── main.dart                   # Ponto de entrada
└── ...
```
