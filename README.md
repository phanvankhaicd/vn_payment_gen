# VnPaymentGen

A Flutter package for Vietnamese payment solutions, supporting VietQR generation, bank information lookup, and business tax code verification.

## Features

- **Bank List API Integration**: Fetch and cache the list of all Vietnamese banks
- **VietQR Generation**: Create VietQR images for bank transfers with customizable parameters
- **Business Tax Code Lookup**: Verify and retrieve business information by tax code
- **Multiple QR Templates**: Support for various QR templates (compact, compact2, qr, qr-only)
- **Responsive UI Components**: Ready-to-use Flutter widgets for QR code display

## Demo

Check out this demo video to see the package in action:

<video src="https://github.com/phanvankhaicd/vn_payment_gen/raw/main/video/Screen%20Recording%202025-04-26%20at%2001.29.15.mov" controls="controls" style="max-width: 730px;">
</video>

> Note: If the video doesn't play directly, you can download it from the repository in the video folder.

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  vn_payment_gen: ^0.0.1
```

Then run:

```
flutter pub get
```

## Usage

### Initialization

Initialize the package before using any features, typically in your `main.dart`:

```dart
import 'package:vn_payment_gen/vn_payment_gen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize VnPaymentGen
  await VnPaymentGen.init();
  
  runApp(MyApp());
}
```

### Get Bank List

```dart
// Get the list of banks
final response = await VnPaymentGen.instance.getBanks();

if (response.isSuccess) {
  final banks = response.data;
  // Use bank data
}
```

### Generate QR Code URL

```dart
// Generate QR URL with bank code
final qrUrl = VnPaymentGen.instance.generateQrUrlFromBankCode(
  bankCode: 'ACB',
  accountNo: '123456789',
  amount: 100000, // optional
  addInfo: 'Payment for order #123', // optional
);

// Or directly with bank BIN
final qrUrl = VnPaymentGen.instance.generateQrUrl(
  bankId: '970416', // Bank BIN
  accountNo: '123456789',
  template: VnPaymentGen.templateCompact,
);
```

### Display QR Widget

```dart
// Display QR code in your UI
VietQrImage(
  bankId: '970416', // Bank BIN
  accountNo: '123456789',
  template: VnPaymentGen.templateCompact,
  amount: 100000, // optional
  addInfo: 'Payment for order #123', // optional
  width: 250,
  height: 250,
)
```

### Business Tax Code Lookup

```dart
// Look up business information by tax code
final response = await VnPaymentGen.instance.getBusinessByTaxCode('0316794479');

if (response.isSuccess && response.data != null) {
  final business = response.data;
  print('Business name: ${business.name}');
  print('Address: ${business.address}');
}
```

## Available Templates

- `VnPaymentGen.templateCompact` - Compact QR with bank info
- `VnPaymentGen.templateCompact2` - Alternative compact template
- `VnPaymentGen.templateQr` - Standard QR code with bank info
- `VnPaymentGen.templateQrOnly` - QR code only

## Example App

The package includes a complete example app demonstrating all features:

- Displaying the bank list
- Generating QR codes for payments
- Looking up business information by tax code

Run the example app:

```
cd example
flutter run
```

## API Reference

### VnPaymentGen

- `static Future<VnPaymentGen> init()` - Initialize the plugin
- `Future<ApiResponse<List<Bank>>> getBanks({bool forceRefresh = false})` - Get bank list
- `Bank? findBankByCode(String code)` - Find bank by code
- `Bank? findBankByBin(String bin)` - Find bank by BIN
- `String generateQrUrl({...})` - Generate QR URL with parameters
- `VietQrImage getQrImage({...})` - Get QR image widget
- `Future<ApiResponse<Business?>> getBusinessByTaxCode(String taxCode)` - Look up business by tax code

### Models

- `Bank` - Bank information model
- `Business` - Business information model
- `ApiResponse<T>` - Generic API response wrapper

## Credits

This package uses the following APIs:
- VietQR API for bank information and QR generation
- VietQR Business API for tax code verification

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

