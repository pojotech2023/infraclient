import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/ticket_message_entity.dart';
import '../../../domain/usecases/send_ticket_message.dart';
import '../../../domain/usecases/ticket_message.dart';
import 'ticket_message_event.dart';
import 'ticket_message_state.dart';

class TicketMessageBloc extends Bloc<TicketMessageEvent, TicketMessageState> {
  final GetTicketMessages getTicketMessages;
  final SendTicketMessage sendTicketMessage; // ✅ new usecase

  TicketMessageBloc({
    required this.getTicketMessages,
    required this.sendTicketMessage,
  }) : super(TicketMessageInitial()) {
    // Load Messages
    on<LoadTicketMessages>((event, emit) async {
      emit(TicketMessageLoading());
     final result = await getTicketMessages(event.ticketId);
      result.fold(
        (failure) => emit(TicketMessageError(message: failure.message)),
        (messages) => emit(TicketMessageLoaded(messages: messages)),
      );
    });

   on<SendMessage>((event, emit) async {
 final currentState = state;
      List<TicketMessageEntity> existingMessages = [];

      if (currentState is TicketMessageLoaded) {
        existingMessages = List.from(currentState.messages);
        emit(TicketMessageLoaded(messages: existingMessages, isSending: true));
      } else {
        emit(TicketMessageSending());
      }


  final result = await sendTicketMessage(
    event.siteId,
    event.ticketId,
    event.senderType,
    event.message,
    event.attachment,
  );

  await result.fold(
    (failure) async => emit(TicketMessageError(message: failure.message)),
    (_) async {
          // Reload messages from server to get accurate data (including image URLs)
          add(LoadTicketMessages(ticketId: int.parse(event.ticketId)));
        },
      );
    }
  );


  }
}
