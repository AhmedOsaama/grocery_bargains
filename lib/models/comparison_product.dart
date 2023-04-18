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
  String hoogvlietName;
  String hoogvlietLink;
  String hoogvlietOldPrice;
  String hoogvlietImageURL;
  String hoogvlietPrice;
  String hoogvlietSize;

  ComparisonProduct(
      {required this.id,
        required this.albertId,
      required this.albertImageURL,
      required this.albertLink,
      required this.albertName,
      required this.albertPrice,
      required this.albertSize,
        required this.hoogvlietImageURL,
        required this.hoogvlietLink,
        required this.hoogvlietOldPrice,
        required this.hoogvlietName,
        required this.hoogvlietPrice,
        required this.hoogvlietSize,
      required this.jumboImageURL,
      required this.jumboLink,
      required this.jumboName,
      required this.jumboPrice,
      this.jumboSize});
}
