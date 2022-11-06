//日期单位枚举，
//dayWidth: 不同单位的天宽度不同
enum GanttDateUnit {
  day(dayWidth: 50),
  week(dayWidth: 30),
  month(dayWidth: 8),
  quarter(dayWidth: 3),
  halfYear(dayWidth: 2),
  year(dayWidth: 1);

  const GanttDateUnit({required this.dayWidth});
  //天宽度
  final double dayWidth;
}
