import 'package:create_user_app/src/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:create_user_app/src/authentication/data/repositories/authentication_repository_implementation.dart';
import 'package:create_user_app/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:create_user_app/src/authentication/domain/usecases/create_user.dart';
import 'package:create_user_app/src/authentication/domain/usecases/get_users.dart';
import 'package:create_user_app/src/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  sl
    // App Logic
    ..registerFactory(
      () => AuthenticationBloc(createUser: sl(), getUsers: sl()),
    )
    // Use cases
    ..registerLazySingleton(() => CreateUser(sl()))
    ..registerLazySingleton(() => GetUsers(sl()))
    // Repositories
    ..registerLazySingleton<AuthenticationRepository>(
      () => AuthenticationRepositoryImplementation(sl()),
    )
    // Data Source
    ..registerLazySingleton<AuthenticationRemoteDataSource>(
      () => AuthRemoteDataSrcImpl(sl()),
    )
    // External Dependencies
    ..registerLazySingleton(http.Client.new);
}
