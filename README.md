# Desafio Flutter - Bus2

[cite\_start]Este projeto é a solução para o [Desafio Técnico - Desenvolvedor(a) Flutter](#) proposto pela Bus2[cite: 2]. [cite\_start]O objetivo é criar um aplicativo que consome a API pública `randomuser.me` [cite: 4, 6] para exibir, salvar e gerenciar perfis de usuários aleatórios.

-----

## 📋 Sumário

  * [O Desafio](#-o-desafio)
  * [Funcionalidades Implementadas](#-funcionalidades-implementadas)
  * [Arquitetura e Decisões Técnicas](#-arquitetura-e-decisões-técnicas)
  * [Como Executar](#-como-executar)
  * [Estrutura de Pastas](#-estrutura-de-pastas)

-----

## 🚀 O Desafio

[cite\_start]O objetivo principal é construir um aplicativo Flutter que exiba informações de pessoas consumidas da API `https://randomuser.me/api/`[cite: 4, 6].

### Requisitos Obrigatórios

[cite\_start]O desafio especificou um conjunto de regras técnicas que nortearam o desenvolvimento[cite: 35]:

  * [cite\_start]**Padrão de Arquitetura:** Uso obrigatório do padrão **MVVM** (Model-View-ViewModel)[cite: 12, 40].
  * [cite\_start]**Padrão de Dados:** Implementação obrigatória da **Repository Strategy**[cite: 12, 42].
  * [cite\_start]**Programação:** Uso obrigatório de **Orientação a Objetos (OO)**[cite: 10, 37].
  * [cite\_start]**Parsing de Dados:** O JSON da API deve ser parseado para modelos Dart [cite: 11, 38] [cite\_start]e, posteriormente, convertido para um modelo de persistência[cite: 11].
  * [cite\_start]**Persistência:** O aplicativo deve persistir dados localmente (tecnologia de livre escolha)[cite: 8, 41].
  * [cite\_start]**Atualização de Dados:** Utilização de `Ticker` (explicitamente **não** `Timer`) para realizar novas requisições à API[cite: 20, 44].
  * [cite\_start]**Gerenciamento de Estado:** Livre escolha do desenvolvedor (ex: GetX, Cubit, Bloc, Provider)[cite: 13, 43].

## ✨ Funcionalidades Implementadas

[cite\_start]O aplicativo foi estruturado em três telas principais, conforme solicitado[cite: 17].

### 1\. Tela Inicial

  * [cite\_start]**Busca Contínua:** Ao iniciar a tela, um `Ticker` é ativado e, a cada 5 segundos, uma nova requisição busca um usuário na API[cite: 20].
  * [cite\_start]**Listagem de Sessão:** Os usuários buscados pelo `Ticker` são adicionados a uma lista de sessão exibida na tela[cite: 21].
  * **Navegação:**
      * [cite\_start]Cada item da lista é clicável, levando à Tela de Detalhes do usuário[cite: 22].
      * [cite\_start]Um botão com ícone de "Database" no `AppBar` redireciona para a Tela de Usuários Persistidos[cite: 23].

### 2\. Tela de Detalhes

  * [cite\_start]**Exibição Completa:** Exibe **todas** as informações do usuário selecionado, consumindo o modelo de dados completo da API[cite: 25].
  * [cite\_start]**Organização por Grupos:** As informações são organizadas em grupos (ex: "Contato", "Localização", "Pessoal"), conforme o modelo da API[cite: 26].
  * [cite\_start]**Ação de Persistência:** Um botão permite "Salvar" ou "Remover" o usuário da persistência local (banco de dados)[cite: 27].

### 3\. Tela de Usuários Persistidos

  * [cite\_start]**Listagem do DB:** Exibe uma lista de todos os usuários que foram salvos no banco de dados local[cite: 30].
  * **Ações na Lista:**
      * [cite\_start]Permite acessar os detalhes de cada usuário salvo[cite: 31].
      * [cite\_start]Permite remover o usuário da persistência diretamente pela lista[cite: 32].
  * [cite\_start]**Atualização de Estado:** Ao retornar da tela de detalhes ou após uma remoção, a lista é atualizada automaticamente[cite: 33].

## 🛠️ Arquitetura e Decisões Técnicas

Para atender aos requisitos obrigatórios e criar um app robusto, as seguintes decisões foram tomadas:

  * **Arquitetura:** **MVVM + Repository**

      * **Model:** Modelos Dart puros que representam a resposta da API (ex: `User`, `Location`, `Name`) e os modelos de persistência.
      * **View:** Widgets (Telas) responsáveis apenas por exibir a UI e reagir a mudanças de estado.
      * **ViewModel:** (Usando **Provider** com `ChangeNotifier`) Contém a lógica de negócios, o estado da tela e a comunicação com o Repositório.
      * [cite\_start]**Repository:** `UserRepositoryImpl` implementa a `Repository Strategy`[cite: 12, 42], abstraindo as fontes de dados (`ApiDataSource` e `LocalDataSource`).

  * **Stack Tecnológica:**

      * **Gerenciamento de Estado:** `provider` (escolhido por ser leve e se adequar bem ao MVVM com `ChangeNotifier`).
      * **Requisições API:** `dio` (para chamadas de rede robustas e tratamento de erros).
      * **Persistência:** `hive` (escolhido por ser um banco de dados NoSQL rápido, leve e nativo em Dart, facilitando o armazenamento dos modelos OO).
      * **Design:** `google_fonts` (para uma tipografia mais sofisticada).

  * **`Ticker` vs `Timer`:**

      * [cite\_start]O requisito de usar `Ticker` [cite: 44] foi implementado na `HomeScreen` utilizando um `TickerProviderStateMixin`. O `Ticker` é mais eficiente que um `Timer` para animações ou atualizações de UI, pois ele se sincroniza com o *pipeline* de renderização do Flutter (vsync), evitando trabalho desnecessário quando a tela não está visível.

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
│   │
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
