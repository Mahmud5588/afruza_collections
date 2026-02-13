# Afruza Collection - Optimization Guide

## Network Optimization for Slow Internet

This guide documents the optimizations implemented for better performance on slow internet connections.

### 1. **Image Optimization**
- **Image Caching**: Using `cached_network_image` package to cache images locally
- **Lazy Loading**: Images are only loaded when visible in viewport
- **Image Quality**: Images are loaded with appropriate quality for mobile screens
- **Multiple Images**: Product detail screen supports image pagination (PageView)

**What was changed:**
- Product card images now use `BoxFit.cover` instead of `contain` for better visual appearance
- Larger image preview in product detail (280px height)
- Image loading indicator showing progress

### 2. **Network Request Optimization**
- **Longer Timeouts**: Increased timeouts for slow networks
  - Connect timeout: 30 seconds (was 12s)
  - Receive timeout: 60 seconds (was 12s)
  - Send timeout: 60 seconds (new)
- **Compression Support**: Added gzip/deflate compression headers
- **Token Caching**: Authorization tokens are cached locally

**Configuration in `lib/data/remote/dio_client.dart`:**
```dart
connectTimeout: const Duration(seconds: 30),
receiveTimeout: const Duration(seconds: 60),
sendTimeout: const Duration(seconds: 60),
```

### 3. **Data Structure Improvements**
- **Mock Data Aligned with API**: All product data now aligns with the actual API schema from https://bek85.me/docs
- **Additional Fields**: Added `viewsCount`, `soldCount`, `categoryId`, `createdAt` for better features

**New Product Fields:**
- `categoryId`: Integer category identifier (matches API)
- `viewsCount`: Number of times product was viewed
- `soldCount`: Number of units sold
- `createdAt`: Product creation timestamp

### 4. **UI/UX Improvements**
- **Enhanced Typography**: Improved font sizes and weights for better readability
  - Display text: 40px (was 36px)
  - Better line spacing and letter spacing
  - Clear visual hierarchy
- **Larger Product Cards**: Increased from 200px to 220px width
  - Better visibility of product images
  - Easier to tap on mobile

### 5. **Authentication Improvements**
- **Login/Logout Dialogs**: Added confirmation dialogs for user actions
  - Prevents accidental logouts
  - Clear messaging for login requirements
- **Better Error Handling**: More informative messages

### 6. **Admin Panel Enhancements**
- **Image Upload Support**: AdminProductScreen now supports:
  - Local image selection from device gallery
  - Image preview before upload
  - Multi-image support (up to 5 images)
  - Easy image management with remove button
- **Better Forms**: Improved form UI with ImagePickerField widget

### 7. **Caching Strategy**
The app implements multi-level caching:

1. **Network Cache** (via CachedNetworkImage):
   - Images cached locally for 30 days
   - Automatic cleanup of old caches

2. **Local Storage** (Hive + SharedPreferences):
   - User authentication tokens
   - Favorites list
   - User preferences

3. **App-Level Cache** (BLoC state):
   - Product list cached in memory
   - Categories cached in memory
   - Recommendations (most viewed/most sold) cached

### 8. **Best Practices for Slow Internet**

#### For Users:
- **On WiFi/Good Connection**: App works normally with full features
- **On Slow/Mobile Network**: 
  - Images load gradually
  - Longer wait times for API responses
  - App remains responsive while loading
  - Local cache used when available

#### For Developers:
- **Mock Mode**: Use mock data for testing offline scenarios
  - Set `AppConfig.useMockData = true` in app_config.dart
  - No network requests needed
  - Perfect for demo/development

- **Error Handling**: Always handle timeout errors gracefully
- **Progress Indicators**: Show loading states for long-running operations
- **Pagination**: Use pagination for large lists (already implemented)

### 9. **Performance Metrics to Monitor**

Monitor these metrics for slow network scenarios:
- Image load times
- API response times
- Cold start performance
- Cache hit rates
- Memory usage with large product lists

### 10. **Future Optimizations**

Potential improvements for even better slow-internet support:
1. **Service Workers**: Cache responses for repeat requests
2. **GraphQL**: More efficient data fetching (vs REST)
3. **WebP/AVIF Images**: Smaller image formats
4. **Bundle Size Reduction**: Code splitting and lazy loading
5. **Offline Support**: Handle complete offline scenarios
6. **Adaptive Streaming**: Serve different quality images based on connection

## Configuration

### Mock Mode
Set in `lib/core/app_config.dart`:
```dart
static const bool useMockData = true; // for testing
```

### API Base URL
Set in `lib/core/app_config.dart`:
```dart
static const String apiBaseUrl = "https://bek85.me";
```

### Network Timeouts
Adjust in `lib/data/remote/dio_client.dart` for your specific needs.

## Testing Slow Networks

To test slow network conditions:

### Android Emulator:
1. Open Extended Controls (Ctrl+Shift+E)
2. Go to "Network"
3. Set connection type to "GPRS" or "EDGE"

### iOS Simulator:
1. Use Xcode's Network Link Conditioner
2. Or use Charles/Fiddler proxy to throttle

### Real Device:
1. Use Developer Options (Android) to set network throttle
2. Or use Mac's Network Utility to create VPN throttle

## Monitoring & Debugging

### Enable Debug Logging
```dart
// In main.dart or DioClient setup
if (kDebugMode) {
  dio.interceptors.add(LoggingInterceptor()); // if using logging package
}
```

### Profile with DevTools
```bash
flutter run --profile
# Then use DevTools to analyze performance
```

## References
- API Documentation: https://bek85.me/docs
- Cached Network Image: https://pub.dev/packages/cached_network_image
- Dio HTTP Client: https://pub.dev/packages/dio
- Flutter Best Practices: https://flutter.dev/brand#flutter-brand-guidelines
