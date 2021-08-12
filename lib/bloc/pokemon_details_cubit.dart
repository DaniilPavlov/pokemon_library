import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon_library/data/pokemon_details.dart';
import 'package:pokemon_library/data/pokemon_info_response.dart';
import 'package:pokemon_library/data/pokemon_repository.dart';
import 'package:pokemon_library/data/pokemon_species_info.dart';

class PokemonDetailsCubit extends Cubit<PokemonDetails?> {
  final _pokemonRepository = PokemonRepository();

  PokemonDetailsCubit() : super(null);

  void getPokemonDetails(int pokemonId) async {
    ///future.wait позволяет работать запросам параллельно
    ///responses - list of objects, поэтому далее добавляем каст
    final responses = await Future.wait([
      _pokemonRepository.getPokemonInfo(pokemonId),
      _pokemonRepository.getPokemonSpeciesInfo(pokemonId)
    ]);

    final pokemonInfo = responses[0] as PokemonInfoResponse;
    final speciesInfo = responses[1] as PokemonSpeciesInfoResponse;

    emit(PokemonDetails(
        id: pokemonInfo.id,
        name: pokemonInfo.name,
        imageUrl: pokemonInfo.imageUrl,
        types: pokemonInfo.types,
        height: pokemonInfo.height,
        weight: pokemonInfo.weight,
        description: speciesInfo.description));
  }

  ///когда выходим из details
  void clearPokemonDetails() => emit(null);
}
