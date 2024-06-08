import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:transport_bilty_generator/constants/constants.dart';
import 'package:transport_bilty_generator/models/bilty.dart';
import 'package:transport_bilty_generator/models/customer.dart';
import 'package:transport_bilty_generator/models/driver.dart';
import 'package:transport_bilty_generator/models/hireChallan.dart';
import 'package:transport_bilty_generator/models/invoice.dart';
import 'package:transport_bilty_generator/models/user.dart';
import 'package:transport_bilty_generator/models/vehicle.dart';
import 'package:transport_bilty_generator/services/shared_pref.dart';
import "package:universal_html/html.dart" as html;
import 'package:get/get.dart';

class BackendAPI {
  final String apiBaseURL =
      "https://backend.agltransport.in";
  final SharedPref prefs = SharedPref();

  // this method logs in user from username and password
  // after getting the jwt token it fetches the account details from jwt token and get
  // all user data from method getaccount details
  Future<dynamic> login(String username, String password) async {
    // body in json
    var body = jsonEncode({"password": password, "username": username});
    var url = "$apiBaseURL/authenticate";

    try {
      http.Response response = await http.post(Uri.parse(url),
          body: body,
          headers: {
            "Accept": "application/json",
            "content-type": "application/json"
          });
      //print(" login : $response.statusCode");
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        //print(data['jwt']);
        // getting account details from jwt token
        var token = data['jwt'];
        prefs.setStringToKey("token", token);
        User user = await getAccountDetails();
        prefs.loginUser(user.email, password);
        return true;
      } else {
        print(response.statusCode);
        print(jsonDecode(response.body));
        return false;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // checking if time since token registered is more than 8 hrs
  Future<dynamic> checkTokenValidity() async {
    int? timeStamp = await prefs.getIntFromKey("timestamp");
    if (timeStamp != null) {
      DateTime before = DateTime.fromMillisecondsSinceEpoch(timeStamp);
      DateTime now = DateTime.now();
      Duration timeDifference = now.difference(before);
      print("Time Diff is ${timeDifference.inHours}");
      if (int.parse(timeDifference.inHours.toString()) > 7) {
        String? email = await prefs.getStringDataFromKey("email");
        String? password = await prefs.getStringDataFromKey("password");

        var login = await this.login(email!, password!);
        if (login == true) {
          print("logged in again");
          return true;
        } else {
          print("didn't need to login");
          return false;
        }
      } else {
        print("Time Less than 8 hours");
        return true;
      }
    }
  }

  // method to get account details from jwt token
  Future<dynamic> getAccountDetails() async {
    var token = await prefs.getStringDataFromKey("token");
    var url = "$apiBaseURL/account/getAccountDetails";
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    try {
      // getting account details
      http.Response response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        User user = User.fromJson(data);
        return user;
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // method to get all the resources from a single api call
  Future<Map<String, dynamic>?> getAllResources() async {
    var token = await prefs.getStringDataFromKey("token");
    var url = "$apiBaseURL/resource/getAllResources";
    var user = await getAccountDetails();
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    try {
      // getting account details
      http.Response response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        List<dynamic> list_customers =
            data['customer'].map((json) => Customer.fromJson(json)).toList();
        List<dynamic> list_vehicle = data['vehicle']
            .map((vehicle) => Vehicle.fromJson(vehicle))
            .toList();
        List<dynamic> list_driver =
            data['driver'].map((json) => Driver.fromJson(json)).toList();
        return {
          "customers": list_customers,
          "vehicles": list_vehicle,
          "drivers": list_driver,
          "user": user
        };
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  // method to get  resources from api common for all resources
  Future<dynamic> getResourcesByResourceName(String resourceName) async {
    var token = await prefs.getStringDataFromKey("token");
    var url = "$apiBaseURL/resource/getAll$resourceName";
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    try {
      http.Response response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data;
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  //method to get all Customers
  Future<List?> getAllCustomers() async {
    var data = await getResourcesByResourceName("Customers");
    if (data != null) {
      List<dynamic> list_customers =
          data.map((json) => Customer.fromJson(json)).toList();
      return list_customers;
    } else {
      return null;
    }
  }

  //method to find customer by searching through name
  Future<List<dynamic>> getCustomerBySearch(String query) async {
    var token = await prefs.getStringDataFromKey("token");
    var url = "$apiBaseURL/resource/searchCustomer?query=$query";
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    try {
      http.Response response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        List<dynamic> list_customers =
            data.map((json) => Customer.fromJson(json)).toList();
        //creating list_customer_names
        return list_customers;
      } else {
        return [];
      }
    } catch (e) {
      print(e.toString());
    }
    return [];
  }

  // method to add customers
  Future<dynamic> addCustomer(Customer customer) async {
    var token = await prefs.getStringDataFromKey("token");
    var url = "$apiBaseURL/resource/addCustomer";
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    // converting the address inside customer to json first
    // List<Address> list_address = customer.address;
    // String address = jsonEncode(list_address);
    var body = jsonEncode(customer);

    try {
      http.Response response =
          await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data;
      } else {
        print(response.statusCode);
        print(jsonDecode(response.body));
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //method to delete customers
  Future<dynamic> deleteCustomer(int customerId) async {
    var token = await prefs.getStringDataFromKey("token");
    var url = "$apiBaseURL/resource/deleteCustomer?customerId=$customerId";
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    try {
      http.Response response =
          await http.delete(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data);
        return data;
      } else {
        print(response.statusCode);
        print(jsonDecode(response.body));
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // method to update customer
  Future<dynamic> updateCustomer(Customer customer) async {
    var token = await prefs.getStringDataFromKey("token");
    var url = "$apiBaseURL/resource/updateCustomer?customerId=${customer.id}";

    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    var body = jsonEncode(customer);
    try {
      http.Response response =
          await http.put(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data);
        return data;
      } else {
        print(response.statusCode);
        print(jsonDecode(response.body));
        return null;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // method to get drivers
  Future<List?> getAllDrivers() async {
    var data = await getResourcesByResourceName("Drivers");
    if (data != null) {
      List<dynamic> list_drivers =
          data.map((json) => Driver.fromJson(json)).toList();
      return list_drivers;
    } else {
      return null;
    }
  }

  //method to get Driver by search
  Future<List<dynamic>> getDriverBySearch(String query) async {
    var token = await prefs.getStringDataFromKey("token");
    var url = "$apiBaseURL/resource/searchDriverName?query=Subham";
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    print(url);
    try {
      http.Response response = await http.get(Uri.parse(url), headers: headers);
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        List<dynamic> list_drivers =
            data.map((json) => Driver.fromJson(json)).toList();
        return list_drivers;
      } else {
        return [];
      }
    } catch (e) {
      print(e.toString());
    }
    return [];
  }

  //method to add drivers
  Future<dynamic> addDriver(Driver driver) async {
    var token = await prefs.getStringDataFromKey("token");
    var url = "$apiBaseURL/resource/addDriver";
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var body = jsonEncode({
      "licenseNumber": driver.licenseNumber,
      "mobileNumber": driver.mobileNumber,
      "name": driver.name
    });
    try {
      http.Response response =
          await http.post(Uri.parse(url), headers: headers, body: body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data;
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // method to delete drivers
  Future<dynamic> deleteDriver(int driverId) async {
    var token = await prefs.getStringDataFromKey("token");
    var url = "$apiBaseURL/resource/deleteDriver?driverId=$driverId";
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    try {
      http.Response response =
          await http.delete(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  //method to update drivers
  Future<dynamic> updateDriver(Driver driver) async {
    var token = await prefs.getStringDataFromKey("token");
    var url = "$apiBaseURL/resource/updateDriver?driverId=${driver.id}";
    print(url);
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var body = jsonEncode(driver);
    try {
      http.Response response =
          await http.put(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data;
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // method to get vehicles
  Future<List?> getAllVechiles() async {
    var data = await getResourcesByResourceName("Vehicles");
    if (data != null) {
      List<dynamic> list_vehicles =
          data.map((vehicle) => Vehicle.fromJson(vehicle)).toList();
      return list_vehicles;
    } else {
      return null;
    }
  }

  // method to get vehicle by number
  Future<List<dynamic>> getVehicleByNumber(String query) async {
    var token = await prefs.getStringDataFromKey("token");
    var url = "$apiBaseURL/resource/getVehicleByNumber?query=$query";
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    try {
      http.Response response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        List<dynamic> list_vehicles =
            data.map((vehicle) => Vehicle.fromJson(vehicle)).toList();
        return list_vehicles;
      } else {
        return [];
      }
    } catch (e) {
      print(e.toString());
    }
    return [];
  }

  // method to add vehicle
  Future<dynamic> addVehicle(Vehicle vehicle) async {
    var token = await prefs.getStringDataFromKey("token");
    var url = "$apiBaseURL/resource/addVehicle";
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var body = jsonEncode(vehicle);
    try {
      // getting account details
      http.Response response =
          await http.post(Uri.parse(url), headers: headers, body: body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data;
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  //method to delete vehicle
  Future<dynamic> deleteVehicle(int vehicleId) async {
    var token = await prefs.getStringDataFromKey("token");
    var url = "$apiBaseURL/resource/deleteVehicle?vehicleId=$vehicleId";
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    try {
      http.Response response =
          await http.delete(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data;
      } else {
        print(response.statusCode);
        print(jsonDecode(response.body));
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //method to update vehicle
  Future<dynamic> updateVehicle(Vehicle vehicle) async {
    var token = await prefs.getStringDataFromKey("token");
    var url = "$apiBaseURL/resource/updateVehicle?vehicleId=${vehicle.id}";
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var body = jsonEncode(vehicle);
    try {
      http.Response response =
          await http.put(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data;
      } else {
        print(response.statusCode);
        print(jsonDecode(response.body));
        return null;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // function to get all bilty details
  Future<List?> getAllBilty() async {
    var token = await prefs.getStringDataFromKey("token");
    var url = "$apiBaseURL/bilty/getAllBilty";
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    try {
      // getting account details
      http.Response response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var list_bilty = data.map((ele) => Bilty.fromJson(ele)).toList();
        return list_bilty;
      } else {
        return [];
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<List?> getAllBiltyByConsigner(int consignerId) async {
    var token = await prefs.getStringDataFromKey("token");
    var url =
        "$apiBaseURL/bilty/getAllBiltyByConsigner?consignerId=$consignerId";
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    try {
      // getting account details
      http.Response response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var list_bilty = data.map((ele) => Bilty.fromJson(ele)).toList();
        return list_bilty;
      } else {
        return [];
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  // function to get bilty by search
  Future<List?> getBiltyBySearch(String query) async {
    var token = await prefs.getStringDataFromKey("token");
    var url = "$apiBaseURL/bilty/getBiltyBySearch?query=$query";
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    try {
      // getting account details
      http.Response response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data);
        var list_bilty = data.map((ele) => Bilty.fromJson(ele)).toList();
        return list_bilty;
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  // function to add bilty
  Future<dynamic> addBilty(Bilty bilty) async {
    var token = await prefs.getStringDataFromKey("token");
    var url = "$apiBaseURL/bilty/addBilty";
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    //converting the object in json
    var body = jsonEncode(bilty);
    try {
      http.Response response =
          await http.post(Uri.parse(url), headers: headers, body: body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data);
        var bilty = Bilty.fromJson(data);
        return bilty;
      } else {
        print(response.statusCode);
        print(jsonDecode(response.body));
        return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  // function to delete bilty
  Future<dynamic> deleteBilty(int biltyId) async {
    var token = await prefs.getStringDataFromKey("token");
    var url = "$apiBaseURL/bilty/deleteBilty?biltyId=$biltyId";
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    try {
      http.Response response =
          await http.delete(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data);
        return data;
      } else {
        print(response.statusCode);
        print(jsonDecode(response.body));
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //function to edit bilty
  Future<dynamic> updateBilty(Bilty bilty) async {
    var token = await prefs.getStringDataFromKey("token");
    var url = "$apiBaseURL/bilty/updateBilty?biltyId=${bilty.id}";
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var body = jsonEncode(bilty);
    try {
      http.Response response =
          await http.put(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data);
        return data;
      } else {
        print(response.statusCode);
        print(jsonDecode(response.body));
        return null;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // function to filter bilty by date and customer
  Future<dynamic> filterBiltyByDate(
      DateTime? startDate, DateTime? endDate) async {
    var token = await prefs.getStringDataFromKey("token");
    var url = "$apiBaseURL/bilty/filterBiltyByDate";
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    //formatting the date time to string
    String? startDateString =
        startDate != null ? convertDateTimeToString(startDate) : null;
    String? endDateString =
        endDate != null ? convertDateTimeToString(endDate) : null;
    var body =
        jsonEncode({"endDate": endDateString, "startDate": startDateString});
    print(body);
    try {
      // getting account details
      http.Response response =
          await http.post(Uri.parse(url), headers: headers, body: body);
      print(response.statusCode.toString());
      print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var list_bilty = data.map((ele) => Bilty.fromJson(ele)).toList();
        return list_bilty;
      } else {
        return [];
      }
    } catch (e) {
      print(e.toString());
    }
    return [];
  }

  Future<dynamic> getTodayBilty() async {
    var list_bilty = filterBiltyByDate(
        DateTime.now().toUtc().subtract(Duration(hours: 5)),
        DateTime.now().toUtc().add(Duration(days: 1)));
    return list_bilty;
  }

  Future<dynamic> getYesterdayBilty() async {
    var list_bilty = filterBiltyByDate(
        DateTime.now().toUtc().subtract(Duration(days: 1)),
        DateTime.now().toUtc());
    return list_bilty;
  }

  Future<dynamic> getThisWeekBilty() async {
    var list_bilty = filterBiltyByDate(
        DateTime.now().toUtc().subtract(Duration(days: 7)),
        DateTime.now().toUtc());
    return list_bilty;
  }

  Future<dynamic> getThisMonthBilty() async {
    var list_bilty = filterBiltyByDate(
        DateTime.now().toUtc().subtract(Duration(days: 30)),
        DateTime.now().toUtc());
    return list_bilty;
  }

  // hireChallan Functions
  Future<dynamic> addHireChallan(HireChallan hirechallan) async {
    var token = await prefs.getStringDataFromKey("token");
    var url = "$apiBaseURL/hireChallan/addHireChallan";
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    //converting the object in json
    var body = jsonEncode(hirechallan);
    print(body);
    try {
      http.Response response =
          await http.post(Uri.parse(url), headers: headers, body: body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data);
        var hireChallan = HireChallan.fromJson(data);
        return hireChallan;
      } else {
        print(response.statusCode);
        print(jsonDecode(response.body));
        return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<List?> getAllHireChallan() async {
    var token = await prefs.getStringDataFromKey("token");
    var url = "$apiBaseURL/hireChallan/getAllHireChallan";
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    try {
      // getting account details
      http.Response response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data);
        var list_hireChallan =
            data.map((ele) => HireChallan.fromJson(ele)).toList();
        return list_hireChallan;
      } else {
        return [];
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<List?> getAllHireChallanByTransporter(int transporterId) async {
    var token = await prefs.getStringDataFromKey("token");
    var url =
        "$apiBaseURL/hireChallan/getAllHireChallanByTransporter?transporterId=$transporterId";
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    try {
      // getting account details
      http.Response response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data);
        var list_hireChallan =
            data.map((ele) => HireChallan.fromJson(ele)).toList();
        return list_hireChallan;
      } else {
        return [];
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  //delete Challan
  Future<dynamic> deleteHireChallan(int hireChallanId) async {
    var token = await prefs.getStringDataFromKey("token");
    var url =
        "$apiBaseURL/hireChallan/deleteHireChallan?hireChallanId=$hireChallanId";
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    try {
      http.Response response =
          await http.delete(Uri.parse(url), headers: headers);
      print(response.statusCode);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data);
        return data;
      } else {
        print(response.statusCode);
        print(jsonDecode(response.body));
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //update Challan
  Future<dynamic> updateHireChallan(HireChallan hireChallan) async {
    var token = await prefs.getStringDataFromKey("token");
    var url =
        "$apiBaseURL/hireChallan/updateHireChallan?hireChallanId=${hireChallan.id}";
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var body = jsonEncode(hireChallan);
    print(body);
    try {
      http.Response response =
          await http.put(Uri.parse(url), headers: headers, body: body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data);
        var hireChallan = HireChallan.fromJson(data);
        return hireChallan;
      } else {
        print(response.statusCode);
        return false;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // invoice functions
  Future<List?> getAllInvoice() async {
    var token = await prefs.getStringDataFromKey("token");
    var url = "$apiBaseURL/invoice/getAllInvoice";
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    try {
      // getting account details
      http.Response response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data);
        var list_invoice = data.map((ele) => Invoice.fromJson(ele)).toList();
        return list_invoice;
      } else {
        return [];
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<dynamic> generateInvoice(Invoice invoice) async {
    var token = await prefs.getStringDataFromKey("token");
    var url = "$apiBaseURL/invoice/generateInvoice";
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var body = jsonEncode(invoice);
    print(body);
    try {
      http.Response response =
          await http.post(Uri.parse(url), headers: headers, body: body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data);
        var invoice = Invoice.fromJson(data);
        return invoice;
        //return true;
      } else {
        print(response.statusCode);
        print(jsonDecode(response.body));
        return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<Map<String, dynamic>?> filterBiltyHireChallanForInvoice(
      int consignerId, String startDate, String endDate) async {
    // getting extra data which is not recieved in this endPoint
    List<dynamic>? list_customer = await getAllCustomers();
    var user = await getAccountDetails();
    var token = await prefs.getStringDataFromKey("token");
    var url = "$apiBaseURL/invoice/filterBiltyHireChallanForInvoice";
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var body = jsonEncode({
      "consignerId": consignerId,
      "endDate": endDate,
      "startDate": startDate
    });
    print(body);
    try {
      // getting account details
      http.Response response =
          await http.post(Uri.parse(url), headers: headers, body: body);
      print(response.statusCode.toString());
      print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(body);
        List<dynamic> list_bilty =
            data['bilty'].map((ele) => Bilty.fromJson(ele)).toList();
        List<dynamic> list_hireChallan = data['hireChallan']
            .map((ele) => HireChallan.fromJson(ele))
            .toList();
        return {
          "bilty": list_bilty,
          "hireChallan": list_hireChallan,
          "customers": list_customer,
          "user": user
        };
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<Map<String, dynamic>?> getAllBiltyAndHireChallan() async {
    List<dynamic>? list_bilty = await getAllBilty();
    List<dynamic>? list_hireChallan = await getAllHireChallan();
    List<dynamic>? list_customer = await getAllCustomers();
    var user = await getAccountDetails();

    return {
      "bilty": list_bilty,
      "hireChallan": list_hireChallan,
      "customers": list_customer,
      "user": user
    };
  }

  Future<dynamic> getInvoiceById(int invoiceId) async {
    var token = await prefs.getStringDataFromKey("token");
    var url = "$apiBaseURL/invoice/getInvoiceById?invoiceId=$invoiceId";
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    try {
      // getting account details
      http.Response response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data);
        var invoice = Invoice.fromJson(data);
        return invoice;
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<dynamic> updateInvoiceStatus(Invoice invoice, String status) async {
    var token = await prefs.getStringDataFromKey("token");
    var url =
        "$apiBaseURL/invoice/updateInvoiceStatus?invoiceId=${invoice.id}&status=$status";
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    try {
      http.Response response = await http.put(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data);
        return data;
      } else {
        print(response.statusCode);
        return false;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<dynamic> addRemoveBiltyHireChallanToInvoice(Invoice invoice) async {
    var token = await prefs.getStringDataFromKey("token");
    var url = "$apiBaseURL/invoice/addRemoveBiltyHireChallanToInvoice";
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var body = jsonEncode(invoice.toUpdateBiltyHireChallanJson());
    print(body);
    try {
      http.Response response =
          await http.post(Uri.parse(url), headers: headers, body: body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data);
        // var invoice = Invoice.fromJson(data);
        // return invoice;
        return data;
        //return true;
      } else {
        print(response.statusCode);
        print(jsonDecode(response.body));
        return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<Map<String, dynamic>?> getAllBiltyAndHireChallanByCustomer(
      int customerId) async {
    List<dynamic>? list_bilty = await getAllBiltyByConsigner(customerId);
    List<dynamic>? list_hireChallan =
        await getAllHireChallanByTransporter(customerId);
    return {
      "bilty": list_bilty,
      "hireChallan": list_hireChallan,
    };
  }

  Future<dynamic> updateInvoice(Invoice invoice) async {
    var token = await prefs.getStringDataFromKey("token");
    var url = "$apiBaseURL/invoice/updateInvoice";
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var body = jsonEncode(invoice.toUpdateInvoiceJson());
    print(body);
    try {
      http.Response response =
          await http.put(Uri.parse(url), headers: headers, body: body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data);
        var invoice = Invoice.fromJson(data);
        return invoice;
      } else {
        print(response.statusCode);
        print(jsonDecode(response.body));
        return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<void> downloadBiltyPDF(int biltyId, String lrNumber) async {

    // show loading dialog box while downloading pdf file
    Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);

    var token = await prefs.getStringDataFromKey("token");
    var url = "$apiBaseURL/bilty/downloadBiltyPdf?biltyId=$biltyId";
    var headers = {'Authorization': 'Bearer $token'};
    try {
      http.Response response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        // Replace 'file.pdf' with the desired file name and extension
        var fileName = lrNumber+".pdf";
        // Create a new blob and save the bytes to it
        final blob = html.Blob([bytes], 'application/octet-stream');
        // Create a download url from the blob
        final url = html.Url.createObjectUrlFromBlob(blob);
        // Create a new anchor element to download the file
        final anchor = html.document.createElement('a') as html.AnchorElement
          ..href = url
          ..download = fileName;
        // Click the anchor to start the download
        html.document.body?.append(anchor);
        anchor.click();
        // Remove the anchor element and the blob url
        html.document.body?.children.remove(anchor);
        html.Url.revokeObjectUrl(url);
        Get.back();
      } else {
        // show error dialog box if file not downloaded
        Get.dialog(AlertDialog(
          title: Text("error".tr),
          content: Text("error_message".tr),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text("cancel".tr),
            )
          ],
        ));
        throw Exception('Failed to download file');
      }
    } catch (e) {
      Get.dialog(AlertDialog(
        title: Text("error".tr),
        content: Text("error_message".tr),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text("cancel".tr),
          )
        ],
      ));
      throw Exception('Failed to download file');
    }
  }

  Future<void> downloadHireChallanPdf(int hireChallanId, String hrNumber) async {
    Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);

    var token = await prefs.getStringDataFromKey("token");
    var url = "$apiBaseURL/hireChallan/downloadHireChallanPdf?hireChallanId=$hireChallanId";
    var headers = {'Authorization': 'Bearer $token'};
    try {
      http.Response response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        // Replace 'file.pdf' with the desired file name and extension
        var fileName = hrNumber+".pdf";
        // Create a new blob and save the bytes to it
        final blob = html.Blob([bytes], 'application/octet-stream');
        // Create a download url from the blob
        final url = html.Url.createObjectUrlFromBlob(blob);
        // Create a new anchor element to download the file
        final anchor = html.document.createElement('a') as html.AnchorElement
          ..href = url
          ..download = fileName;
        // Click the anchor to start the download
        html.document.body?.append(anchor);
        anchor.click();
        // Remove the anchor element and the blob url
        html.document.body?.children.remove(anchor);
        html.Url.revokeObjectUrl(url);
        Get.back();
      } else {
        // show error dialog box if file not downloaded
        Get.dialog(AlertDialog(
          title: Text("error".tr),
          content: Text("error_message".tr),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text("cancel".tr),
            )
          ],
        ));
        throw Exception('Failed to download file');
      }
    } catch (e) {
      Get.dialog(AlertDialog(
        title: Text("error".tr),
        content: Text("error_message".tr),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text("cancel".tr),
          )
        ],
      ));
      throw Exception('Failed to download file');
    }
  }

  Future<void> downloadInvoicePdf(int invoiceId, String invoiceNumber) async {
    Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);

    var token = await prefs.getStringDataFromKey("token");
    var url = "$apiBaseURL/invoice/downloadInvoicePdf?invoiceId=$invoiceId";
    var headers = {'Authorization': 'Bearer $token'};
    try {
      http.Response response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        // Replace 'file.pdf' with the desired file name and extension
        var fileName = invoiceNumber+".pdf";
        // Create a new blob and save the bytes to it
        final blob = html.Blob([bytes], 'application/octet-stream');
        // Create a download url from the blob
        final url = html.Url.createObjectUrlFromBlob(blob);
        // Create a new anchor element to download the file
        final anchor = html.document.createElement('a') as html.AnchorElement
          ..href = url
          ..download = fileName;
        // Click the anchor to start the download
        html.document.body?.append(anchor);
        anchor.click();
        // Remove the anchor element and the blob url
        html.document.body?.children.remove(anchor);
        html.Url.revokeObjectUrl(url);
        Get.back();
      } else {
        // show error dialog box if file not downloaded
        Get.dialog(AlertDialog(
          title: Text("error".tr),
          content: Text("error_message".tr),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text("cancel".tr),
            )
          ],
        ));
        throw Exception('Failed to download file');
      }
    } catch (e) {
      Get.dialog(AlertDialog(
        title: Text("error".tr),
        content: Text("error_message".tr),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text("cancel".tr),
          )
        ],
      ));
      Get.back();
      throw Exception('Failed to download file');
    }
  }
}
