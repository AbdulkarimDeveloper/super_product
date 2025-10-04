class Pointx {
  Pointx({
    required this.dx,
    required this.dy,
    required this.type,
    required this.pressure,
  });
  double dx;
  double dy;
  PointxType type;
  double pressure;

  factory Pointx.fromJson(Map<String, dynamic> json) {
    return Pointx(
      dx: json['dx'],
      dy: json['dy'],
      type: PointxType.values[json['Type']],
      pressure: json['pressure'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'dx': dx, 'dy': dy, 'Type': type.index, 'pressure': pressure};
  }
}

enum PointxType { tap, move }
