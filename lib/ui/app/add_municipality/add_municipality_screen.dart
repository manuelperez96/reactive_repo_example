import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_repo_example/domain/municipalities_repository.dart';
import 'package:reactive_repo_example/ui/app/add_municipality/bloc/add_municipality_bloc.dart';

class AddMunicipalityScreen extends StatelessWidget {
  const AddMunicipalityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddMunicipalityBloc(
        municipalitiesRepository: context.read<MunicipalitiesRepository>(),
      )..add(AddMunicipalityListLoaded()),
      child: const AddMunicipalityView(),
    );
  }
}

class AddMunicipalityView extends StatelessWidget {
  const AddMunicipalityView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Municipality'),
      ),
      body: const _NoFavoriteListView(),
    );
  }
}

class _NoFavoriteListView extends StatelessWidget {
  const _NoFavoriteListView();

  @override
  Widget build(BuildContext context) {
    final noFavoriteMunicipalites = context.select(
      (AddMunicipalityBloc bloc) => bloc.state.noFavoriteMunicipality,
    );

    return ListView.builder(
      itemCount: noFavoriteMunicipalites.length,
      itemBuilder: (context, index) {
        final item = noFavoriteMunicipalites[index];
        return ListTile(
          title: Text(item.name),
          onTap: () => _addToFavorite(context, item.id),
        );
      },
    );
  }

  void _addToFavorite(BuildContext context, String id) {
    context
        .read<AddMunicipalityBloc>()
        .add(AddMunicipalityMunicipalitySelected(id: id));
    Navigator.pop(context);
  }
}
