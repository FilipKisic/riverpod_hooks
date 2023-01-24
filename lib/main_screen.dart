import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:new_riverpod_showcase/intervention.dart';
import 'package:new_riverpod_showcase/riverpod/intervention_view_model.dart';

class MainScreen extends HookConsumerWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final interventions = ref.watch(interventionProvider.select((value) => value.interventions));
    final handleRefresh = useCallback(ref.read(interventionProvider).getAllInterventions, []);
    useEffect(
      () {
        Future.microtask(handleRefresh); //if rebuild is called to quickly, should wrap to microtask to push function to the bottom of the stack
        return null;
      },
      [handleRefresh], //depends on it because if there is any change, this should be called
    );
    return Scaffold(
      appBar: AppBar(title: const Text('Riverpod')),
      body: SafeArea(
        child: interventions.when(
          loading: () => const Center(child: CircularProgressIndicator.adaptive()),
          error: (_, stackTrace) => Center(child: Text(stackTrace.toString())),
          data: (interventionList) => ListView.separated(
            itemCount: interventionList.length,
            separatorBuilder: (_, index) => const Divider(color: Colors.grey, thickness: 2),
            itemBuilder: (_, index) => Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Text('Intervention-${interventionList[index].id.toString()}'),
                  const Spacer(),
                  _FavoriteInterventionButton(intervention: interventionList[index]),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FavoriteInterventionButton extends HookConsumerWidget {
  final Intervention intervention;

  const _FavoriteInterventionButton({Key? key, required this.intervention}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buttonState = ref.watch(interventionProvider.select((value) => value.getButtonState(intervention)));

    final handleToggleFavorite = useCallback(
      (isFavorite) => ref.read(interventionProvider).toggleFavorite(intervention, !isFavorite),
      [intervention],
    );

    return buttonState.when(
      loading: () => const SizedBox(height: 48, width: 48, child: CircularProgressIndicator.adaptive()),
      set: (isFavorite) => IconButton(
        onPressed: () => handleToggleFavorite(isFavorite),
        icon: isFavorite ? const Icon(Icons.favorite_rounded) : const Icon(Icons.favorite_border_rounded),
      ),
    );
  }
}
