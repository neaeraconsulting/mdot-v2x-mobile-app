class TextOverlay {
  int majorFontSize;
  int minorFontSize;
  int xPos;
  int yPos;

  TextOverlay({
    required this.majorFontSize,
    required this.minorFontSize,
    required this.xPos,
    required this.yPos,
  });

  factory TextOverlay.fromJson(Map<String, dynamic> json) {
    return TextOverlay(
      majorFontSize: json['majorFontSize'] ?? 0,
      minorFontSize: json['minorFontSize'] ?? 0,
      xPos: json['xPos'] ?? 0,
      yPos: json['yPos'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'majorFontSize': majorFontSize,
        'minorFontSize': minorFontSize,
        'xPos': xPos,
        'yPos': yPos,
      };
}