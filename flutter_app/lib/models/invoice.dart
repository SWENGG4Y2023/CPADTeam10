import 'package:transport_bilty_generator/models/bilty.dart';
import 'package:transport_bilty_generator/models/company.dart';
import 'package:transport_bilty_generator/models/customer.dart';
import 'package:transport_bilty_generator/models/hireChallan.dart';
import 'package:transport_bilty_generator/models/user.dart';

class Invoice {
  final List<dynamic>? listBilty;
  final List<dynamic>? listHireChallan;
  final int? id;
  final String? invoiceNumber;
  final double? invoiceValue;
  final int? suffixInvoiceNumber;
  final User? createdBy;
  final Company? company;
  final String? createdTime;
  final Customer? customer;
  final String? invoiceStatus;
  final String? invoiceDate;
  final bool? isTaxTypeIgst;
  final double? gstPercentage;
  final double? sgst;
  final double? igst;
  final double? cgst;
  final String? voucherNumber;
  final String? otherChargesDescription;
  final double? otherChargesAmount;
  final bool? isPaid;
  final String? paidDate;

  const Invoice(
      {required this.listBilty,
      required this.listHireChallan,
      required this.id,
      required this.invoiceNumber,
      required this.invoiceValue,
      required this.suffixInvoiceNumber,
      required this.createdBy,
      required this.company,
      required this.createdTime,
      required this.customer,
      required this.invoiceStatus,
      required this.invoiceDate,
      required this.isTaxTypeIgst,
      required this.gstPercentage,
      required this.sgst,
      required this.igst,
      required this.cgst,
      required this.voucherNumber,
      required this.otherChargesDescription,
      required this.otherChargesAmount,
      required this.isPaid,
      required this.paidDate});

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
        listBilty: json['bilty'].map((bilty) => Bilty.fromJson(bilty)).toList(),
        listHireChallan: json['hireChallan']
            .map((hireChallan) => HireChallan.fromJson(hireChallan))
            .toList(),
        id: json['id'],
        invoiceNumber: json['invoiceNumber'],
        invoiceValue: json['totalInvoiceAmount'],
        suffixInvoiceNumber: json['suffixInvoiceNumber'],
        createdBy:
            json['createdBy'] != null ? User.fromJson(json['createdBy']) : null,
        company:
            json['company'] != null ? Company.fromJson(json['company']) : null,
        createdTime: json['createdTime'],
        invoiceDate: json['invoiceDate'],
        customer: json['customer'] != null
            ? Customer.fromJson(json['customer'])
            : null,
        invoiceStatus: json['invoiceStatus'],
        isTaxTypeIgst: json['isTaxTypeIgst'],
        sgst: json['sgst'],
        gstPercentage: json['gstPercentage'],
        igst: json['igst'],
        cgst: json['cgst'],
        voucherNumber: json['voucherNumber'],
        otherChargesDescription: json['otherChargesDescription'],
        otherChargesAmount: json['otherChargesAmount'],
        isPaid: json['isPaid'],
        paidDate: json['paidDate']);
  }

  Map<String, dynamic> toJson() {
    var listBiltyId = listBilty?.map((bilty) => bilty.id).toList();
    var listHireChallanId =
        listHireChallan?.map((hireChallan) => hireChallan.id).toList();
    return {
      "biltyIds": listBiltyId,
      "companyId": company?.id,
      "customerId": customer?.id,
      "hireChallanIds": listHireChallanId,
      "gstPercentage": gstPercentage,
      "invoiceStatus": invoiceStatus,
      "isTaxTypeIgst": isTaxTypeIgst,
      "voucherNumber": voucherNumber,
      "invoiceDate": invoiceDate,
      "otherChargesDescription": otherChargesDescription,
      "otherChargesAmount": otherChargesAmount,
    };
  }

  Map<String, dynamic> toUpdateBiltyHireChallanJson() {
    var listBiltyId = listBilty?.map((bilty) => bilty.id).toList();
    var listHireChallanId =
        listHireChallan?.map((hireChallan) => hireChallan.id).toList();
    return {
      "biltyIds": listBiltyId,
      "hireChallanIds": listHireChallanId,
      "invoiceId": id
    };
  }

  Map<String, dynamic> toUpdateInvoiceJson() {
    return {
      "invoiceId": id,
      "invoiceStatus": invoiceStatus,
      "invoiceDate": invoiceDate,
      "voucherNumber": voucherNumber,
      "otherChargesDescription": otherChargesDescription,
      "isPaid": isPaid,
      "paidDate": paidDate,
    };
  }
}
