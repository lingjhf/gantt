
## Features



## Getting started



## Usage



```dart
Gantt(
    startDate: DateTime(2022, 1, 4),
    endDate: DateTime(2022, 1, 20),
    data: [
      GanttTaskData(
        startDate: DateTime(2022, 1, 5),
        endDate: DateTime(2022, 1, 10),
      ),
      GanttTaskData(
        startDate: DateTime(2022, 1, 6),
        endDate: DateTime(2022, 1, 6),
      ),
      GanttMilestoneData(date: DateTime(2022, 1, 10)),
      GanttTaskData(
        startDate: DateTime(2022, 1, 7),
        endDate: DateTime(2022, 1, 11),
      )
    ],
)
```

## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.
