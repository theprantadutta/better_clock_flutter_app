// Helper function to calculate unique offset for each day
int getDayOffset(String day) {
  switch (day) {
    case 'Monday':
      return DateTime.monday;
    case 'Tuesday':
      return DateTime.tuesday;
    case 'Wednesday':
      return DateTime.wednesday;
    case 'Thursday':
      return DateTime.thursday;
    case 'Friday':
      return DateTime.friday;
    case 'Saturday':
      return DateTime.saturday;
    case 'Sunday':
      return DateTime.sunday;
    default:
      return 0;
  }
}
