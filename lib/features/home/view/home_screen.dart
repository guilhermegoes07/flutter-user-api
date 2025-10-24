import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:pessoas/core/theme/app_theme.dart';
import 'package:pessoas/features/details/view/details_screen.dart';
import 'package:pessoas/features/home/viewmodel/home_view_model.dart';
import 'package:pessoas/features/persisted/view/persisted_screen.dart';
import 'package:pessoas/features/user/model/user_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late final HomeViewModel _viewModel;
  bool _tickerInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_tickerInitialized) {
      _viewModel = context.read<HomeViewModel>();
      _tickerInitialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        unawaited(_viewModel.startTicker(this));
      });
    }
  }

  @override
  void dispose() {
    _viewModel.disposeTicker();
    super.dispose();
  }

  void _openPersistedUsers() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const PersistedScreen()),
    );
  }

  void _openDetails(User user) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => DetailsScreen(user: user)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explorar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.storage_rounded, color: AppTheme.primaryColor),
            onPressed: _openPersistedUsers,
            tooltip: 'Usuários salvos',
          ),
        ],
      ),
      body: SafeArea(
        child: Consumer<HomeViewModel>(
          builder: (context, viewModel, _) {
            if (viewModel.isLoading && viewModel.sessionUserList.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (viewModel.errorMessage != null && viewModel.sessionUserList.isEmpty) {
              return _ErrorPlaceholder(
                message: viewModel.errorMessage!,
                onRetry: viewModel.manualRefresh,
              );
            }

            final users = viewModel.sessionUserList;
            return RefreshIndicator(
              onRefresh: viewModel.manualRefresh,
              child: users.isEmpty
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const [
                        SizedBox(height: 120),
                        Center(child: Text('Nenhum usuário carregado ainda.')),
                      ],
                    )
                  : ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: users.length,
                      separatorBuilder: (_, __) => const Divider(height: 0),
                      itemBuilder: (context, index) {
                        final user = users[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(user.picture.thumbnail),
                          ),
                          title: Text('${user.name.first} ${user.name.last}'),
                          subtitle: Text(user.email),
                          onTap: () => _openDetails(user),
                        );
                      },
                    ),
            );
          },
        ),
      ),
    );
  }
}

class _ErrorPlaceholder extends StatelessWidget {
  const _ErrorPlaceholder({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }
}
