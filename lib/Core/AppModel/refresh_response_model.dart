class RefreshResponseModel {
  String? access;
  User? user;

  RefreshResponseModel({this.access, this.user});

  RefreshResponseModel.fromJson(Map<String, dynamic> json) {
    access = json['access'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['access'] = this.access;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? email;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  int? department;

  User(
      {this.id,
        this.email,
        this.firstName,
        this.lastName,
        this.phoneNumber,
        this.department});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    phoneNumber = json['phone_number'];
    department = json['department'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['phone_number'] = this.phoneNumber;
    data['department'] = this.department;
    return data;
  }
}
