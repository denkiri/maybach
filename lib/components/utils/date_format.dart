String _formatDate(dynamic date) {
  try {
    DateTime dateTime;
    if (date is String) {
      dateTime = DateTime.parse(date);
    } else if (date is DateTime) {
      dateTime = date;
    } else {
      return 'Invalid date';
    }
    return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
  } catch (e) {
    return 'Invalid date';
  }
}