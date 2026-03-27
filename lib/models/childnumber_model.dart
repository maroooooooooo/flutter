class ChildNumberModel {
  final int minValue;
  final int maxValue;

  const ChildNumberModel({
    this.minValue = 1,
    this.maxValue = 10, // ← change this to add more numbers
  });

  List<int> get values =>
      List.generate(maxValue - minValue + 1, (i) => minValue + i);
}