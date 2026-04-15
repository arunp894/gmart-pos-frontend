class AllCategoryProductResponseModel {
  List<Category>? category;

  AllCategoryProductResponseModel({this.category});

  AllCategoryProductResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['category'] != null) {
      category = <Category>[];
      json['category'].forEach((v) {
        category!.add(new Category.fromLocalJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.category != null) {
      data['category'] = this.category!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Category {
  int? id;
  String? name;
  dynamic businessId;
  String? shortCode;
  dynamic parentId;
  dynamic createdBy;
  String? categoryType;
  String? description;
  String? slug;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  List<dynamic>? subCategories;
  bool? isAgeLimit;
  String? age;
  String? ageLimitDescription;
  bool? isTimeLimit;
  String? fromTime;
  String? toTime;
  String? timeDescription;

  Category(
      {this.id,
      this.name,
      this.businessId,
      this.shortCode,
      this.parentId,
      this.createdBy,
      this.categoryType,
      this.description,
      this.slug,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.subCategories,
      this.isAgeLimit,
      this.age,
      this.ageLimitDescription,
      this.isTimeLimit,
      this.fromTime,
      this.toTime,
      this.timeDescription});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    businessId = json['business_id'] ?? "0";
    shortCode = json['short_code'];
    parentId = json['parent_id'] ?? "0";
    createdBy = json['created_by'];
    categoryType = json['category_type'];
    description = json['description'];
    slug = json['slug'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    subCategories = json['sub_categories'] ?? [];
    isAgeLimit = json['is_age_limit'] ?? false;
    age = json['age'] ?? "";
    ageLimitDescription = json['age_limit_description'] ?? "";
    isTimeLimit = json['is_time_limit'] ?? false;
    fromTime = json['from_time'] ?? "";
    toTime = json['to_time'] ?? "";
    timeDescription = json['time_description'] ?? "";
  }

  Category.fromLocalJson(Map<String, dynamic> json) {
    id = json['category_id'];
    name = json['category'];
    businessId =
        json['business_id'] != null ? json['business_id'].toString() : "0";
    shortCode = json['short_code'];
    parentId = json['parent_id'] != null ? json['parent_id'].toString() : "0";
    subCategories = json['sub_categories'] ?? [];
    age = json['age_limit'] ?? "";
    ageLimitDescription = json['age_description'] ?? "";
    fromTime = json['from_time'] ?? "";
    toTime = json['to_time'] ?? "";
    timeDescription = json['time_description'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['business_id'] = this.businessId;
    data['short_code'] = this.shortCode;
    data['parent_id'] = this.parentId;
    data['created_by'] = this.createdBy;
    data['category_type'] = this.categoryType;
    data['description'] = this.description;
    data['slug'] = this.slug;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.subCategories != null) {
      data['sub_categories'] =
          this.subCategories!.map((v) => v.toJson()).toList();
    }
    data['is_age_limit'] = this.isAgeLimit;
    data['age'] = this.age;
    data['age_limit_description'] = this.ageLimitDescription;
    data['is_time_limit'] = this.isTimeLimit;
    data['from_time'] = this.fromTime;
    data['to_time'] = this.toTime;
    data['time_description'] = this.timeDescription;
    return data;
  }
}
