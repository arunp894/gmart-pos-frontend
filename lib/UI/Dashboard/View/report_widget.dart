import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gmart/Core/application_base.dart';
import 'package:gmart/UI/Dashboard/ViewModel/report_view_model.dart';

class ReportWidget extends StatefulWidget {
  const ReportWidget({super.key});

  @override
  State<ReportWidget> createState() => _ReportWidgetState();
}

class _ReportWidgetState extends State<ReportWidget> {
  ReportViewModel? model;
  final keyLoader = GlobalKey<State>();

  @override
  Widget build(BuildContext context) {
    return BaseView<ReportViewModel>(
      prepareModel: (model) {
        this.model = model;
      },
      builder: (context, model, child) {
        return Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.center,
            spacing: 15.0,
            runSpacing: 15.0,
            children: ["Purchase & Sale", "Product Sell"]
                .map(
                  (e) => InkResponse(
                    onTap: () async {
                      doneApiCall(e);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        color: Colors.purple.shade600,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        e,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 15.0),
                      ),
                    ),
                  ),
                )
                .toList());
      },
    );
  }

  doneApiCall(title) async {
    switch (title) {
      case "Purchase & Sale":
        bool result =
            await model!.purchaseReport(context: context, keyLoader: keyLoader);
        if (result) {
          await generatePurchaseReportFromJson(model!.purchaseResponse!);
        }
        break;
      case "Product Sell":
        Fluttertoast.showToast(msg: "Coming soon...!");
    }
  }

  Future<List<int>> generatePurchaseReportFromJson(
      Map<String, dynamic> json) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    final List<int> bytes = [];

    bytes.addAll(generator.text('REPORT SUMMARY',
        styles: const PosStyles(
            align: PosAlign.center, bold: true, height: PosTextSize.size2),
        linesAfter: 1));

    bytes.addAll(generator.text('----------- PURCHASE DETAILS ----------',
        styles: const PosStyles(bold: true)));
    final purchase = json['purchase'] ?? {};
    bytes.addAll(generator.text(
        'Total Purchase (Inc Tax):   ${purchase['total_purchase_inc_tax'] ?? "-"}'));
    bytes.addAll(generator.text(
        'Total Purchase (Exc Tax):   ${purchase['total_purchase_exc_tax'] ?? "-"}'));
    bytes.addAll(generator
        .text('Purchase Due:               ${_fmt(purchase['purchase_due'])}'));
    bytes.addAll(generator.text(
        'Shipping Charges:           ${purchase['total_shipping_charges'] ?? "-"}'));
    bytes.addAll(generator.text(
        'Additional Expense:         ${purchase['total_additional_expense'] ?? "-"}'));
    bytes.addAll(generator.feed(1));

    bytes.addAll(generator.text('------------- SELL DETAILS ------------',
        styles: const PosStyles(bold: true)));
    final sell = json['sell'] ?? {};
    bytes.addAll(generator
        .text('Total Sell (Inc Tax):     ${_fmt(sell['total_sell_inc_tax'])}'));
    bytes.addAll(generator
        .text('Total Sell (Exc Tax):    ${_fmt(sell['total_sell_exc_tax'])}'));
    bytes.addAll(generator
        .text('Invoice Due:             ${_fmt(sell['invoice_due'])}'));
    bytes.addAll(generator.text(
        'Shipping Charges:           ${_fmt(sell['total_shipping_charges'])}'));
    bytes.addAll(generator.text(
        'Additional Expense:         ${_fmt(sell['total_additional_expense'])}'));
    bytes.addAll(generator.feed(1));

    bytes.addAll(generator.text('--------- RETURN & DIFFERENCE ---------',
        styles: const PosStyles(bold: true)));
    bytes.addAll(generator.text(
        'Total Purchase Return:       ${_fmt(json['total_purchase_return'])}'));
    bytes.addAll(generator.text(
        'Total Sell Return:           ${_fmt(json['total_sell_return'])}'));

    final diff = json['difference'] ?? {};
    bytes.addAll(
        generator.text('Difference Total:           ${_fmt(diff['total'])}'));
    bytes.addAll(
        generator.text('Difference Due:            ${_fmt(diff['due'])}'));
    bytes.addAll(generator.feed(2));
    bytes.addAll(generator.cut());

    return bytes;
  }

// Helper method to safely format numbers
  String _fmt(dynamic value) {
    if (value == null) return "-";
    try {
      return double.parse(value.toString()).toStringAsFixed(2);
    } catch (e) {
      return value.toString();
    }
  }
}
