class SitePaymentHistoryModel {
  final bool? status;
  final String? message;
  final List<PaymentHistory>? data;
  final SitePaymentSummaryData? summary;

  SitePaymentHistoryModel({this.status, this.message, this.data, this.summary});

  factory SitePaymentHistoryModel.fromJson(Map<String, dynamic> json) {
    List<PaymentHistory>? list;
    SitePaymentSummaryData? summaryData;

    final rawData = json['data'];
    if (rawData != null) {
      if (rawData is List) {
        list = rawData
            .whereType<Map<String, dynamic>>()
            .map((v) => PaymentHistory.fromJson(v))
            .toList();
      } else if (rawData is Map<String, dynamic>) {
        final innerList = rawData['payments'] ??
            rawData['history'] ??
            rawData['payment_history'] ??
            rawData['list'];
        if (innerList is List) {
          list = innerList
              .whereType<Map<String, dynamic>>()
              .map((v) => PaymentHistory.fromJson(v))
              .toList();
        }
        if (rawData.containsKey('budget_amount') ||
            rawData.containsKey('balance_amount') ||
            rawData.containsKey('paid_amount')) {
          summaryData = SitePaymentSummaryData.fromJson(rawData);
        }
      }
    } else if (json['payments'] is List) {
      list = (json['payments'] as List)
          .whereType<Map<String, dynamic>>()
          .map((v) => PaymentHistory.fromJson(v))
          .toList();
    }

    if (summaryData == null &&
        (json.containsKey('budget_amount') ||
            json.containsKey('balance_amount') ||
            json.containsKey('paid_amount'))) {
      summaryData = SitePaymentSummaryData.fromJson(json);
    }

    return SitePaymentHistoryModel(
      status: json['status'] == true || json['status'] == 'true' || json['status'] == 1,
      message: json['message']?.toString(),
      data: list,
      summary: summaryData,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      if (data != null) 'data': data!.map((v) => v.toJson()).toList(),
      if (summary != null) 'summary': summary!.toJson(),
    };
  }
}

class PaymentHistory {
  final int? id;
  final int? siteId;
  final String? payment;
  final String? date;
  final String? paymentMode;
  final String? remarks;
  final String? createdAt;
  final String? updatedAt;

  PaymentHistory({
    this.id,
    this.siteId,
    this.payment,
    this.date,
    this.paymentMode,
    this.remarks,
    this.createdAt,
    this.updatedAt,
  });

  factory PaymentHistory.fromJson(Map<String, dynamic> json) {
    return PaymentHistory(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? ''),
      siteId: json['site_id'] is int ? json['site_id'] : int.tryParse(json['site_id']?.toString() ?? ''),
      payment: (json['payment'] ?? json['amount'] ?? json['paid_amount'])?.toString(),
      date: (json['date'] ?? json['payment_date'])?.toString(),
      paymentMode: (json['payment_mode'] ?? json['mode'] ?? json['type'])?.toString(),
      remarks: (json['remarks'] ?? json['description'] ?? json['note'])?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'site_id': siteId,
      'payment': payment,
      'date': date,
      'payment_mode': paymentMode,
      'remarks': remarks,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class SitePaymentSummaryModel {
  final bool? status;
  final String? message;
  final SitePaymentSummaryData? data;

  SitePaymentSummaryModel({this.status, this.message, this.data});

  factory SitePaymentSummaryModel.fromJson(Map<String, dynamic> json) {
    SitePaymentSummaryData? summaryData;
    if (json['data'] != null && json['data'] is Map<String, dynamic>) {
      summaryData = SitePaymentSummaryData.fromJson(json['data']);
    } else if (json['summary'] != null && json['summary'] is Map<String, dynamic>) {
      summaryData = SitePaymentSummaryData.fromJson(json['summary']);
    } else if (json.containsKey('budget_amount') ||
        json.containsKey('balance_amount') ||
        json.containsKey('paid_amount')) {
      summaryData = SitePaymentSummaryData.fromJson(json);
    }

    return SitePaymentSummaryModel(
      status: json['status'] == true || json['status'] == 'true' || json['status'] == 1,
      message: json['message']?.toString(),
      data: summaryData,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      if (data != null) 'data': data!.toJson(),
    };
  }
}

class SitePaymentSummaryData {
  final int? siteId;
  final String? budgetAmount;
  final String? paidAmount;
  final String? balanceAmount;

  SitePaymentSummaryData({
    this.siteId,
    this.budgetAmount,
    this.paidAmount,
    this.balanceAmount,
  });

  factory SitePaymentSummaryData.fromJson(Map<String, dynamic> json) {
    return SitePaymentSummaryData(
      siteId: json['site_id'] is int ? json['site_id'] : int.tryParse(json['site_id']?.toString() ?? ''),
      budgetAmount: (json['budget_amount'] ?? json['budget'] ?? json['total_budget'])?.toString(),
      paidAmount: (json['paid_amount'] ?? json['paid'] ?? json['total_paid'])?.toString(),
      balanceAmount: (json['balance_amount'] ?? json['balance'] ?? json['remaining_amount'])?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'site_id': siteId,
      'budget_amount': budgetAmount,
      'paid_amount': paidAmount,
      'balance_amount': balanceAmount,
    };
  }
}
