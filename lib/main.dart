import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jspm_pulse/core/service_locators/service_locator.dart';
import 'package:jspm_pulse/features/auth/domain/UseCases/auth_usecases.dart';
import 'package:jspm_pulse/features/auth/domain/UseCases/get_current_user_usecase.dart';
import 'package:jspm_pulse/features/auth/presentation/Bloc/auth_bloc.dart';
import 'package:jspm_pulse/features/auth/presentation/Bloc/auth_events.dart';
import 'package:jspm_pulse/features/auth/presentation/Bloc/auth_state.dart';
import 'package:jspm_pulse/features/auth/presentation/login_screen.dart';
import 'package:jspm_pulse/features/home/presentation/pages/home_screen.dart';
import 'package:jspm_pulse/features/notices/domain/usecases/notice_usecases.dart';
import 'package:jspm_pulse/features/notices/presentation/bloc/notice_bloc.dart';
import 'package:jspm_pulse/features/notices/presentation/bloc/notice_events.dart';
import 'package:jspm_pulse/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:jspm_pulse/features/profile/domain/usecases/update_profile_pic_usecase.dart';
import 'package:jspm_pulse/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:jspm_pulse/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:jspm_pulse/features/profile/presentation/bloc/profile_events.dart';
import 'package:jspm_pulse/features/profile/presentation/pages/profile_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: "https://cgokpagcgcbgswmbphrr.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNnb2twYWdjZ2NiZ3N3bWJwaHJyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTY5OTQ4MTcsImV4cCI6MjA3MjU3MDgxN30.Qv7ElMqXDW6GbSMevuPpOJ7FQALa7SClwa28Uqj0tn4",
  );

  setupLocator();
  runApp(JSPMPulse());
}

class JSPMPulse extends StatelessWidget {
  const JSPMPulse({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              AuthBloc(getIt<AuthUseCases>())..add(LoadCurrentUserEvent()),
        ),
        BlocProvider(
          create: (_) =>
              NoticeBloc(getIt<NoticeUsecases>())
                ..add(FetchAllNoticesStreamEvent(["Students"])),
        ),

        BlocProvider(
          create: (_) => ProfileBloc(
            getIt<GetProfileUseCase>(),
            getIt<UpdateProfileUseCase>(),
            getIt<UpdateProfilePicUseCase>(),
          )..add(FetchProfileEvent(id: "d15839af-f50d-4e5d-a8c4-ef6c707348bc")),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: BlocBuilder<AuthBloc, AuthStates>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return Scaffold(body: Center(child: CircularProgressIndicator()));
            }
            if (state is AuthSuccess) {
              return const ProfileScreen();
            }
            return const LogInScreen();
          },
        ),
      ),
    );
  }
}
