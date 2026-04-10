
 import 'package:builder_customer/feature/drawing/domain/entities/drawing_entity.dart';
import 'package:equatable/equatable.dart';

abstract class DrawingState extends Equatable{
const DrawingState();
 @override
  List<Object?> get props => [];

}

class DrawingInitial extends DrawingState{}
class DrawingLoading extends DrawingState{}
class DrawingLoaded extends DrawingState{
  final List<DrawingEntity> data;
 const DrawingLoaded({required this.data});

  List<Object?> get props => [data];

}

class DrawingError extends DrawingState{
   final String message;
   const DrawingError({required this.message});
   List<Object?> get props =>[message];
}