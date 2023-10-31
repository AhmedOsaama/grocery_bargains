class TopInsight {
  ChatList? chatList;
  MostStore? mostStore;
  MostProduct? mostProduct;
  MostUser? mostUser;

  TopInsight({this.chatList, this.mostStore, this.mostProduct, this.mostUser});

  TopInsight.fromJson(Map<String, dynamic> json) {
    chatList = json['chatList'] != null
        ? new ChatList.fromJson(json['chatList'])
        : null;
    mostStore = json['mostStore'] != null
        ? new MostStore.fromJson(json['mostStore'])
        : null;
    mostProduct = json['mostProduct'] != null
        ? new MostProduct.fromJson(json['mostProduct'])
        : null;
    mostUser = json['mostUser'] != null
        ? new MostUser.fromJson(json['mostUser'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.chatList != null) {
      data['chatList'] = this.chatList!.toJson();
    }
    if (this.mostStore != null) {
      data['mostStore'] = this.mostStore!.toJson();
    }
    if (this.mostProduct != null) {
      data['mostProduct'] = this.mostProduct!.toJson();
    }
    if (this.mostUser != null) {
      data['mostUser'] = this.mostUser!.toJson();
    }
    return data;
  }
}

class ChatList {
  int? size;
  String? listName;

  ChatList({this.size, this.listName});

  ChatList.fromJson(Map<String, dynamic> json) {
    size = json['size'];
    listName = json['list_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['size'] = this.size;
    data['list_name'] = this.listName;
    return data;
  }
}

class MostStore {
  String? storeName;
  int? productNums;

  MostStore({this.storeName, this.productNums});

  MostStore.fromJson(Map<String, dynamic> json) {
    storeName = json['store_name'];
    productNums = json['product_nums'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['store_name'] = this.storeName;
    data['product_nums'] = this.productNums;
    return data;
  }
}

class MostProduct {
  String? productName;
  int? nums;

  MostProduct({this.productName, this.nums});

  MostProduct.fromJson(Map<String, dynamic> json) {
    productName = json['product_name'];
    nums = json['nums'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_name'] = this.productName;
    data['nums'] = this.nums;
    return data;
  }
}

class MostUser {
  String? userName;
  int? nums;

  MostUser({this.userName, this.nums});

  MostUser.fromJson(Map<String, dynamic> json) {
    userName = json['user_name'];
    nums = json['nums'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_name'] = this.userName;
    data['nums'] = this.nums;
    return data;
  }
}
