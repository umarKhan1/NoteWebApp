/// Dashboard statistics entity
class DashboardStats {

  // ignore: public_member_api_docs
  const DashboardStats({
    required this.totalNotes,
    required this.todayNotes,
    required this.totalCategories,
    required this.pinnedNotes,
  });
  /// Total number of notes
  final int totalNotes;
  
  /// Notes created today
  final int todayNotes;
  
  /// Total categories
  final int totalCategories;
  
  /// Pinned notes count
  final int pinnedNotes;
}
