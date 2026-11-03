import 'package:flutter_test/flutter_test.dart';

import 'package:buildstock/features/sales/domain/invoice_calculator.dart';

void main() {
  InvoiceLine line({
    required int quantityMilli,
    required int pricePaise,
    int gstBps = 1800,
    int discountPaise = 0,
  }) => InvoiceLine(
    productId: 'prd_1',
    name: 'Maha Cement',
    quantityMilli: quantityMilli,
    unitPricePaise: pricePaise,
    taxRateBps: gstBps,
    discountPaise: discountPaise,
  );

  test('computes GST exclusive line totals in paise', () {
    final totals = InvoiceCalculator.compute(
      lines: [
        line(quantityMilli: 1000, pricePaise: 10000),
        line(quantityMilli: 1500, pricePaise: 5000),
      ],
    );
    expect(totals.subtotalPaise, 17500);
    expect(totals.taxableAmountPaise, 17500);
    expect(totals.taxPaise, 3150);
    expect(totals.cgstPaise, 1575);
    expect(totals.sgstPaise, 1575);
    expect(totals.igstPaise, 0);
    expect(totals.grandTotalPaise, 20700);
    expect(totals.roundOffPaise, 50);
  });

  test('applies invoice discount before tax and rounds the total', () {
    final totals = InvoiceCalculator.compute(
      lines: [line(quantityMilli: 1000, pricePaise: 10000)],
      invoiceDiscountPaise: 500,
    );
    expect(totals.taxableAmountPaise, 9500);
    expect(totals.taxPaise, 1710);
    expect(totals.grandTotalPaise, 11200);
    expect(totals.roundOffPaise, -10);
    expect(totals.cgstPaise + totals.sgstPaise, totals.taxPaise);
  });

  test('uses IGST for inter-state sales and no tax when non-GST', () {
    final interstate = InvoiceCalculator.compute(
      lines: [line(quantityMilli: 1000, pricePaise: 10000)],
      interState: true,
    );
    expect(interstate.igstPaise, 1800);
    expect(interstate.cgstPaise, 0);
    expect(interstate.sgstPaise, 0);

    final nonGst = InvoiceCalculator.compute(
      lines: [line(quantityMilli: 1000, pricePaise: 10000, gstBps: 1800)],
      isGst: false,
    );
    expect(nonGst.taxPaise, 0);
    expect(nonGst.grandTotalPaise, 10000);
  });

  test('clamps payments and reports balance due', () {
    final partial = InvoiceCalculator.compute(
      lines: [line(quantityMilli: 1000, pricePaise: 10000)],
      amountPaidPaise: 5000,
    );
    expect(partial.amountPaidPaise, 5000);
    expect(partial.balanceDuePaise, partial.grandTotalPaise - 5000);

    final overpaid = InvoiceCalculator.compute(
      lines: [line(quantityMilli: 1000, pricePaise: 10000)],
      amountPaidPaise: 999999,
    );
    expect(overpaid.amountPaidPaise, overpaid.grandTotalPaise);
    expect(overpaid.balanceDuePaise, 0);
  });

  test('rejects empty invoices and non-positive quantities', () {
    expect(
      () => InvoiceCalculator.compute(lines: const []),
      throwsArgumentError,
    );
    expect(
      () => InvoiceCalculator.compute(
        lines: [line(quantityMilli: 0, pricePaise: 100)],
      ),
      throwsArgumentError,
    );
  });

  test('line totals always reconcile with header totals', () {
    final totals = InvoiceCalculator.compute(
      lines: [
        line(quantityMilli: 2333, pricePaise: 4175),
        line(quantityMilli: 777, pricePaise: 12345, discountPaise: 250),
        line(quantityMilli: 1000, pricePaise: 1),
      ],
      invoiceDiscountPaise: 1234,
    );
    final lineSum = totals.lines.fold<int>(
      0,
      (sum, item) => sum + item.totalPaise,
    );
    expect(totals.taxableAmountPaise + totals.taxPaise, lineSum);
    expect(totals.grandTotalPaise, lineSum + totals.roundOffPaise);
  });
}
