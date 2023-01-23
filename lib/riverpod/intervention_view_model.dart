import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_riverpod_showcase/intervention.dart';
import 'package:new_riverpod_showcase/intervention_api.dart';
import 'package:new_riverpod_showcase/riverpod/state/toggle_button_state.dart';

final interventionProvider = ChangeNotifierProvider<InterventionViewModel>((_) => InterventionViewModel());

class InterventionViewModel extends ChangeNotifier {
  final InterventionApi _api = InterventionApi();
  Map<Intervention, ToggleButtonState> _interventionButtonStateMap = {};
  AsyncValue<List<Intervention>> _interventions = const AsyncValue.loading();

  InterventionViewModel() {
    getAllInterventions();
  }

  AsyncValue<List<Intervention>> get interventions => _interventions;

  ToggleButtonState getButtonState(final Intervention intervention) =>
      _interventionButtonStateMap[intervention] ?? const ToggleButtonState.set(false);

  Future<void> getAllInterventions() async {
    _interventions = await AsyncValue.guard(_api.getInterventions);
    _interventionButtonStateMap = {
      for (var intervention in _interventions.value!) intervention: ToggleButtonState.set(intervention.isFavorite)
    };
    notifyListeners();
  }

  Future<void> toggleFavorite(final Intervention intervention, final bool isFavorite) async {
    _interventionButtonStateMap = {..._interventionButtonStateMap, intervention: const ToggleButtonState.loading()};
    notifyListeners();

    await _api.toggleFavorite(isFavorite);
    _interventionButtonStateMap = {..._interventionButtonStateMap, intervention: ToggleButtonState.set(isFavorite)};
    notifyListeners();
  }
}
