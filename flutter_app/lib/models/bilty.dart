import 'dart:convert';

import 'package:transport_bilty_generator/models/address.dart';
import 'package:transport_bilty_generator/models/company.dart';
import 'package:transport_bilty_generator/models/customer.dart';
import 'package:transport_bilty_generator/models/description.dart';
import 'package:transport_bilty_generator/models/driver.dart';
import 'package:transport_bilty_generator/models/user.dart';
import 'package:transport_bilty_generator/models/vehicle.dart';

class Bilty {
  final int? id;
  final String? lrNumber;
  final Company? company;
  final Vehicle? vehicle;
  final Driver? driver;
  final Customer? consigner;
  final Customer? consignee;
  final Address? consignerAddress;
  final Address? consigneeAddress;
  final String? pickupDate;

  //final String? unloadDate;
  final List<dynamic>? description;
  final String? insuranceNumber;
  final String? invoiceNumber;
  final String? invoiceValue;
  final String? ewayBillNumber;
  final String? ewayBillDate;
  final String? biltyType;
  final bool? isFreight;
  final int? freight;
  final int? billtyCharges;
  final int? totalAmount;
  final int? advance;

  //final int? gstAmount;
  final int? grandTotal;
  final String? billTo;
  final String? receiverName;
  final String? receiverContact;
  final String? remarks;
  final String? createdTime;
  final User? createdBy;
  final String? lastUpdatedTime;
  final String? netWeight;
  final String? grossWeight;

  const Bilty(
      {required this.id,
      required this.lrNumber,
      required this.company,
      required this.vehicle,
      required this.driver,
      required this.consigner,
      required this.consignee,
      required this.consignerAddress,
      required this.consigneeAddress,
      required this.pickupDate,
      //required this.unloadDate,
      required this.description,
      required this.insuranceNumber,
      required this.invoiceNumber,
      required this.invoiceValue,
      required this.ewayBillNumber,
      required this.ewayBillDate,
      required this.biltyType,
      required this.isFreight,
      required this.freight,
      required this.billtyCharges,
      required this.totalAmount,
      required this.advance,
      //required this.gstAmount,
      required this.grandTotal,
      required this.billTo,
      required this.receiverName,
      required this.receiverContact,
      required this.remarks,
      required this.createdBy,
      required this.createdTime,
      required this.lastUpdatedTime,
      required this.netWeight,
      required this.grossWeight});

  factory Bilty.fromJson(Map<String, dynamic> json) {
    return Bilty(
      id: json['id'],
      lrNumber: json['lrNumber'],
      company:
          json['company'] != null ? Company.fromJson(json['company']) : null,
      vehicle:
          json['vehicle'] != null ? Vehicle.fromJson(json['vehicle']) : null,
      driver: json['driver'] != null ? Driver.fromJson(json['driver']) : null,
      consigner: json['consigner'] != null
          ? Customer.fromJson(json['consigner'])
          : null,
      consignee: json['consignee'] != null
          ? Customer.fromJson(json['consignee'])
          : null,
      consignerAddress: json['consignerAddress'] != null
          ? Address.fromJson(json['consignerAddress'])
          : null,
      consigneeAddress: json['consigneeAddress'] != null
          ? Address.fromJson(json['consigneeAddress'])
          : null,
      pickupDate: json['pickupDate'],
      //unloadDate: json['unloadingDate'],
      description: json['description']
          .map((description) => Description.fromJson(description))
          .toList(),
      insuranceNumber: json['insuranceNumber'],
      invoiceNumber: json['invoiceNumber'],
      invoiceValue: json['invoiceValue'],
      ewayBillNumber: json['ewayBillNumber'],
      ewayBillDate: json['ewayBillDate'],
      biltyType: json['biltyType'],
      isFreight: json['isFreight'],
      freight: json['freight'],
      billtyCharges: json['billtyCharges'],
      totalAmount: json['totalAmount'],
      advance: json['advance'],
      // gstAmount: json['gstAmount'],
      grandTotal: json['grandTotal'],
      billTo: json['billTo'],
      receiverName: json['receiverName'],
      receiverContact: json['receiverContact'],
      remarks: json['remarks'],
      createdBy: json['createdBy'] != null
          ? User.fromJson(json['createdBy'])
          : User.fromJson(json['createdBy']),
      createdTime: json['createdTime'],
      lastUpdatedTime: json['lastUpdatedTime'],
      netWeight: json['netWeight'],
      grossWeight: json['grossWeight'],
    );
  }

  // this functino is yet to be edited for later changes in bilty object in API
  Map<String, dynamic> toJson() {
    //converting every object used in json first
    // var jsonCompany= jsonEncode(company);
    // var jsonVehicle = jsonEncode(vehicle);
    // var jsonDriver = jsonEncode(driver);
    // var jsonConsigner = jsonEncode(consigner);
    // var jsonConsignee = jsonEncode(consignee);
    var jsonDescription =
        description?.map((e) => jsonDecode(jsonEncode(e))).toList();
    //var jsonConsignerAddress = jsonEncode(consignerAddress);
    //var jsonConsigneeAddress = jsonEncode(consigneeAddress);

    return {
      "advance": advance,
      "billTo": billTo,
      "billtyCharges": billtyCharges,
      "companyId": company?.id,
      "consignerAddressId": consignerAddress?.id,
      "consigneeAddressId": consigneeAddress?.id,
      "consigneeId": consignee?.id,
      "consignerId": consigner?.id,
      "description": jsonDescription,
      "driverId": driver?.id,
      "ewayBillDate": ewayBillDate,
      "ewayBillNumber": ewayBillNumber,
      "biltyType": biltyType,
      "isFreight": isFreight,
      "freight": freight,
      "grandTotal": grandTotal,
      "grossWeight": grossWeight,
      //"gstAmount": gstAmount,
      "insuranceNumber": insuranceNumber,
      "invoiceNumber": invoiceNumber,
      "invoiceValue": invoiceValue,
      "netWeight": netWeight,
      "pickupDate": pickupDate,
      "receiverContact": receiverContact,
      "receiverName": receiverName,
      "remarks": remarks,
      "totalAmount": totalAmount,
      //"unloadingDate": unloadDate,
      "vehicleId": vehicle?.id
    };
  }
}
