import 'package:get_it/get_it.dart';
import 'package:jspm_pulse/features/auth/data/DataSource/supabase_auth_datasource.dart';
import 'package:jspm_pulse/features/auth/data/Repositories/auth_repository_impl.dart';
import 'package:jspm_pulse/features/auth/domain/UseCases/auth_usecases.dart';
import 'package:jspm_pulse/features/auth/domain/UseCases/get_current_user_usecase.dart';
import 'package:jspm_pulse/features/auth/domain/UseCases/log_in_usecase.dart';
import 'package:jspm_pulse/features/auth/domain/UseCases/sign_out_usecase.dart';
import 'package:jspm_pulse/features/auth/domain/UseCases/sign_up_usecase.dart';
import 'package:jspm_pulse/features/auth/presentation/Bloc/auth_bloc.dart';
import 'package:jspm_pulse/features/notices/data/datasource/notices_remote_datasource.dart';
import 'package:jspm_pulse/features/notices/data/respositories/notice_repo_impl.dart';
import 'package:jspm_pulse/features/notices/domain/usecases/create_notice_usecase.dart';
import 'package:jspm_pulse/features/notices/domain/usecases/delete_notice_usecase.dart';
import 'package:jspm_pulse/features/notices/domain/usecases/fetch_all_notices.dart';
import 'package:jspm_pulse/features/notices/domain/usecases/fetch_all_notices_stream.dart';
import 'package:jspm_pulse/features/notices/domain/usecases/notice_usecases.dart';
import 'package:jspm_pulse/features/notices/domain/usecases/update_notice_usecase.dart';
import 'package:jspm_pulse/features/notices/presentation/bloc/notice_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final getIt = GetIt.instance;

void setupLocator() {
  /* 
  A U T H E N T I C A T I O N
  */
  getIt.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);
  getIt.registerLazySingleton<SupabaseAuthDatasource>(
    () => SupabaseAuthDatasource(getIt<SupabaseClient>()),
  );

  getIt.registerLazySingleton<AuthRepositoryImpl>(
    () => AuthRepositoryImpl(datasource: getIt<SupabaseAuthDatasource>()),
  );
  getIt.registerFactory<AuthBloc>(() => AuthBloc(getIt<AuthUseCases>()));
  getIt.registerLazySingleton<AuthUseCases>(
    () => AuthUseCases(
      signUp: SignUpUseCase(authRepository: getIt<AuthRepositoryImpl>()),
      logIn: LogInUseCase(authRepository: getIt<AuthRepositoryImpl>()),
      signOut: SignOutUseCase(authRepository: getIt<AuthRepositoryImpl>()),
      getCurrentUser: GetCurrentUserUseCase(
        authRepository: getIt<AuthRepositoryImpl>(),
      ),
    ),
  );

  /*
  N O T I C E  F E A T U R E
  */

  getIt.registerLazySingleton<NoticesRemoteDatasource>(
    () => NoticesRemoteDatasource(getIt<SupabaseClient>()),
  );
  getIt.registerLazySingleton<NoticeRepoImpl>(
    () => NoticeRepoImpl(getIt<NoticesRemoteDatasource>()),
  );

  getIt.registerLazySingleton<NoticeUsecases>(
    () => NoticeUsecases(
      createNoticeUseCase: CreateNoticeUseCase(getIt<NoticeRepoImpl>()),
      fetchAllNoticesUseCase: FetchAllNoticesUseCase(getIt<NoticeRepoImpl>()),
      updateNoticeUsecase: UpdateNoticeUsecase(getIt<NoticeRepoImpl>()),
      deleteNoticeUsecase: DeleteNoticeUsecase(getIt<NoticeRepoImpl>()),
      fetchAllNoticesStreamUseCase: FetchAllNoticesStreamUseCase(
        getIt<NoticeRepoImpl>(),
      ),
    ),
  );

  getIt.registerLazySingleton<NoticeBloc>(
    () => NoticeBloc(getIt<NoticeUsecases>()),
  );
}
