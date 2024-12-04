import 'package:ajwad_v4/profile/models/bookmark.dart';
import 'package:get_storage/get_storage.dart';

class BookmarkService {
  static final GetStorage _storage = GetStorage('bookmark');

  // Add a bookmark
  static Future<void> addBookmark(Bookmark bookmark) async {
    final String userId = GetStorage().read('user_id') ?? "";
    if (userId.isEmpty) {
      return;
    }
    final List<dynamic> bookmarkList = _storage.read(userId) ?? [];

    bookmarkList.add(bookmark.toJson());
    await _storage.write(GetStorage().read('user_id'), bookmarkList);
  }

  // Remove a bookmark
  static Future<void> removeBookmark(String id) async {
    final String userId = GetStorage().read('user_id') ?? "";
    if (userId.isEmpty) {
      return;
    }
    final List<dynamic> bookmarkList = _storage.read(userId) ?? [];
    bookmarkList.removeWhere((item) => Bookmark.fromJson(item).id == id);
    await _storage.write(GetStorage().read('user_id'), bookmarkList);
  }

  // Get all bookmarks
  static List<Bookmark> getBookmarks() {
    if (GetStorage().read('user_id') != null) {
      final List<dynamic> bookmarkList =
          _storage.read(GetStorage().read('user_id')) ?? [];
      return bookmarkList.map((item) => Bookmark.fromJson(item)).toList();
    } else {
      return [];
    }
  }
}
