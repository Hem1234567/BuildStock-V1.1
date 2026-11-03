import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:buildstock/features/invoices/domain/invoice_document.dart';
import 'package:buildstock/features/invoices/presentation/invoice_a4.dart';

void main() {
  InvoiceDocument document() => InvoiceDocument(
    id: 'inv_1',
    number: 'VBA-2026-DEV01-000001',
    documentType: 'invoice',
    status: 'finalized',
    date: DateTime(2026, 4, 1),
    time: '10:30 AM',
    seller: const InvoiceParty(
      name: 'Vijay Balaji Agency',
      phones: ['94440 01178', '86107 74664'],
      address: '2/28, Avadi Main Road, Chennai - 600 056',
      gstin: '33ABCDE1234F1Z5',
    ),
    buyer: const InvoiceParty(
      name: 'Ramesh Constructions',
      phone: '9876543210',
      address: 'Ambattur, Chennai',
    ),
    items: const [
      InvoiceDocumentItem(
        name: 'Maha Cement',
        sku: 'CEM-MAHA',
        hsnCode: '2523',
        unit: 'Bag',
        quantityMilli: 10000,
        unitPricePaise: 42000,
        taxRateBps: 1800,
        taxPaise: 75600,
        lineTotalPaise: 495600,
      ),
    ],
    subtotalPaise: 420000,
    discountPaise: 0,
    taxablePaise: 420000,
    cgstPaise: 37800,
    sgstPaise: 37800,
    igstPaise: 0,
    roundOffPaise: 0,
    grandTotalPaise: 495600,
    amountPaidPaise: 200000,
    balanceDuePaise: 295600,
    paymentMethod: 'cash',
    notes: '',
    isGst: true,
  );

  testWidgets('renders the Vijay Balaji Agency paper format', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(child: InvoiceA4(document: document())),
        ),
      ),
    );

    expect(find.text('BILL'), findsOneWidget);
    expect(find.text('VIJAY BALAJI AGENCY'), findsOneWidget);
    expect(
      find.text('DEALERS IN CEMENT, BRICKS, SAND, JELLY AND GRAVEL'),
      findsOneWidget,
    );
    expect(find.textContaining('VBA-2026-DEV01-000001'), findsOneWidget);
    expect(find.text('Ramesh Constructions'), findsOneWidget);
    expect(find.text('Maha Cement'), findsOneWidget);
    expect(find.text('Grand Total'), findsOneWidget);
    expect(find.text('Balance Due'), findsOneWidget);
    expect(
      find.textContaining('Rupees Four Thousand Nine Hundred Fifty Six'),
      findsOneWidget,
    );
  });

  testWidgets('renders an estimate heading without a payment QR', (
    tester,
  ) async {
    final estimate = InvoiceDocument(
      id: 'inv_2',
      number: 'VBA-2026-DEV01-000002',
      documentType: 'estimate',
      status: 'finalized',
      date: DateTime(2026, 4, 1),
      time: '10:30 AM',
      seller: const InvoiceParty(
        name: 'Vijay Balaji Agency',
        phones: ['94440 01178'],
        address: '2/28, Avadi Main Road, Chennai - 600 056',
      ),
      buyer: const InvoiceParty(name: 'Walk-in Customer'),
      items: const [
        InvoiceDocumentItem(
          name: 'M-Sand',
          quantityMilli: 1000,
          unitPricePaise: 5000,
          lineTotalPaise: 5000,
        ),
      ],
      subtotalPaise: 5000,
      discountPaise: 0,
      taxablePaise: 5000,
      cgstPaise: 0,
      sgstPaise: 0,
      igstPaise: 0,
      roundOffPaise: 0,
      grandTotalPaise: 5000,
      amountPaidPaise: 0,
      balanceDuePaise: 5000,
      paymentMethod: 'credit',
      notes: '',
      isGst: false,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(child: InvoiceA4(document: estimate)),
        ),
      ),
    );

    expect(find.text('ESTIMATE'), findsOneWidget);
    expect(
      find.text('This is an estimate, not a tax invoice.'),
      findsOneWidget,
    );
  });
}
