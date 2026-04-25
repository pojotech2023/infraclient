import 'package:builder_customer/core/cache/hive_local_storage.dart';
import 'package:builder_customer/feature/drawing/data/respositories/drawing_repository_impl.dart';
import 'package:builder_customer/feature/drawing/domain/usecase/get_drawing.dart';
import 'package:builder_customer/feature/tickets/data/datasources/ticket_api_service.dart';
import 'package:builder_customer/feature/tickets/domain/respositories/ticket_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../feature/drawing/data/datasources/drawing_api_services.dart';
import '../../feature/drawing/data/datasources/drawing_remote_datasource.dart';
import '../../feature/drawing/domain/respositories/drawing_repositories.dart';
import '../../feature/drawing/presentation/bloc/drawing_bloc.dart';
import '../../feature/tickets/domain/usecases/send_ticket_message.dart';
import '../cache/local_storage.dart';
import '../network/network.dart';
import '../theme/bloc/theme_bloc.dart';
import '../localization/bloc/locale_bloc.dart';

// Tickets feature imports
import '../../feature/tickets/data/datasources/ticket_remote_datasource.dart';
import '../../feature/tickets/data/repositories/ticket_repository_impl.dart';

import '../../feature/tickets/domain/usecases/get_tickets.dart';
import '../../feature/tickets/presentation/bloc/ticket_list_bloc.dart';
import '../config/env_service.dart';
import '../../feature/tickets/data/datasources/ticket_message_remote_datasource.dart';
import '../../feature/tickets/data/repositories/ticket_message_repository_impl.dart';
import '../../feature/tickets/domain/respositories/ticket_message_repository.dart';
import '../../feature/tickets/domain/usecases/ticket_message.dart';
import '../../feature/tickets/presentation/bloc/ticket_messaging/ticket_message_bloc.dart';

// Home checklist feature imports
import '../../feature/home/data/datasources/checklist_remote_datasource.dart';
import '../../feature/home/data/repositories/checklist_repository_imp.dart';
import '../../feature/home/domain/respositories/checklist_repository.dart';
import '../../feature/home/domain/usecases/get_checklist.dart';
import '../../feature/home/presentation/bloc/checklist_bloc.dart';

// Login feature imports
import '../../feature/login/data/datasources/login_remote_datasource.dart';
import '../../feature/login/data/repositories/login_repository_impl.dart';
import '../../feature/login/domain/repositories/login_repository.dart';
import '../../feature/login/domain/usecase/login_customer.dart';
import '../../feature/login/presentation/bloc/login_bloc.dart';
import '../../feature/profile/data/datasources/profile_remote_datasource.dart';
import '../../feature/profile/data/repositories/profile_repository_impl.dart';
import '../../feature/profile/domain/repositories/profile_repository.dart';

final getIt = GetIt.I;

Future<void> configureDependencies() async {
  // Core
    getIt.registerLazySingleton<LocalStorage>(() => HiveLocalStorage());
  getIt.registerLazySingleton<http.Client>(() => http.Client());
  getIt.registerLazySingleton<Connectivity>(() => Connectivity());
  getIt.registerLazySingleton<ConnectionCheckerImpl>(
        () => ConnectionCheckerImpl(getIt<Connectivity>()),
  );
  getIt.registerLazySingleton<ConnectionServiceImpl>(
        () => ConnectionServiceImpl(getIt<ConnectionCheckerImpl>()),
  );
  getIt.registerLazySingleton<ConnectionService>(() => getIt<ConnectionServiceImpl>());

  // ---------------------------
  // Tickets Feature Registrations
  // ---------------------------

  // Data source
  getIt.registerLazySingleton<TicketApiService>(
        () => TicketApiService(client: getIt<http.Client>()),
  );
  getIt.registerLazySingleton<TicketRemoteDataSource>(
        () => TicketRemoteDataSourceImpl(apiService: getIt<TicketApiService>()),
  );

  // Repository
  getIt.registerLazySingleton<TicketRepository>(
        () => TicketRepositoryImpl(remoteDataSource: getIt<TicketRemoteDataSource>()),
  );

  // Use case
  getIt.registerLazySingleton<GetTickets>(
        () => GetTickets(getIt<TicketRepository>()),
  );
  getIt.registerLazySingleton<AddTicket>(
        () => AddTicket(getIt<TicketRepository>()),
  );

  // Bloc
  getIt.registerFactory<TicketListBloc>(
        () => TicketListBloc(getTickets: getIt<GetTickets>()),
  );

  // Ticket messaging
  getIt.registerLazySingleton<TicketMessageRemoteDataSource>(
        () => TicketMessageRemoteDataSourceImpl(
          client: getIt<http.Client>(),
          baseUrl: EnvService.getString('BASE_URL', defaultValue: 'https://api.example.com'),
        ),
  );
  getIt.registerLazySingleton<TicketMessageRepository>(
        () => TicketMessageRepositoryImpl(remoteDataSource: getIt<TicketMessageRemoteDataSource>()),
  );
  getIt.registerLazySingleton<GetTicketMessages>(
        () => GetTicketMessages(getIt<TicketMessageRepository>()),
  );

  getIt.registerLazySingleton<SendTicketMessage>(
  () => SendTicketMessage(getIt<TicketMessageRepository>()),
);
  getIt.registerFactory<TicketMessageBloc>(
        () => TicketMessageBloc(getTicketMessages: getIt<GetTicketMessages>(), sendTicketMessage: getIt<SendTicketMessage>()),
  );

  // ---------------------------
  // Home Checklist Feature Registrations
  // ---------------------------
  getIt.registerLazySingleton<ChecklistRemoteDataSource>(
        () => ChecklistRemoteDataSourceImpl(
      client: getIt<http.Client>(),
      baseUrl: EnvService.getString('BASE_URL', defaultValue: 'https://api.example.com'),
    ),
  );
  getIt.registerLazySingleton<ChecklistRepository>(
        () => ChecklistRepositoryImpl(remoteDataSource: getIt<ChecklistRemoteDataSource>()),
  );
  getIt.registerLazySingleton<GetChecklist>(
        () => GetChecklist(getIt<ChecklistRepository>()),
  );
  getIt.registerFactory<ChecklistBloc>(
        () => ChecklistBloc(getChecklistUseCase: getIt<GetChecklist>()),
  );



   // ---------------------------
  // Home Drawing Feature Registrations
  // ---------------------------
// 1. Register the API service
getIt.registerLazySingleton<DrawingApiService>(
  () => DrawingApiService(client: getIt<http.Client>()),
);

// 2. Register the remote data source
getIt.registerLazySingleton<DrawingRemoteDatasource>(
  () => DrawingRemoteDatasourceImpl(apiService: getIt<DrawingApiService>()),
);

// 3. Register the repository
getIt.registerLazySingleton<DrawingRepository>(
  () => DrawingRepositoryImpl(remoteDataSource: getIt<DrawingRemoteDatasource>()),
);

// 4. Register the use case
getIt.registerLazySingleton<GetDrawing>(
  () => GetDrawing(getIt<DrawingRepository>()),
);

// 5. Register the Bloc
getIt.registerFactory<DrawingBloc>(
  () => DrawingBloc(getTickets: getIt<GetDrawing>()),
);

  // ---------------------------
  // Login Feature Registrations
  // ---------------------------
  getIt.registerLazySingleton<LoginRemoteDataSource>(
        () => LoginRemoteDataSourceImpl(
      client: getIt<http.Client>(),
      baseUrl: EnvService.getString('BASE_URL', defaultValue: 'https://api.example.com'),
    ),
  );
  getIt.registerLazySingleton<LoginRepository>(
        () => LoginRepositoryImpl(remoteDataSource: getIt<LoginRemoteDataSource>(), localStorage:  getIt<LocalStorage>(),),
  );
  getIt.registerLazySingleton<LoginCustomer>(
        () => LoginCustomer(getIt<LoginRepository>()),
  );
  getIt.registerFactory<LoginBloc>(
        () => LoginBloc(loginCustomer: getIt<LoginCustomer>()),
  );

  // ---------------------------
  // Profile Feature Registrations
  // ---------------------------
  getIt.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(
      client: getIt<http.Client>(),
      baseUrl: EnvService.getString('BASE_URL', defaultValue: 'https://api.example.com'),
    ),
  );
  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      remoteDataSource: getIt<ProfileRemoteDataSource>(),
      localStorage: getIt<LocalStorage>(),
    ),
  );

  // ---------------------------
  // Other Blocs
  // ---------------------------
  getIt.registerLazySingleton<ThemeBloc>(() => ThemeBloc());
  getIt.registerLazySingleton<LocaleBloc>(() => LocaleBloc());
}
