class SearchResult {
  final String collectionName;
  final Map<String, dynamic> documentData;

  SearchResult({
    required this.collectionName,
    required this.documentData,
  });

  @override
  String toString() {
    return '|||| collectionName: $collectionName   documentData: $documentData\n';
  }
}
