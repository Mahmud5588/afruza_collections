# 🛍️ Afruza Collection - Mobil Ilova

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)
![iOS](https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=ios&logoColor=white)

**Zamonaviy onlayn do'kon ilovasi - kiyim va aksessuarlar uchun**

[Xususiyatlar](#-xususiyatlar) • [Texnologiyalar](#-texnologiyalar) • [O'rnatish](#-ornatish) • [Hujjatlar](#-hujjatlar)

</div>

---

## 📱 Loyiha haqida

**Afruza Collection** - bu Flutter'da qurilgan zamonaviy mobil ilova bo'lib, kiyim-kechak va moda aksessuarlarini onlayn sotib olish uchun mo'ljallangan. Ilova minimalist dizayn va foydalanuvchilarga qulay interfeys bilan ajralib turadi.

### 🎯 Maqsad

Foydalanuvchilarga mahsulotlarni oson ko'rish, tanlash va xarid qilish imkonini beruvchi mobil ilova yaratish. Ilova admin panel orqali mahsulotlarni boshqarish va buyurtmalarni kuzatish imkoniyatini taqdim etadi.

---

## ✨ Xususiyatlar

### 👤 Foydalanuvchi uchun
- 🔐 **Ro'yxatdan o'tish va kirish** - Xavfsiz autentifikatsiya tizimi
- 🔍 **Qidiruv va filtr** - Mahsulotlarni kategoriya, narx va nom bo'yicha qidirish
- 📦 **Mahsulot katalogi** - Barcha mahsulotlar ko'rinishi
- 📷 **Rasm galereyasi** - Har bir mahsulot uchun bir nechta rasmlar
- ⭐ **Sevimlilar** - Yoqtirgan mahsulotlarni saqlash
- 🛒 **Buyurtma berish** - Tez va oson xarid qilish
- 📱 **Chat qo'llab-quvvatlash** - Savollarga javob olish
- 🌍 **Ko'p tillilik** - O'zbek, Rus, Ingliz tillari
- 📊 **Buyurtmalar tarixi** - O'tgan buyurtmalarni ko'rish

### 👨‍💼 Admin uchun
- 📝 **Mahsulot boshqaruvi** - Qo'shish, tahrirlash, o'chirish
- 📸 **Rasm yuklash** - Mahsulot rasmlari galereya orqali
- 📁 **Kategoriya boshqaruvi** - Kategoriyalarni boshqarish
- 👥 **Foydalanuvchilar** - Foydalanuvchilarni ko'rish va boshqarish
- 📦 **Buyurtmalar** - Barcha buyurtmalarni kuzatish

### 🎨 Dizayn xususiyatlari
- 🎨 **Minimalist dizayn** - Zamonaviy va chiroyli interfeys
- 🌈 **Gradient ranglar** - Gradient orqa fon va kartochkalar
- 🔤 **Zamonaviy shriftlar** - Poppins va Inter fontlari
- 📐 **Responsive Layout** - Barcha ekranlarda yaxshi ko'rinadi
- 🌙 **Chiroyli animatsiyalar** - Silliq o'tishlар va hero animatsiyalar

---

## 🛠 Texnologiyalar

### Frontend
- **Flutter 3.2+** - Cross-platform framework
- **Dart** - Dasturlash tili
- **BLoC** - State management (flutter_bloc)
- **GetIt** - Dependency injection

### Networking & Data
- **Dio** - HTTP client
- **cached_network_image** - Rasm keshlash
- **Hive** - Mahalliy ma'lumotlar bazasi
- **SharedPreferences** - Sozlamalarni saqlash
- **flutter_secure_storage** - Xavfsiz token saqlash

### UI & UX
- **Google Fonts** - Poppins va Inter shriftlari
- **Material Design 3** - Zamonaviy dizayn tizimi
- **Hero Animations** - Silliq page o'tishlari
- **Custom Gradients** - Maxsus gradient dizaynlar

### Integratsiyalar
- **Image Picker** - Rasm tanlash
- **Geolocator** - Joylashuvni aniqlash
- **Intl** - Tarjima va formatlash
- **Sentry** - Xatolarni kuzatish (production)

---

## 📦 O'rnatish

### Talablar

```bash
# Flutter SDK 3.2 yoki yangi versiya
flutter --version

# Dart SDK 3.0+
dart --version
```

### 1. Loyihani klonlash

```bash
git clone https://github.com/your-repo/afruza_collection_mobile.git
cd afruza_collection_mobile
```

### 2. Bog'liqliklarni o'rnatish

```bash
flutter pub get
```

### 3. Konfiguratsiya

`lib/core/app_config.dart` faylida sozlamalarni tekshiring:

```dart
// Mock rejim - offline test uchun
static const bool useMockData = true;

// API endpoint
static const String apiBaseUrl = "https://bek85.me";
```

### 4. Ishga tushirish

```bash
# Debug rejimda
flutter run

# Release rejimda
flutter run --release

# Aniq qurilmada
flutter run -d <device_id>
```

---

## 📁 Loyiha strukturasi

```
lib/
├── core/                    # Asosiy konfiguratsiyalar
│   ├── app_config.dart     # Ilova sozlamalari
│   ├── di.dart             # Dependency injection
│   ├── theme.dart          # Dizayn temalari
│   └── localization/       # Tarjimalar
├── data/                    # Ma'lumotlar qatlami
│   ├── models/             # Data modellari
│   ├── repositories/       # Repository implementatsiyalari
│   ├── remote/             # API mijozlari
│   ├── local/              # Mahalliy storage
│   └── mock/               # Mock ma'lumotlar
├── domain/                  # Biznes logika qatlami
│   ├── entities/           # Domain entitylar
│   ├── repositories/       # Repository interfeyslari
│   └── usecases/           # Use case'lar
├── presentation/            # UI qatlami
│   ├── screens/            # Ekranlar
│   ├── widgets/            # Qayta ishlatiladigan widgetlar
│   └── blocs/              # BLoC state management
└── main.dart               # Kirish nuqtasi
```

---

## 🚀 Mock rejimi

Backend tayyor bo'lmagan sharoitda test qilish uchun mock rejimdan foydalanish mumkin:

1. **Mock rejimni yoqish:**
```dart
// lib/core/app_config.dart
static const bool useMockData = true;
```

2. **Test login ma'lumotlari:**
```
Email: admin@afruza.com
Parol: admin123
```

3. **Mock ma'lumotlar:**
- 8 ta mahsulot
- 8 ta kategoriya
- 4 ta buyurtma namunasi
- 4 ta foydalanuvchi

Batafsil ko'rsatmalar: [MOCK_MODE_README.md](MOCK_MODE_README.md)

---

## 🌐 Tarjimalar

Ilova 3 tilda mavjud:

- 🇺🇿 **O'zbek** - Asosiy til
- 🇷🇺 **Русский** - Qo'shimcha qo'llab-quvvatlash
- 🇬🇧 **English** - Xalqaro foydalanuvchilar uchun

Tarjimalar: `lib/core/localization/app_localizations.dart`

---

## 📊 API Integratsiya

Ilova quyidagi API endpointlar bilan ishlaydi:

```
Base URL: https://bek85.me

Auth:
POST   /auth/register       - Ro'yxatdan o'tish
POST   /auth/login          - Kirish
POST   /auth/refresh        - Token yangilash

Products:
GET    /products            - Mahsulotlar ro'yxati
GET    /products/:id        - Mahsulot tafsilotlari
POST   /products            - Mahsulot qo'shish (Admin)
PUT    /products/:id        - Mahsulot tahrirlash (Admin)
DELETE /products/:id        - Mahsulot o'chirish (Admin)

Categories:
GET    /categories          - Kategoriyalar ro'yxati

Orders:
GET    /orders/me           - Mening buyurtmalarim
POST   /orders              - Yangi buyurtma
```

To'liq API dokumentatsiya: [https://bek85.me/docs](https://bek85.me/docs)

---

## 🔧 Optimallashtirish

Ilova sekin internet uchun maxsus optimallashtirish bilan jihozlangan:

- ✅ **Avtomatik qayta urinish** - 3 marta retry mexanizmi
- ✅ **Uzun timeoutlar** - 30-60 sekund kutish vaqti
- ✅ **Rasm keshlash** - Offline ko'rish uchun
- ✅ **Siqish qo'llab-quvvatlash** - Gzip/deflate
- ✅ **Progressiv yuklash** - Lazy loading

---

## 🧪 Test qilish

```bash
# Unit testlar
flutter test

# Widget testlar
flutter test test/widget_test.dart

# Integration testlar
flutter test integration_test/
```

---

## 📦 Build qilish

### Android APK

```bash
flutter build apk --release
```

### Android App Bundle (Google Play)

```bash
flutter build appbundle --release
```

### iOS

```bash
flutter build ios --release
```

---

## 🎨 Dizayn tizimi

### Ranglar palette

```dart
Cream:      #F7F3EE  // Asosiy orqa fon
Charcoal:   #1E1C1A  // Asosiy matn
Gold:       #C9A86A  // Accent rang
Cream Dark: #ECE4DA  // Ikkilamchi orqa fon
```

### Shriftlar

- **Poppins** - Sarlavhalar uchun (Bold, SemiBold)
- **Inter** - Matn uchun (Regular, Medium, SemiBold)

---

## 🤝 Hissa qo'shish

Pull requestlar qabul qilinadi! Katta o'zgarishlar uchun avval issue oching.

1. Fork qiling
2. Feature branch yarating (`git checkout -b feature/AmazingFeature`)
3. Commit qiling (`git commit -m 'Add some AmazingFeature'`)
4. Push qiling (`git push origin feature/AmazingFeature`)
5. Pull Request oching

---

## 📄 Litsenziya

Ushbu loyiha MIT litsenziyasi ostida.

---

## 👨‍💻 Muallif

**Afruza Collection Team**

- 📧 Email: support@afruzacollection.com
- 🌐 Website: https://afruzacollection.com
- 📱 Telegram: @afruzacollection

---

## 🙏 Minnatdorchilik

- [Flutter Team](https://flutter.dev)
- [Google Fonts](https://fonts.google.com)
- [Unsplash](https://unsplash.com) - Demo rasmlar uchun
- Barcha open-source kutubxona mualliflariga

---

<div align="center">

**⭐ Agar loyiha yoqsa, star bering!**

Made with ❤️ in Uzbekistan 🇺🇿

</div>
