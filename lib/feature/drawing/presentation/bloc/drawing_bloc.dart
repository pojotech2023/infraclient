



import 'package:builder_customer/feature/drawing/presentation/bloc/drawing_event.dart';
import 'package:builder_customer/feature/drawing/presentation/bloc/drawing_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecase/get_drawing.dart';

class DrawingBloc extends Bloc<DrawingEvent, DrawingState>{
  
  final GetDrawing getTickets;

  DrawingBloc({required this.getTickets}) : super(DrawingInitial()) {
    on<DrawingLoad>(_onLoad);
  }

  Future<void> _onLoad(DrawingLoad event, Emitter<DrawingState> emit) async {
    emit(DrawingLoading());
    final result = await getTickets(event.siteId);
    result.fold(
          (failure) => emit(DrawingError(message: failure.message)),
          (result) => emit(DrawingLoaded(data: result)),
    );
  }



}