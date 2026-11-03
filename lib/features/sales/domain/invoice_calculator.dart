import 'package:buildstock/core/utils/money.dart';

/// One line as entered by the user, before any totals are calculated.
class InvoiceLine {
  const InvoiceLine({
    required this.productId,
    required this.name,
    required this.quantityMilli,
    required this.unitPricePaise,
    this.sku = '',
    this.hsnCode = '',
    this.unit = 'Nos',
    this.discountPaise = 0,
    this.taxRateBps = 0,
  });

  final String? productId;
  final String name;
  final String sku;
  final String hsnCode;
  final String unit;
  final int quantityMilli;
  final int unitPricePaise;
  final int discountPaise;
  final int taxRateBps;
}

class ComputedInvoiceLine {
  const ComputedInvoiceLine({
    required this.input,
    required this.grossPaise,
    required this.discountPaise,
    required this.taxablePaise,
    required this.taxPaise,
    required this.totalPaise,
  });

  final InvoiceLine input;
  final int grossPaise;
  final int discountPaise;
  final int taxablePaise;
  final int taxPaise;
  final int totalPaise;
}

class InvoiceTotals {
  const InvoiceTotals({
    required this.lines,
    required this.subtotalPaise,
    required this.lineDiscountPaise,
    required this.invoiceDiscountPaise,
    required this.discountPaise,
    required this.taxableAmountPaise,
    required this.cgstPaise,
    required this.sgstPaise,
    required this.igstPaise,
    required this.taxPaise,
    required this.roundOffPaise,
    required this.grandTotalPaise,
    required this.amountPaidPaise,
    required this.balanceDuePaise,
    required this.isGst,
    required this.interState,
  });

  final List<ComputedInvoiceLine> lines;
  final int subtotalPaise;
  final int lineDiscountPaise;
  final int invoiceDiscountPaise;
  final int discountPaise;
  final int taxableAmountPaise;
  final int cgstPaise;
  final int sgstPaise;
  final int igstPaise;
  final int taxPaise;
  final int roundOffPaise;
  final int grandTotalPaise;
  final int amountPaidPaise;
  final int balanceDuePaise;
  final bool isGst;
  final bool interState;

  int get totalQuantityMilli =>
      lines.fold(0, (sum, line) => sum + line.input.quantityMilli);
}

/// Deterministic invoice arithmetic. All money is integer paise and all
/// quantities are integer milli-units, so results are reproducible on every
/// device to the paisa.
abstract final class InvoiceCalculator {
  static InvoiceTotals compute({
    required List<InvoiceLine> lines,
    int invoiceDiscountPaise = 0,
    bool isGst = true,
    bool interState = false,
    int amountPaidPaise = 0,
  }) {
    if (lines.isEmpty) {
      throw ArgumentError('An invoice needs at least one line');
    }
    if (invoiceDiscountPaise < 0) {
      throw ArgumentError('Discount cannot be negative');
    }

    final gross = <int>[];
    final lineDiscounts = <int>[];
    final taxable = <int>[];
    var subtotal = 0;

    for (final line in lines) {
      if (line.quantityMilli <= 0) {
        throw ArgumentError('Quantity must be greater than zero');
      }
      if (line.unitPricePaise < 0) {
        throw ArgumentError('Rate cannot be negative');
      }
      final lineGross = Money.roundDiv(
        line.quantityMilli * line.unitPricePaise,
        1000,
      );
      final discount = line.discountPaise.clamp(0, lineGross);
      subtotal += lineGross;
      gross.add(lineGross);
      lineDiscounts.add(discount);
      taxable.add(lineGross - discount);
    }

    final totalTaxableBeforeInvoiceDiscount = taxable.fold(0, (a, b) => a + b);
    final effectiveInvoiceDiscount = invoiceDiscountPaise.clamp(
      0,
      totalTaxableBeforeInvoiceDiscount,
    );

    var allocatedDiscount = 0;
    final computed = <ComputedInvoiceLine>[];
    var taxableTotal = 0;
    var taxTotal = 0;

    for (var index = 0; index < lines.length; index++) {
      final line = lines[index];
      int allocation;
      if (index == lines.length - 1) {
        allocation = effectiveInvoiceDiscount - allocatedDiscount;
      } else if (totalTaxableBeforeInvoiceDiscount == 0) {
        allocation = 0;
      } else {
        allocation = Money.roundDiv(
          effectiveInvoiceDiscount * taxable[index],
          totalTaxableBeforeInvoiceDiscount,
        );
      }
      allocation = allocation.clamp(0, taxable[index]);
      allocatedDiscount += allocation;

      final lineTaxable = taxable[index] - allocation;
      final rate = isGst ? line.taxRateBps : 0;
      final tax = Money.applyBps(lineTaxable, rate);
      taxableTotal += lineTaxable;
      taxTotal += tax;
      computed.add(
        ComputedInvoiceLine(
          input: line,
          grossPaise: gross[index],
          discountPaise: lineDiscounts[index] + allocation,
          taxablePaise: lineTaxable,
          taxPaise: tax,
          totalPaise: lineTaxable + tax,
        ),
      );
    }

    final cgst = interState ? 0 : taxTotal ~/ 2;
    final sgst = interState ? 0 : taxTotal - cgst;
    final igst = interState ? taxTotal : 0;

    final beforeRounding = taxableTotal + taxTotal;
    final rounded = ((beforeRounding + 50) ~/ 100) * 100;
    final roundOff = rounded - beforeRounding;
    final grandTotal = rounded;
    final paid = amountPaidPaise.clamp(0, grandTotal);

    return InvoiceTotals(
      lines: computed,
      subtotalPaise: subtotal,
      lineDiscountPaise: lineDiscounts.fold(0, (a, b) => a + b),
      invoiceDiscountPaise: effectiveInvoiceDiscount,
      discountPaise:
          lineDiscounts.fold(0, (a, b) => a + b) + effectiveInvoiceDiscount,
      taxableAmountPaise: taxableTotal,
      cgstPaise: cgst,
      sgstPaise: sgst,
      igstPaise: igst,
      taxPaise: taxTotal,
      roundOffPaise: roundOff,
      grandTotalPaise: grandTotal,
      amountPaidPaise: paid,
      balanceDuePaise: grandTotal - paid,
      isGst: isGst,
      interState: interState,
    );
  }
}
