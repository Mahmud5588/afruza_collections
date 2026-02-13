# Security Configuration for Flutter App

## 🔒 Security Measures Implemented

### 1. Environment Variables
Never commit sensitive data to git. All secrets are environment variables.

### 2. API Security
- SSL certificate pinning enabled
- Token refresh mechanism
- Secure storage for tokens
- Request/response encryption

### 3. Code Protection
- Code obfuscation enabled in release builds
- ProGuard rules for Android
- Symbol stripping for iOS

### 4. Data Security
- Tokens stored in secure storage (Keychain/KeyStore)
- No sensitive data in logs (production)
- Encrypted local database

## 📝 Build Commands

### Development Build (with logs)
```bash
flutter run
```

### Production Build (secured)
```bash
# Android
flutter build apk --release --obfuscate --split-debug-info=build/app/outputs/symbols

# iOS
flutter build ios --release --obfuscate --split-debug-info=build/ios/outputs/symbols
```

### Build with custom API
```bash
flutter build apk --release \
  --obfuscate \
  --split-debug-info=build/app/outputs/symbols \
  --dart-define=API_BASE_URL=https://bek85.me \
  --dart-define=USE_MOCK_DATA=false
```

## 🚫 Never Commit to Git
- `*.env` files
- `key.properties` (Android signing keys)
- `*.jks` files (Android keystores)
- Private keys
- API credentials
- Firebase service account files
- Any file with passwords or tokens

## ⚠️ Before Git Push - Security Checklist
- [ ] No hardcoded API keys
- [ ] No passwords in code
- [ ] All secrets in environment variables
- [ ] .gitignore updated
- [ ] Obfuscation enabled for release
- [ ] Debug logs disabled in production
- [ ] SSL pinning configured
- [ ] Token expiry handled
