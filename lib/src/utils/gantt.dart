int getStartIndex(double left, double dayWidth) {
  return (left / dayWidth).round();
}

int getEndIndex(double left, double width, double dayWidth) {
  return ((left + width) / dayWidth).round();
}

//获取对齐的位置
double getIndexkLeft(int index, double dayWidth) {
  return index * dayWidth;
}

double getAlignLeft(double left, double dayWidth) {
  return (left / dayWidth).round() * dayWidth;
}
