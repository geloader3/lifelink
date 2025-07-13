import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class AnnouncementController extends GetxController {
  final DatabaseReference _announcementsRef = FirebaseDatabase.instance.ref('announcements');
  
  // Get announcements for a specific department
  Stream<DatabaseEvent> getAnnouncementsStream(String department) {
    return _announcementsRef.child(department).onValue;
  }
  
  // Add a new announcement (for admin use)
  Future<void> addAnnouncement(String department, String title, String content) async {
    final now = DateTime.now();
    final expiryDate = now.add(const Duration(days: 30)); // Expires after 30 days
    
    await _announcementsRef.child(department).push().set({
      'title': title,
      'content': content,
      'createdAt': now.millisecondsSinceEpoch,
      'expiresAt': expiryDate.millisecondsSinceEpoch,
      'isActive': true,
    });
  }
  
  // Clean up expired announcements
  Future<void> cleanupExpiredAnnouncements() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final departments = ['Police', 'FireFighter', 'Ambulance', 'Zaneco'];
    
    for (String department in departments) {
      final snapshot = await _announcementsRef.child(department).get();
      if (snapshot.exists) {
        final announcements = snapshot.value as Map<dynamic, dynamic>;
        
        for (var entry in announcements.entries) {
          final announcement = entry.value as Map<dynamic, dynamic>;
          final expiresAt = announcement['expiresAt'] as int;
          
          if (now > expiresAt) {
            await _announcementsRef.child(department).child(entry.key).remove();
          }
        }
      }
    }
  }
  
  // Get valid (non-expired) announcements
  List<Map<String, dynamic>> filterValidAnnouncements(Map<dynamic, dynamic>? announcements) {
    if (announcements == null) return [];
    
    final now = DateTime.now().millisecondsSinceEpoch;
    final validAnnouncements = <Map<String, dynamic>>[];
    
    for (var entry in announcements.entries) {
      final announcement = entry.value as Map<dynamic, dynamic>;
      final expiresAt = announcement['expiresAt'] as int;
      
      if (now <= expiresAt && announcement['isActive'] == true) {
        validAnnouncements.add({
          'id': entry.key,
          'title': announcement['title'],
          'content': announcement['content'],
          'createdAt': announcement['createdAt'],
          'expiresAt': announcement['expiresAt'],
        });
      }
    }
    
    // Sort by creation date (newest first)
    validAnnouncements.sort((a, b) => b['createdAt'].compareTo(a['createdAt']));
    
    return validAnnouncements;
  }
}