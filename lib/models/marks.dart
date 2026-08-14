class MarksModel {
  final String subjectCode;
  final String subjectName;
  final double cia1;
  final double cia2;
  final double cia3;
  final double maxMarks;

  const MarksModel({
    required this.subjectCode,
    required this.subjectName,
    required this.cia1,
    required this.cia2,
    required this.cia3,
    this.maxMarks = 100.0,
  });

  double get average => (cia1 + cia2 + cia3) / 3.0;

  String get grade {
    final avg = average;
    if (avg >= 90) return 'O (Outstanding)';
    if (avg >= 80) return 'A+ (Excellent)';
    if (avg >= 70) return 'A (Very Good)';
    if (avg >= 60) return 'B+ (Good)';
    if (avg >= 50) return 'B (Pass)';
    return 'RA (Re-appear)';
  }
}
