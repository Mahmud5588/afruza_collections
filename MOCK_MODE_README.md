# Mock Data Mode - Ishlatish Yo'riqnomasi

## Mock Mode Nima?

Mock mode - bu backend tayyor bo'lgunicha ilovani test qilish uchun yaratilgan maxsus rejim. Bu rejimda ilova haqiqiy API'ga so'rov yuborish o'rniga, qattiq kodlangan mock datalardan foydalanadi.

## Afzalliklari

✅ Backend tayyor bo'lmasa ham ilovani test qilish mumkin
✅ Internet aloqasisiz ishlaydi
✅ Tez javob qaytaradi (real API kutilmaydi)
✅ Hech qanday backend xatolariga duch kelmaysiz
✅ Eski API kodlari o'zgarmaganлиги sababli, backend tayyor bo'lganda oson o'tish mumkin

## Mock Mode Yoqish/O'chirish

### 1. Default (Mock Mode Yoniq)

Hozir loyihada mock mode default bo'lib yoqilgan. Shu sababli hech narsa qilmasangiz ham mock datalar bilan ishlaysiz:

\`\`\`dart
// lib/core/app_config.dart
static const bool useMockData = bool.fromEnvironment(
  "USE_MOCK_DATA",
  defaultValue: true, // ← Bu yerda default true
);
\`\`\`

### 2. Mock Mode O'chirish (Real API'ga Ulanish)

Backend tayyor bo'lib, real API'dan foydalanmoqchi bo'lsangiz:

#### A. Run command bilan:
\`\`\`bash
flutter run --dart-define=USE_MOCK_DATA=false
\`\`\`

#### B. Yoki kodni o'zgartiring:
\`\`\`dart
// lib/core/app_config.dart
static const bool useMockData = bool.fromEnvironment(
  "USE_MOCK_DATA",
  defaultValue: false, // ← false qiling
);
\`\`\`

## Mock Datalar

Mock mode yoqilganda quyidagi datalardan foydalaniladi:

### Test Foydalanuvchilar

1. **Admin Akkaunt:**
   - Email: `admin@afruza.com`
   - Parol: `admin123`

2. **Oddiy Foydalanuvchi:**
   - Email: `user@afruza.com`
   - Parol: `user123`

### Mahsulotlar

8 ta mock mahsulot mavjud:
- Klassik Ko'ylak (150,000 so'm)
- Jinsi Shim (250,000 so'm)
- Qishki Kurtka (450,000 so'm)
- Sport Futbolka (80,000 so'm)
- Zamonaviy Sviter (180,000 so'm)
- Charm Sumka (350,000 so'm)
- Krossovka (320,000 so'm)
- Soat (420,000 so'm)

### Kategoriyalar

8 ta mock kategoriya:
- Ko'ylaklar
- Shim va Jinsi
- Kurtka va Palto
- Futbolka va Sviter
- Aksessuarlar
- Oyoq Kiyim
- Sumka va Ryukzak
- Sport Kiyim

### Buyurtmalar

4 ta mock buyurtma (har xil statuslarda)

## Qanday Ishlaydi?

### Arxitektura

\`\`\`
lib/
  ├── core/
  │   ├── app_config.dart          # Mock mode konfiguratsiyasi
  │   └── di.dart                   # Dependency injection (Mock/Real tanlash)
  ├── data/
  │   ├── mock/                     # ← Mock implementatsiyalar
  │   │   ├── mock_data_source.dart      # Barcha mock datalar
  │   │   ├── auth_repository_mock.dart
  │   │   ├── category_repository_mock.dart
  │   │   ├── order_repository_mock.dart
  │   │   ├── product_repository_mock.dart
  │   │   ├── recommendation_repository_mock.dart
  │   │   └── user_repository_mock.dart
  │   └── repositories/             # Real API implementatsiyalar (o'zgartirilmagan)
  │       ├── auth_repository_impl.dart
  │       ├── category_repository_impl.dart
  │       └── ...
  └── domain/
      └── repositories/             # Abstract interface'lar
          ├── auth_repository.dart
          └── ...
\`\`\`

### Dependency Injection

`lib/core/di.dart` faylida `AppConfig.useMockData` qiymatiga qarab mock yoki real repository tanlash:

\`\`\`dart
if (AppConfig.useMockData) {
  // Mock repository'larni register qilish
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryMock(sl()));
  sl.registerLazySingleton<ProductRepository>(() => ProductRepositoryMock());
  // ...
} else {
  // Real repository'larni register qilish
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl(), sl()));
  sl.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl(sl()));
  // ...
}
\`\`\`

## Mock Datalarni O'zgartirish

Mock datalarni o'zgartirish uchun `lib/data/mock/mock_data_source.dart` faylini tahrirlang:

\`\`\`dart
// Yangi mahsulot qo'shish
static final List<Product> products = [
  const Product(
    id: 9,
    name: "Sizning mahsulotingiz",
    description: "...",
    price: 100000,
    // ...
  ),
  // ... boshqa mahsulotlar
];
\`\`\`

## Muhim Eslatmalar

⚠️ **Mock Mode Cheklangan:**
- Mock datalar faqat xotirada saqlanadi (restart qilsangiz bekor bo'ladi)
- Rasm URL'lar internet talab qiladi (unsplash.com dan keladi)
- Ba'zi murakkab funksiyalar mock'da soddalashtirilgan

✅ **Eski Kodlar O'zgartirilmadi:**
- `lib/data/repositories/*_impl.dart` fayllar o'zgartirilmadi
- Domain layer (use case, entity, repository interface) o'zgartirilmadi
- Presentation layer (bloc, screen) o'zgartirilmadi
- Backend tayyor bo'lganda faqat `AppConfig.useMockData = false` qilish kifoya

## Test Qilish

Mock mode bilan barcha funksiyalarni test qiling:

1. ✅ Login (admin@afruza.com / admin123)
2. ✅ Register (har qanday email/password)
3. ✅ Mahsulotlarni ko'rish va qidirish
4. ✅ Kategoriyalar
5. ✅ Buyurtma yaratish
6. ✅ Admin panel (mahsulot/kategoriya/user CRUD)
7. ✅ Tavsiya qilingan mahsulotlar

Barchasi backend API'siz ishlaydi!

## Real API'ga O'tish

Backend tayyor bo'lganda:

1. API'ning base URL'ni to'g'ri o'rnating (`lib/core/app_config.dart`)
2. Mock mode'ni o'chiring
3. Real backend bilan test qiling
4. Agar muammo bo'lsa, mock mode'ni qayta yoqib debug qiling

\`\`\`dart
// lib/core/app_config.dart
static const String apiBaseUrl = String.fromEnvironment(
  "API_BASE_URL",
  defaultValue: "https://your-real-api.com", // ← Real URL
);

static const bool useMockData = bool.fromEnvironment(
  "USE_MOCK_DATA",
  defaultValue: false, // ← O'chirish
);
\`\`\`

---

**Ishlab chiqarish sanaasi:** 2026-02-09
**Versiya:** 1.0
