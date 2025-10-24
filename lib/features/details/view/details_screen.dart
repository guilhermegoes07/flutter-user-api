import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:pessoas/core/theme/app_theme.dart';
import 'package:pessoas/core/utils/date_formatter.dart';
import 'package:pessoas/features/details/viewmodel/details_view_model.dart';
import 'package:pessoas/features/user/model/user_model.dart';
import 'package:pessoas/features/user/repository/user_repository.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DetailsViewModel>(
      create: (context) {
        final viewModel = DetailsViewModel(context.read<UserRepository>());
        unawaited(viewModel.loadUser(user));
        return viewModel;
      },
      child: const _DetailsView(),
    );
  }
}

class _DetailsView extends StatelessWidget {
  const _DetailsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes')),
      body: SafeArea(
        child: Consumer<DetailsViewModel>(
          builder: (context, viewModel, _) {
            final user = viewModel.selectedUser;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _Header(user: user),
                  const SizedBox(height: 24),
                  if (viewModel.errorMessage != null)
                    _ErrorBanner(message: viewModel.errorMessage!),
                  ElevatedButton(
                    onPressed: viewModel.isProcessing ? null : viewModel.togglePersistence,
                    child: Text(viewModel.isPersisted ? 'Remover' : 'Salvar'),
                  ),
                  const SizedBox(height: 16),
                  _InfoCard(
                    title: 'Contato',
                    icon: Icons.phone_android,
                    children: [
                      _InfoRow(label: 'E-mail', value: user.email),
                      _InfoRow(label: 'Telefone', value: user.phone),
                      _InfoRow(label: 'Celular', value: user.cell),
                    ],
                  ),
                  _InfoCard(
                    title: 'Endereço',
                    icon: Icons.location_on_outlined,
                    children: [
                      _InfoRow(
                        label: 'Rua',
                        value: '${user.location.street.name}, ${user.location.street.number}',
                      ),
                      _InfoRow(
                        label: 'Cidade/Estado',
                        value: '${user.location.city} / ${user.location.state}',
                      ),
                      _InfoRow(label: 'País', value: user.location.country),
                      _InfoRow(label: 'CEP', value: user.location.postcode),
                    ],
                  ),
                  _InfoCard(
                    title: 'Pessoal',
                    icon: Icons.person_outline,
                    children: [
                      _InfoRow(
                        label: 'Nascimento',
                        value: '${DateFormatter.formatDateTime(user.dob.date)} (${user.dob.age} anos)',
                      ),
                      _InfoRow(label: 'Gênero', value: user.gender),
                      _InfoRow(label: 'Nacionalidade', value: user.nat),
                    ],
                  ),
                  _InfoCard(
                    title: 'Registro',
                    icon: Icons.app_registration,
                    children: [
                      _InfoRow(
                        label: 'Registrado em',
                        value: '${DateFormatter.formatDateTime(user.registered.date)} (${user.registered.age} anos)',
                      ),
                      _InfoRow(label: 'Documento', value: user.id.name),
                      _InfoRow(label: 'Número', value: user.id.value.isEmpty ? 'N/A' : user.id.value),
                    ],
                  ),
                  _InfoCard(
                    title: 'Geolocalização',
                    icon: Icons.explore_outlined,
                    children: [
                      _InfoRow(
                        label: 'Latitude/Longitude',
                        value: '${user.location.coordinates.latitude}, ${user.location.coordinates.longitude}',
                      ),
                      _InfoRow(
                        label: 'Fuso horário',
                        value: '${user.location.timezone.offset} (${user.location.timezone.description})',
                      ),
                    ],
                  ),
                  _InfoCard(
                    title: 'Dados de Acesso',
                    icon: Icons.security,
                    isInitiallyExpanded: false,
                    children: [
                      _SelectableInfoRow(label: 'UUID', value: user.login.uuid),
                      _SelectableInfoRow(label: 'Usuário', value: user.login.username),
                      _SelectableInfoRow(label: 'Senha', value: user.login.password),
                      _SelectableInfoRow(label: 'Salt', value: user.login.salt),
                      _SelectableInfoRow(label: 'MD5', value: user.login.md5),
                      _SelectableInfoRow(label: 'SHA1', value: user.login.sha1),
                      _SelectableInfoRow(label: 'SHA256', value: user.login.sha256),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(user.picture.large),
          radius: 60,
        ),
        const SizedBox(height: 16),
        Text(
          '${user.name.title}. ${user.name.first} ${user.name.last}',
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          '@${user.login.username}',
          style: textTheme.bodyMedium?.copyWith(color: AppTheme.textColor.withOpacity(0.7)),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.icon,
    required this.children,
    this.isInitiallyExpanded = true,
  });

  final String title;
  final IconData icon;
  final List<Widget> children;
  final bool isInitiallyExpanded;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        initiallyExpanded: isInitiallyExpanded,
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        leading: Icon(icon, color: AppTheme.primaryColor),
        childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: children,
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value.isEmpty ? 'N/A' : value),
          ),
        ],
      ),
    );
  }
}

class _SelectableInfoRow extends StatelessWidget {
  const _SelectableInfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          SelectableText(value.isEmpty ? 'N/A' : value),
        ],
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.redAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.redAccent.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.redAccent),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
