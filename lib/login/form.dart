import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:new_riverpod_showcase/login/hooks/async_callback_hook.dart';
import 'package:new_riverpod_showcase/login/login/user_provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

class FormScreen extends HookConsumerWidget {
  const FormScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formGroup = useRef(
      FormGroup({
        'username': FormControl<String>(),
        'password': FormControl<String>(
          validators: [
            Validators.required,
            Validators.minLength(8),
          ],
          value: '',
        ),
      }),
    ).value;

    final loginState = useState<AsyncValue?>(null);

    print('LOGIN STATE: ${loginState.value}');

    final handleLogin = useAsyncCallback(
      () async {
        formGroup.markAllAsTouched();
        if (formGroup.valid) {
          await ref.read(userProvider.notifier).login(
                username: formGroup.control('username').value,
                password: formGroup.control('password').value,
              );
        } else {
          throw Exception('Error');
        }
      },
      stateValue: loginState,
      keys: [formGroup, formGroup.valid],
    );

    useValueChanged<AsyncValue?, void>(loginState.value, (oldValue, _) {
      if (loginState.value is AsyncData) {
        //push to main screen
      } else if (loginState.value is AsyncError) {
        print('Dialog shown');
      }
    });

    useStream(formGroup.statusChanged);
    formGroup.valid;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: ReactiveForm(
            formGroup: formGroup,
            child: Column(
              children: [
                ReactiveTextField(formControlName: 'username'),
                ReactiveTextField(
                  formControlName: 'password',
                  obscureText: true,
                  validationMessages: {'minLength': (error) => 'Password should be at least 8 chars long.'},
                ),
                loginState.value?.when(
                      data: (_) => Text('Success'),
                      error: (error, _) => ElevatedButton(
                      onPressed: handleLogin,
                      child: Text('Login'),
                    ),
                      loading: () => const CircularProgressIndicator.adaptive(),
                    ) ??
                    ElevatedButton(
                      onPressed: handleLogin,
                      child: Text('Login'),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
