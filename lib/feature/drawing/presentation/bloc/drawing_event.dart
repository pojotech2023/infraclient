

import 'package:equatable/equatable.dart';

abstract class DrawingEvent extends Equatable{

  const DrawingEvent();

  @override
  List<Object?> get props =>[];
}


class DrawingLoad extends DrawingEvent{

   final int siteId;

   const DrawingLoad({required this.siteId});

   @override
 List<Object?> get props =>[siteId];

}