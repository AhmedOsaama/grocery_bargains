class Insight {
  double? totalSpent;
  double? totalSaved;
  int? totalSpentIncrease;
  int? totalSavedIncrease;
  Map? categorySum;
  MostExpensiveProduct? mostExpensiveProduct;

  Insight(
      {this.totalSpent,
        this.totalSaved,
        this.totalSpentIncrease,
        this.totalSavedIncrease,
        this.categorySum,
        this.mostExpensiveProduct});

  Insight.fromJson(Map<String, dynamic> json) {
    print("FROM JSON: ${json['totalSpent']}");
    totalSpent = json['totalSpent'].toDouble();
    totalSaved = json['totalSaved'].toDouble();
    totalSpentIncrease = json['totalSpent_increase'];
    totalSavedIncrease = json['totalSaved_increase'];
    categorySum = json['categorySum'];
    mostExpensiveProduct = json['mostExpensiveProduct'] != null
        ? new MostExpensiveProduct.fromJson(json['mostExpensiveProduct'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalSpent'] = this.totalSpent;
    data['totalSaved'] = this.totalSaved;
    data['totalSpent_increase'] = this.totalSpentIncrease;
    data['totalSaved_increase'] = this.totalSavedIncrease;
    if (this.categorySum != null) {
      data['categorySum'] = this.categorySum!;
    }
    if (this.mostExpensiveProduct != null) {
      data['mostExpensiveProduct'] = this.mostExpensiveProduct!.toJson();
    }
    return data;
  }
}



class MostExpensiveProduct {
  String? productName;
  double? price;

  MostExpensiveProduct({this.productName, this.price});

  MostExpensiveProduct.fromJson(Map<String, dynamic> json) {
    productName = json['product_name'];
    price = json['price'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_name'] = this.productName;
    data['price'] = this.price;
    return data;
  }
}
