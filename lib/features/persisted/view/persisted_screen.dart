import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:pessoas/features/details/view/details_screen.dart';
import 'package:pessoas/features/persisted/viewmodel/persisted_view_model.dart';
import 'package:pessoas/features/user/model/user_model.dart';

class PersistedScreen extends StatefulWidget {
  const PersistedScreen({super.key});

  @override
  State<PersistedScreen> createState() => _PersistedScreenState();
}

class _PersistedScreenState extends State<PersistedScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PersistedViewModel>().fetchPersistedUsers();
    });
  }

  Future<void> _openDetails(User user) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => DetailsScreen(user: user)),
    );
    await context.read<PersistedViewModel>().fetchPersistedUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Usuários Salvos')),
      body: SafeArea(
        child: Consumer<PersistedViewModel>(
          builder: (context, viewModel, _) {
            if (viewModel.isLoading && viewModel.persistedUserList.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (viewModel.errorMessage != null && viewModel.persistedUserList.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    viewModel.errorMessage!,
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            final users = viewModel.persistedUserList;
            if (users.isEmpty) {
              return const Center(child: Text('Nenhum usuário salvo até o momento.'));
            }

            return ListView.separated(
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
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_sweep_rounded, color: Colors.redAccent),
                    onPressed: () async {
                      final persistedViewModel = context.read<PersistedViewModel>();
                      await persistedViewModel.removeUser(user);
                      if (mounted && persistedViewModel.errorMessage == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Usuário removido da lista.')),
                        );
                      }
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
