class FacesCompare {
  String sourceImage;
  String targetImage;
  double similarityThreshold;

  FacesCompare({this.sourceImage, this.targetImage, this.similarityThreshold});

  Map<String, dynamic> toJson() {
    return {
      'sourceImage': sourceImage,
      'targetImage': targetImage,
      'similarityThreshold': similarityThreshold
    };
  }
}
