class LoginResponseModel {
  List<Locations>? locations;
  List<Locations>? allLocation;
  User? user;
  String? accessToken;
  PosSettings? posSettings;

  LoginResponseModel(
      {this.locations, this.user, this.accessToken, this.posSettings});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['locations'] != null) {
      locations = <Locations>[];
      json['locations'].forEach((v) {
        locations!.add(new Locations.fromJson(v));
      });
    }
    if (json['all_location'] != null) {
      allLocation = <Locations>[];
      json['all_location'].forEach((v) {
        allLocation!.add(new Locations.fromJson(v));
      });
    }
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    accessToken = json['access_token'];
    posSettings = json['pos_settings'] != null
        ? new PosSettings.fromJson(json['pos_settings'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.locations != null) {
      data['locations'] = this.locations!.map((v) => v.toJson()).toList();
    }
    if (this.allLocation != null) {
      data['all_location'] = this.allLocation!.map((v) => v.toJson()).toList();
    }
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['access_token'] = this.accessToken;
    if (this.posSettings != null) {
      data['pos_settings'] = this.posSettings!.toJson();
    }
    return data;
  }
}

class PosSettings {
  List<String>? cashDenominations;

  PosSettings({this.cashDenominations});

  PosSettings.fromJson(Map<String, dynamic> json) {
    cashDenominations = json['cash_denominations'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cash_denominations'] = this.cashDenominations;
    return data;
  }
}

class Locations {
  int? id;
  int? businessId;
  String? locationId;
  String? name;
  String? landmark;
  String? country;
  String? state;
  String? city;
  String? zipCode;
  CashRegister? cashRegister;
  List<Payment>? payment;
  Media? media;
  String? taxType;
  String? taxRate;
  int? isTaxEnable;

  Locations(
      {this.id,
      this.businessId,
      this.locationId,
      this.name,
      this.landmark,
      this.country,
      this.state,
      this.city,
      this.zipCode,
      this.cashRegister,
      this.payment,
      this.media,
      this.taxType,
      this.taxRate,
      this.isTaxEnable});

  Locations.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    businessId = json['business_id'];
    locationId = json['location_id'];
    taxType = json["tax_type"];
    taxRate = json["tax_rate"];
    isTaxEnable = json["is_tax_enable"];
    name = json['name'];
    landmark = json['landmark'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    zipCode = json['zip_code'];
    cashRegister = json['cashRegister'] != null
        ? new CashRegister.fromJson(json['cashRegister'])
        : null;
    if (json['payment'] != null) {
      payment = <Payment>[];
      json['payment'].forEach((v) {
        payment!.add(new Payment.fromJson(v));
      });
    }
    media = json['media'] != null ? new Media.fromJson(json['media']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['business_id'] = this.businessId;
    data['location_id'] = this.locationId;
    data['tax_type'] = this.taxType;
    data['is_tax_enable'] = this.isTaxEnable;
    data['tax_rate'] = this.taxRate;
    data['name'] = this.name;
    data['landmark'] = this.landmark;
    data['country'] = this.country;
    data['state'] = this.state;
    data['city'] = this.city;
    data['zip_code'] = this.zipCode;
    if (this.cashRegister != null) {
      data['cashRegister'] = this.cashRegister!.toJson();
    }
    if (this.payment != null) {
      data['payment'] = this.payment!.map((v) => v.toJson()).toList();
    }
    if (this.media != null) {
      data['media'] = this.media!.toJson();
    }
    return data;
  }
}

class Payment {
  String? type;
  String? key;

  Payment({this.type, this.key});

  Payment.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    key = json['key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['key'] = this.key;
    return data;
  }
}

class Media {
  String? displayName;
  String? displayUrl;

  Media({this.displayName, this.displayUrl});

  Media.fromJson(Map<String, dynamic> json) {
    displayName = json['display_name'];
    displayUrl = json['display_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['display_name'] = this.displayName;
    data['display_url'] = this.displayUrl;
    return data;
  }
}

class CashRegister {
  int? id;
  String? businessId;
  String? locationId;
  String? userId;
  String? status;

  CashRegister(
      {this.id, this.businessId, this.locationId, this.userId, this.status});

  CashRegister.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    businessId = json['business_id'].toString();
    locationId = json['location_id'].toString();
    userId = json['user_id'].toString();
    status = json['status'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['business_id'] = this.businessId;
    data['location_id'] = this.locationId;
    data['user_id'] = this.userId;
    data['status'] = this.status;
    return data;
  }
}

class User {
  int? id;
  String? userType;
  String? surname;
  String? firstName;
  String? lastName;
  String? username;
  String? email;
  String? language;

  User(
      {this.id,
      this.userType,
      this.surname,
      this.firstName,
      this.lastName,
      this.username,
      this.email,
      this.language});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userType = json['user_type'];
    surname = json['surname'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    username = json['username'];
    email = json['email'];
    language = json['language'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_type'] = this.userType;
    data['surname'] = this.surname;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['username'] = this.username;
    data['email'] = this.email;
    data['language'] = this.language;
    return data;
  }
}
