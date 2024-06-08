import 'package:transport_bilty_generator/models/company.dart';
import 'package:transport_bilty_generator/models/customer.dart';
import 'package:transport_bilty_generator/models/driver.dart';
import 'package:transport_bilty_generator/models/user.dart';
import 'package:transport_bilty_generator/models/vehicle.dart';

class HireChallan {
  final int? id;
  final String? hireChallanNumber;
  final Company? company;
  final User? createdBy;
  final String? createdTime;
  final Vehicle? vehicle;
  final int? advanceInBank;
  final String? advanceInBankDate;
  final int? advanceInCash;
  final String? advanceInCashDate;
  final int? balance;

  //final String? balanceDate;
  final String? balanceType;

  //final double? cgst;
  //final String? cgstDate;
  final Driver? driver;
  final int? driveAdvanceCashbyParty;
  final String? driveAdvanceCashbyPartyDate;
  final String? fromSource;

  // final double? igst;
  // final String? igstDate;
  final bool isBalance;

  //final bool? isTaxTypeIGST;
  final String? loadingDate;
  final String? personDesignation;
  final String? personName;
  final String? personNumber;
  final String? rate;
  final String? remarks;

  // final double? sgst;
  // final String? sgstDate;
  final int? suffixHireChallanNumber;
  final int? tds;

  //final String? tdsDate;
  final String? toDestination;
  final int? totalAdvance;

  //final String? totalAdvanceDate;
  final int? totalBalance;

  //final String? totalBalanceDate;
  final int? totalBalancePaid;
  final String? totalBalancePaidDate;
  final int? totalDeduction;

  //final String? totalDeductionDate;
  final int? totalFreight;
  final String? totalFreightDate;
  final int? totalFreightWithTax;

  //final String? totalFreightWithTaxDate;
  final Customer? transporter;
  final String? unloadingDate;
  final String? weight;

  //final double? gstPercentage;
  final int? labourAndParkingCharges;

  const HireChallan({
    required this.id,
    required this.hireChallanNumber,
    required this.company,
    required this.createdBy,
    required this.createdTime,
    required this.vehicle,
    required this.advanceInBank,
    required this.advanceInBankDate,
    required this.advanceInCash,
    required this.advanceInCashDate,
    required this.balance,
    //required this.balanceDate,
    required this.balanceType,
    // required this.cgst,
    // required this.cgstDate,
    required this.driver,
    required this.driveAdvanceCashbyParty,
    required this.driveAdvanceCashbyPartyDate,
    required this.fromSource,
    //required this.gstPercentage,
    // required this.igst,
    // required this.igstDate,
    required this.isBalance,
    required this.loadingDate,
    required this.personDesignation,
    required this.personName,
    required this.personNumber,
    required this.rate,
    required this.remarks,
    // required this.sgst,
    // required this.sgstDate,
    required this.suffixHireChallanNumber,
    required this.tds,
    //required this.tdsDate,
    required this.toDestination,
    required this.totalAdvance,
    //required this.totalAdvanceDate,
    required this.totalBalance,
    //required this.totalBalanceDate,
    required this.totalBalancePaid,
    required this.totalBalancePaidDate,
    required this.totalDeduction,
    //required this.totalDeductionDate,
    required this.totalFreight,
    required this.totalFreightDate,
    required this.totalFreightWithTax,
    //required this.totalFreightWithTaxDate,
    required this.transporter,
    required this.unloadingDate,
    required this.weight,
    // required this.isTaxTypeIGST
    required this.labourAndParkingCharges,
  });

  factory HireChallan.fromJson(Map<String, dynamic> json) {
    return HireChallan(
      id: json['id'],
      hireChallanNumber: json['hireChallanNumber'],
      company:
          json['company'] != null ? Company.fromJson(json['company']) : null,
      createdBy:
          json['createdBy'] != null ? User.fromJson(json['createdBy']) : null,
      createdTime: json['createdTime'],
      vehicle:
          json['vehicle'] != null ? Vehicle.fromJson(json['vehicle']) : null,
      advanceInBank: json['advanceInBank'],
      advanceInBankDate: json['advanceInBankDate'],
      advanceInCash: json['advanceInCash'],
      advanceInCashDate: json['advanceInCashDate'],
      balance: json['balance'],
      //balanceDate: json['balanceDate'],
      balanceType: json['balanceType'],
      // cgst: json['cgst'],
      // cgstDate: json['cgstDate'],
      driver: json['driver'] != null ? Driver.fromJson(json['driver']) : null,
      driveAdvanceCashbyParty: json['driveAdvanceCashbyParty'],
      driveAdvanceCashbyPartyDate: json['driveAdvanceCashbyPartyDate'],
      fromSource: json['fromSource'],
      //gstPercentage: json['gstPercentage'],
      // igst: json['igst'],
      // igstDate: json['igstDate'],
      isBalance: json['isBalance'],
      // isTaxTypeIGST: json['isTaxTypeIgst'],
      loadingDate: json['loadingDate'],
      personDesignation: json['personDesignation'],
      personName: json['personName'],
      personNumber: json['personNumber'],
      rate: json['rate'],
      remarks: json['remarks'],
      // sgst: json['sgst'],
      // sgstDate: json['sgstDate'],
      suffixHireChallanNumber: json['suffixHireChallanNumber'],
      tds: json['tds'],
      //tdsDate: json['tdsDate'],
      toDestination: json['toDestination'],
      totalAdvance: json['totalAdvance'],
      //totalAdvanceDate: json['totalAdvanceDate'],
      totalBalance: json['totalBalance'],
      //totalBalanceDate: json['totalBalanceDate'],
      totalBalancePaid: json['totalBalancePaid'],
      totalBalancePaidDate: json['totalBalancePaidDate'],
      totalDeduction: json['totalDeduction'],
      //totalDeductionDate: json['totalDeductionDate'],
      totalFreight: json['totalFreight'],
      totalFreightDate: json['totalFreightDate'],
      totalFreightWithTax: json['totalFreightWithTax'],
      //totalFreightWithTaxDate: json['totalFreightWithTaxDate'],
      transporter: json['transporter'] != null
          ? Customer.fromJson(json['transporter'])
          : null,
      unloadingDate: json['unloadingDate'],
      weight: json['weight'],
      labourAndParkingCharges: json['labourAndParkingCharges'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "advanceInBank": advanceInBank,
      "advanceInBankDate": advanceInBankDate,
      "advanceInCash": advanceInCash,
      "advanceInCashDate": advanceInCashDate,
      "balance": balance,
      //"balanceDate": balanceDate,
      "balanceType": balanceType,
      // "cgst": cgst,
      // "cgstDate": cgstDate,
      "companyId": company!.id,
      "driveAdvanceCashbyParty": driveAdvanceCashbyParty,
      "driveAdvanceCashbyPartyDate": driveAdvanceCashbyPartyDate,
      "driverId": driver != null ? driver!.id : null,
      "fromSource": fromSource,
      //"gstPercentage": gstPercentage,
      // "igst": igst,
      // "igstDate": igstDate,
      "isBalance": isBalance,
      // "isTaxTypeIgst": isTaxTypeIGST,
      "loadingDate": loadingDate,
      "personDesignation": personDesignation,
      "personName": personName,
      "personNumber": personNumber,
      "rate": rate,
      "remarks": remarks,
      // "sgst": sgst,
      // "sgstDate": sgstDate,
      "tds": tds,
      //"tdsDate": tdsDate,
      "toDestination": toDestination,
      "totalAdvance": totalAdvance,
      //"totalAdvanceDate": totalAdvanceDate,
      "totalBalance": totalBalance,
      //"totalBalanceDate": totalBalanceDate,
      "totalBalancePaid": totalBalancePaid,
      "totalBalancePaidDate": totalBalancePaidDate,
      "totalDeduction": totalDeduction,
      //"totalDeductionDate": totalDeductionDate,
      "totalFreight": totalFreight,
      "totalFreightDate": totalFreightDate,
      "totalFreightWithTax": totalFreightWithTax,
      //"totalFreightWithTaxDate": totalFreightWithTaxDate,
      "transporterId": transporter != null ? transporter!.id : null,
      "unloadingDate": unloadingDate,
      "vehicleId": vehicle != null ? vehicle!.id : null,
      "weight": weight,
      "labourAndParkingCharges": labourAndParkingCharges
    };
  }
}
