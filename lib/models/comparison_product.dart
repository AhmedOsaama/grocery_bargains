class ComparisonProduct {
  int id;
  String jumboName;
  String albertName;
  String hoogvlietName;
  int albertId;
  int jumboId;
  int hoogvlietId;

  ComparisonProduct(
      {
        required this.id,
        required this.albertId,
        required this.jumboId,
        required this.hoogvlietId,
        required this.jumboName,
        required this.albertName,
        required this.hoogvlietName,
      });
}
