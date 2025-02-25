class Filter {
  final String id;
  final FilterType type;
  double? slider1;
  double? slider1Min;
  double? slider1Max;
  int? slider1div;

  double? slider2;
  double? slider2Min;
  double? slider2Max;
  int? slider2div;

  Filter({
    required this.id,
    required this.type,
    this.slider1,
    this.slider1Min,
    this.slider1Max,
    this.slider1div,
    this.slider2,
    this.slider2Min,
    this.slider2Max,
    this.slider2div,
  });
  void setSlider1(double val) {
    slider1 = (val * 100).truncateToDouble() / 100; // Sonuç: 4.05
  }

  void setSlider2(double val) {
    slider2 = (val * 100).truncateToDouble() / 100; // Sonuç: 4.05
  }

  @override
  String toString() {
    return 'Filter(id: $id, type: $type, slider1: $slider1, slider1Min: $slider1Min, slider1Max: $slider1Max, slider2: $slider2, slider2Min: $slider2Min, slider2Max: $slider2Max)';
  }
}

enum FilterType { value, slider, doubleSlider }
