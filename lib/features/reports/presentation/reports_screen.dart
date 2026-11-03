import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:buildstock/app/theme/app_theme.dart';
import 'package:buildstock/core/database/app_database.dart';
import 'package:buildstock/core/utils/dates.dart';
import 'package:buildstock/core/utils/money.dart';
import 'package:buildstock/core/widgets/async_view.dart';
import 'package:buildstock/core/widgets/feedback.dart';
import 'package:buildstock/core/widgets/section_card.dart';
import 'package:buildstock/features/accounts/data/accounts_repository.dart';
import 'package:buildstock/features/customers/data/parties_repository.dart';
import 'package:buildstock/features/dashboard/presentation/dashboard_repository.dart';
import 'package:buildstock/features/products/data/catalog_repository.dart';
import 'package:buildstock/features/sales/data/sales_repository.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  DateTime _month = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final summary = ref.watch(dashboardSummaryProvider);
    final invoices = ref.watch(invoiceListProvider(''));
    final expenses = ref.watch(expensesStreamProvider(''));
    final inventory = ref.watch(inventoryStreamProvider);
    final customers = ref.watch(customersStreamProvider(''));
    final balances = ref.watch(customerBalancesProvider).value ?? const {};

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
        actions: [
          IconButton(
            tooltip: 'Export sales CSV',
            onPressed: () => _exportSales(invoices.value ?? const []),
            icon: const Icon(Icons.file_download_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  AppDate.monthLabel(_month),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              IconButton(
                onPressed: () =>
                    setState(() => _month = AppDate.addMonths(_month, -1)),
                icon: const Icon(Icons.chevron_left),
              ),
              IconButton(
                onPressed: () =>
                    setState(() => _month = AppDate.addMonths(_month, 1)),
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
          const SizedBox(height: 8),
          AsyncView(
            value: summary,
            builder: (data) {
              final monthInvoices = (invoices.value ?? const <SaleRow>[])
                  .where(
                    (invoice) =>
                        invoice.documentStatus == 'finalized' &&
                        invoice.documentType == 'invoice' &&
                        invoice.invoiceDate.year == _month.year &&
                        invoice.invoiceDate.month == _month.month,
                  )
                  .toList();
              final monthSales = monthInvoices.fold<int>(
                0,
                (sum, invoice) => sum + invoice.grandTotalPaise,
              );
              final monthGst = monthInvoices.fold<int>(
                0,
                (sum, invoice) =>
                    sum +
                    invoice.cgstPaise +
                    invoice.sgstPaise +
                    invoice.igstPaise,
              );
              final monthExpenses = (expenses.value ?? const <ExpenseRow>[])
                  .where(
                    (expense) =>
                        expense.paidAt.year == _month.year &&
                        expense.paidAt.month == _month.month,
                  )
                  .fold<int>(0, (sum, expense) => sum + expense.amountPaise);
              final stockValue = (inventory.value ?? const <InventoryView>[])
                  .fold<int>(
                    0,
                    (sum, row) =>
                        sum +
                        Money.roundDiv(
                          row.inventory.quantityMilli *
                              row.product.purchasePricePaise,
                          1000,
                        ),
                  );

              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _Metric(
                          label: 'Sales this month',
                          value: Money.format(monthSales),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _Metric(
                          label: 'GST this month',
                          value: Money.format(monthGst),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _Metric(
                          label: 'Expenses this month',
                          value: Money.format(monthExpenses),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _Metric(
                          label: 'Stock value (purchase)',
                          value: Money.format(stockValue),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _Metric(
                          label: 'Receivables',
                          value: Money.format(data.receivablesPaise),
                          color: AppColors.warning,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _Metric(
                          label: 'Payables',
                          value: Money.format(data.payablesPaise),
                          color: AppColors.danger,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          const SectionHeader(title: 'Customer outstanding'),
          AsyncView(
            value: customers,
            builder: (rows) {
              final owing =
                  rows
                      .where((customer) => (balances[customer.id] ?? 0) > 0)
                      .toList()
                    ..sort(
                      (a, b) =>
                          (balances[b.id] ?? 0).compareTo(balances[a.id] ?? 0),
                    );
              if (owing.isEmpty) {
                return const SectionCard(
                  child: EmptyState(
                    title: 'No outstanding balances',
                    message: 'Every customer balance is settled.',
                    compact: true,
                  ),
                );
              }
              return SectionCard(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  children: [
                    for (final customer in owing.take(10))
                      ListTile(
                        dense: true,
                        title: Text(customer.name),
                        trailing: Text(
                          Money.format(balances[customer.id] ?? 0),
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          const SectionHeader(title: 'Low stock'),
          AsyncView(
            value: ref.watch(lowStockProvider),
            builder: (rows) {
              if (rows.isEmpty) {
                return const SectionCard(
                  child: EmptyState(
                    title: 'Nothing below minimum',
                    message:
                        'Products with a configured minimum are monitored.',
                    compact: true,
                  ),
                );
              }
              return SectionCard(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  children: [
                    for (final product in rows.take(10))
                      ListTile(
                        dense: true,
                        title: Text(product.name),
                        trailing: Text(
                          'Min ${(product.minStockMilli / 1000).toStringAsFixed(2)}',
                          style: const TextStyle(color: AppColors.warning),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _exportSales(List<SaleRow> invoices) async {
    final lines = <String>[
      'Bill No,Date,Status,Subtotal,Discount,Taxable,CGST,SGST,IGST,Grand Total,Paid,Balance',
      for (final invoice in invoices)
        [
          invoice.invoiceNumber,
          AppDate.isoDate(invoice.invoiceDate),
          invoice.documentStatus,
          Money.plain(invoice.subtotalPaise),
          Money.plain(invoice.discountPaise),
          Money.plain(invoice.taxableAmountPaise),
          Money.plain(invoice.cgstPaise),
          Money.plain(invoice.sgstPaise),
          Money.plain(invoice.igstPaise),
          Money.plain(invoice.grandTotalPaise),
          Money.plain(invoice.amountPaidPaise),
          Money.plain(invoice.balanceDuePaise),
        ].join(','),
    ];
    try {
      final uri = await FilePicker.saveFile(
        dialogTitle: 'Export sales',
        fileName: 'buildstock-sales.csv',
        mimeType: 'text/csv',
        bytes: utf8.encode(lines.join('\n')),
      );
      if (mounted && uri != null) {
        showActionMessage(context, 'Exported to $uri');
      }
    } catch (error) {
      if (mounted) showActionMessage(context, error.toString());
    }
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value, this.color});

  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
