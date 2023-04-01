class ComparisonProduct {
  int id;
  String jumboName;
  String jumboLink;
  String jumboImageURL;
  String jumboPrice;
  String? jumboSize;
  String albertName;
  String albertLink;
  String albertId;
  String albertImageURL;
  String albertPrice;
  String albertSize;

  ComparisonProduct(
      {required this.id,
        required this.albertId,
      required this.albertImageURL,
      required this.albertLink,
      required this.albertName,
      required this.albertPrice,
      required this.albertSize,
      required this.jumboImageURL,
      required this.jumboLink,
      required this.jumboName,
      required this.jumboPrice,
      this.jumboSize});
}
