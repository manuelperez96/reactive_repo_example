import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_repo_example/domain/municipalities_repository.dart';
import 'package:reactive_repo_example/ui/app/add_municipality/add_municipality_screen.dart';
import 'package:reactive_repo_example/ui/home/bloc/home_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc(
        municipalitiesRepository: context.read<MunicipalitiesRepository>(),
      )..add(HomeSubscriptionRequest()),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Favorite Municipalities'),
      ),
      body: const _FavoriteCitiesListView(),
      floatingActionButton: const _AddMunicipalityFloatingActionButton(),
    );
  }
}

class _FavoriteCitiesListView extends StatelessWidget {
  const _FavoriteCitiesListView();

  @override
  Widget build(BuildContext context) {
    final favoriteMunicipalites = context.select(
      (HomeBloc bloc) => bloc.state.favoriteMunicipalities,
    );

    return ListView.builder(
      itemCount: favoriteMunicipalites.length,
      itemBuilder: (context, index) {
        final item = favoriteMunicipalites[index];
        return ListTile(
          title: Text(item.name),
          trailing: IconButton(
            onPressed: () => _removeFavorite(context, item.id),
            icon: const Icon(Icons.delete),
          ),
        );
      },
    );
  }

  void _removeFavorite(BuildContext context, String id) {
    context.read<HomeBloc>().add(HomeFavoriteRemoved(id: id));
  }
}

class _AddMunicipalityFloatingActionButton extends StatelessWidget {
  const _AddMunicipalityFloatingActionButton();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _navigateToAddMunicipalityScreen(context),
      child: const Icon(Icons.add),
    );
  }

  void _navigateToAddMunicipalityScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddMunicipalityScreen(),
      ),
    );
  }
}
