import 'package:ajwad_v4/profile/models/bookmark.dart';
import 'package:get_storage/get_storage.dart';

class BookmarkService {
  static final GetStorage _storage = GetStorage('bookmark');
  static const String _key = 'bookmarks';

  // Add a bookmark
  static Future<void> addBookmark(Bookmark bookmark) async {
    final List<Bookmark> bookmarkList = _storage.read(_key) ?? [];

    bookmarkList.add(bookmark);
    await _storage.write('bookmarks', bookmarkList);
  }

  // Remove a bookmark
  static Future<void> removeBookmark(String id) async {
    final List<Bookmark> bookmarkList = _storage.read(_key) ?? [];
    bookmarkList.removeWhere((item) => item.id == id);
    await _storage.write(_key, bookmarkList);
  }

  // Get all bookmarks
  static List<Bookmark> getBookmarks() {
    return _storage.read<List<Bookmark>>(_key) ?? [];
  }
}
