import 'package:freezed_annotation/freezed_annotation.dart';

part 'toggle_button_state.freezed.dart';

@freezed
class ToggleButtonState with _$ToggleButtonState {
  const factory ToggleButtonState.loading() = _Loading;
  const factory ToggleButtonState.set(bool isFavorite) = _Set;
}