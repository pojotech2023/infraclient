import '../models/ticket_model.dart';
import 'ticket_api_service.dart';

abstract class TicketRemoteDataSource {
  Future<List<TicketModel>> getTickets(int siteId);
  Future<void> addTicket({required int siteId, required int customerId, required String ticket, String? attachmentPath});
}

class TicketRemoteDataSourceImpl implements TicketRemoteDataSource {
  final TicketApiService apiService;

  TicketRemoteDataSourceImpl({required this.apiService});

  @override
  Future<List<TicketModel>> getTickets(int siteId) async {
    return await apiService.fetchTicketsBySite(siteId);
  }

  @override
  Future<void> addTicket({required int siteId, required int customerId, required String ticket, String? attachmentPath}) async {
    await apiService.addTicket(siteId: siteId, customerId: customerId, ticket: ticket, attachmentPath: attachmentPath);
  }
}
