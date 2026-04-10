
import 'package:builder_customer/feature/drawing/data/models/drawing_model.dart';
import 'drawing_api_services.dart';

abstract class DrawingRemoteDatasource {

Future<List<DrawingModel>> fetchDrawing(int siteId);

}


class DrawingRemoteDatasourceImpl extends DrawingRemoteDatasource{
final DrawingApiService apiService;

  DrawingRemoteDatasourceImpl({required this.apiService});

  @override
  Future<List<DrawingModel>> fetchDrawing(int siteId) {
 return apiService.fetchDrawingBySite(siteId);
  }
  
}