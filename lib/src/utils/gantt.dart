int getStartIndex(double left, double dayWidth) {
  return (left / dayWidth).round();
}

int getEndIndex(double left, double width, double dayWidth) {
  return ((left + width) / dayWidth).round();
}

double getAlignLeft(double left, double dayWidth) {
  return (left / dayWidth).round() * dayWidth;
}
