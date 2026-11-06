import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:builder_customer/core/cache/local_storage.dart';
import 'package:builder_customer/feature/drawing/presentation/pages/drawing_detail_page.dart';
import 'package:builder_customer/feature/payment_history/data/datasources/payment_history_remote_datasource.dart';
import 'package:builder_customer/feature/payment_history/data/models/site_payment_history_model.dart';

class SitePaymentHistoryPage extends StatefulWidget {
  final int? siteId;

  const SitePaymentHistoryPage({super.key, this.siteId});

  @override
  State<SitePaymentHistoryPage> createState() => _SitePaymentHistoryPageState();
}

class _SitePaymentHistoryPageState extends State<SitePaymentHistoryPage> {
  final PaymentHistoryRemoteDataSource _dataSource =
      PaymentHistoryRemoteDataSource(client: GetIt.I<http.Client>());

  bool _isLoading = true;
  String? _errorMessage;
  int _siteId = 0;
  String _siteName = "";
  String? _token;

  String _budgetAmount = "0";
  String _paidAmount = "0";
  String _balanceAmount = "0";
  List<PaymentHistory> _historyList = [];

  @override
  void initState() {
    super.initState();
    _loadUserAndFetchData();
  }

  Future<void> _loadUserAndFetchData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      if (widget.siteId != null && widget.siteId! > 0) {
        _siteId = widget.siteId!;
      } else {
        final localStorage = GetIt.I<LocalStorage>();
        final rawUser = await localStorage.load(key: 'user', boxName: 'auth');

        Map<String, dynamic> user = {};
        if (rawUser is String) {
          user = json.decode(rawUser);
        } else if (rawUser is Map) {
          user = Map<String, dynamic>.from(rawUser);
        }

        final dynamic rawSiteId = user['site_id'] ?? user['siteId'] ?? 0;
        _siteId = rawSiteId is int
            ? rawSiteId
            : int.tryParse(rawSiteId.toString()) ?? 0;
        _siteName = user['site_name']?.toString() ?? "";
        _token = user['token']?.toString();

        if (_token == null || _token!.trim().isEmpty) {
          try {
            final t = await localStorage.load(key: 'token', boxName: 'auth');
            if (t != null && t.toString().trim().isNotEmpty) {
              _token = t.toString().trim();
            }
          } catch (_) {}
        }
      }

      if (_siteId <= 0) {
        setState(() {
          _isLoading = false;
          _errorMessage = "No site associated with your account (Site ID: 0).\nPlease contact administrator.";
        });
        return;
      }

      // Fetch summary and history in parallel
      final summaryFuture = _dataSource.getPaymentSummary(_siteId, token: _token);
      final historyFuture = _dataSource.getPaymentHistory(_siteId, token: _token);

      final results = await Future.wait([summaryFuture, historyFuture]);

      final summary = results[0] as SitePaymentSummaryModel?;
      final history = results[1] as SitePaymentHistoryModel?;

      if (summary == null && history == null) {
        if (mounted) {
          final err = _dataSource.lastError ?? "";
          String msg = "Unable to fetch payment details from server.\nPlease ensure backend payment APIs are active and reachable.";
          if (err.toLowerCase().contains("unauthenticated")) {
            msg = "Backend Authentication Error (400 Unauthenticated):\n"
                "The live server (pojoinfra360.pojotech.in) has not yet deployed the 'auth:api,customer' route update to accept customer login tokens.\n\n"
                "Please ask backend team to deploy routes/api.php to pojoinfra360.pojotech.in.";
          }
          setState(() {
            _isLoading = false;
            _errorMessage = msg;
          });
        }
        return;
      }

      if (mounted) {
        final budget = summary?.data?.budgetAmount ?? history?.summary?.budgetAmount ?? "0";
        final paid = summary?.data?.paidAmount ?? history?.summary?.paidAmount ?? "0";
        final balance = summary?.data?.balanceAmount ?? history?.summary?.balanceAmount ?? "0";

        setState(() {
          _budgetAmount = budget;
          _paidAmount = paid;
          _balanceAmount = balance;
          _historyList = history?.data ?? [];
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = "Failed to load payment history: $e";
        });
      }
    }
  }

  Future<void> _downloadOrViewPdf(int? paymentId) async {
    if (paymentId == null) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Fetching PDF receipt..."),
        duration: Duration(seconds: 1),
      ),
    );

    try {
      final pdfUrl = await _dataSource.getPaymentReceiptPdfUrl(paymentId, token: _token);
      if (pdfUrl == null || pdfUrl.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to generate PDF receipt")),
          );
        }
        return;
      }

      if (mounted) {
        // Open directly in in-app PDF Viewer
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => DrawingDetailPage(
              url: pdfUrl,
              title: "Payment Receipt #$paymentId",
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error opening PDF: $e")),
        );
      }
    }
  }

  Future<void> _exportExcel() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Exporting payment history to CSV..."),
        duration: Duration(seconds: 1),
      ),
    );

    try {
      final response = await _dataSource.downloadPaymentExcel(_siteId, token: _token);
      if (response.statusCode == 200) {
        String? outputFile;
        try {
          outputFile = await FilePicker.platform.saveFile(
            dialogTitle: 'Save Payment History CSV',
            fileName: 'payment_history_site_$_siteId.csv',
            bytes: response.bodyBytes,
            type: FileType.custom,
            allowedExtensions: ['csv', 'xlsx', 'xls'],
          );
        } catch (_) {}

        if (mounted) {
          if (outputFile != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Export saved successfully to: $outputFile"),
                backgroundColor: Colors.green,
              ),
            );
          } else {
            // Fallback: launch direct URL
            final fallbackUrl = await _dataSource.getPaymentExcelExportUrl(_siteId, token: _token);
            if (fallbackUrl != null) {
              await launchUrl(Uri.parse(fallbackUrl), mode: LaunchMode.externalApplication);
            }
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Export failed with status: ${response.statusCode}")),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error exporting CSV: $e")),
        );
      }
    }
  }

  String _formatCurrency(String? amount) {
    if (amount == null || amount.isEmpty || amount == "-" || amount == "0") return "₹0";
    try {
      final clean = amount.replaceAll(',', '').trim();
      final numVal = num.tryParse(clean);
      if (numVal != null) {
        return NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0).format(numVal);
      }
    } catch (_) {}
    return "₹$amount";
  }

  String _formatDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty || rawDate == "-") return "-";
    try {
      if (rawDate.contains("-")) {
        final parts = rawDate.split("-");
        if (parts.length == 3 && parts[0].length == 4) {
          // yyyy-MM-dd -> dd-MM-yyyy
          return "${parts[2]}-${parts[1]}-${parts[0]}";
        }
      }
      final parsed = DateTime.parse(rawDate);
      return DateFormat('dd-MM-yyyy').format(parsed);
    } catch (_) {
      return rawDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        title: Text(
          _siteName.isNotEmpty ? _siteName : "Site Payment History",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF002055),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF002055)),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              GoRouter.of(context).go('/dashboard');
            }
          },
        ),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, size: 48, color: Colors.red),
                          const SizedBox(height: 12),
                          Text(
                            _errorMessage!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 15, color: Colors.red),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: _loadUserAndFetchData,
                            icon: const Icon(Icons.refresh),
                            label: const Text("Retry"),
                          ),
                        ],
                      ),
                    ),
                  )
                : Column(
                    children: [
                      // ── Top Header Bar (Budget, Site Badge, Export) ──
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE3F2FD),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Budget: ${_formatCurrency(_budgetAmount)}",
                                    style: const TextStyle(
                                      color: Color(0xFF1976D2),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                  if (_siteId > 0) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF1976D2).withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        "Site #$_siteId",
                                        style: const TextStyle(
                                          color: Color(0xFF1976D2),
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: _exportExcel,
                              icon: const Icon(Icons.file_download, size: 18),
                              label: const Text("Export Excel"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4CAF50),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ── Payment Cards List ──
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: _loadUserAndFetchData,
                          child: _historyList.isEmpty
                              ? ListView(
                                  children: const [
                                    SizedBox(height: 100),
                                    Center(
                                      child: Text(
                                        "No payment history found",
                                        style: TextStyle(color: Colors.grey, fontSize: 15),
                                      ),
                                    ),
                                  ],
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                  itemCount: _historyList.length,
                                  itemBuilder: (context, index) {
                                    final item = _historyList[index];
                                    return _buildPaymentCard(index + 1, item);
                                  },
                                ),
                        ),
                      ),

                      // ── Balance Amount Footer Bar ──
                      _buildBalanceFooter(),
                    ],
                  ),
      ),
    );
  }

  Widget _buildPaymentCard(int index, PaymentHistory item) {
    final formattedDate = _formatDate(item.date);
    final formattedAmount = _formatCurrency(item.payment);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // S.NO and Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'S.NO: $index',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
                Text(
                  formattedDate,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const Divider(height: 18, thickness: 0.8),

            // Amount
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Amount: ',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                Expanded(
                  child: Text(
                    formattedAmount,
                    style: const TextStyle(
                      color: Color(0xFF0B9F08),
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // Mode
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Mode: ',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
                Expanded(
                  child: Text(
                    item.paymentMode ?? "-",
                    style: const TextStyle(fontSize: 13, color: Colors.black87),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // Remarks
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Remarks: ',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
                Expanded(
                  child: Text(
                    item.remarks ?? "-",
                    style: const TextStyle(fontSize: 13, color: Colors.black87),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // PDF Action Button
            Row(
              children: [
                InkWell(
                  onTap: () => _downloadOrViewPdf(item.id),
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFE53935), width: 1.2),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.picture_as_pdf, size: 16, color: Color(0xFFE53935)),
                        SizedBox(width: 6),
                        Text(
                          "Receipt PDF",
                          style: TextStyle(
                            color: Color(0xFFE53935),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceFooter() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 6, 16, 14),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1976D2).withOpacity(0.35),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "BALANCE AMOUNT",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
              letterSpacing: 0.5,
            ),
          ),
          Text(
            _formatCurrency(_balanceAmount),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
