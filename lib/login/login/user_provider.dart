import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:new_riverpod_showcase/login/api/api.dart';

final userProvider = StateNotifierProvider<UserProvider, AsyncValue<User>>(
  (ref) => UserProvider(),
);

class UserProvider extends StateNotifier<AsyncValue<User>> {
  UserProvider() : super(const AsyncValue.loading());

  Future<void> login({
    required final String username,
    required final String password,
  }) async {
    await LoginApi().login(username, password);
    if (username == 'username') {
      state = const AsyncValue.data(User('username', 'password'));
    } else {
      state = AsyncValue.error('error', StackTrace.current);
      throw Exception();
    }
  }
}

class User {
  final String username;
  final String password;

  const User(this.username, this.password);
}
