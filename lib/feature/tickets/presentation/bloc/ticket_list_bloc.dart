import 'package:bloc/bloc.dart';
import 'ticket_list_event.dart';
import 'ticket_list_state.dart';
import '../../domain/usecases/get_tickets.dart';

class TicketListBloc extends Bloc<TicketListEvent, TicketListState> {
  final GetTickets getTickets;

  TicketListBloc({required this.getTickets}) : super(TicketListInitial()) {
    on<TicketListLoad>(_onLoad);
  }

  Future<void> _onLoad(TicketListLoad event, Emitter<TicketListState> emit) async {
    emit(TicketListLoading());
    final result = await getTickets(event.siteId);
    result.fold(
          (failure) => emit(TicketListError(message: failure.message)),
          (tickets) => emit(TicketListLoaded(tickets: tickets)),
    );
  }
}
