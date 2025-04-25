import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:vn_payment_gen/vn_payment_gen.dart';
import 'package:vn_payment_gen/models/index.dart';
import 'package:vn_payment_gen/widgets/viet_qr_image.dart';
import 'business_lookup_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Khởi tạo VnPaymentGen trước khi chạy ứng dụng
  await VnPaymentGen.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _platformVersion = 'Unknown';
  List<Bank>? _banks;
  bool _isLoading = false;
  String _errorMessage = '';
  Bank? _selectedBank;
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _loadBanks();
  }
  
  @override
  void dispose() {
    _accountController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await VnPaymentGen.instance.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Future<void> _loadBanks() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await VnPaymentGen.instance.getBanks();
      
      setState(() {
        _banks = response.data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _navigateToBusinessLookup() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const BusinessLookupPage())
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VietQR Demo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.business),
            tooltip: 'Tra cứu mã số thuế',
            onPressed: _navigateToBusinessLookup,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Running on: $_platformVersion'),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage.isNotEmpty
                    ? Center(child: Text('Error: $_errorMessage'))
                    : SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Danh sách ngân hàng:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: DropdownButton<Bank>(
                                  value: _selectedBank,
                                  isExpanded: true,
                                  underline: const SizedBox(),
                                  hint: const Text('Chọn ngân hàng'),
                                  items: _banks?.map((bank) {
                                    return DropdownMenuItem<Bank>(
                                      value: bank,
                                      child: Row(
                                        children: [
                                          Image.network(
                                            bank.logo,
                                            width: 40,
                                            height: 40,
                                            errorBuilder: (context, error, stackTrace) =>
                                                const Icon(Icons.account_balance),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              bank.shortName,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (bank) {
                                    setState(() {
                                      _selectedBank = bank;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: _accountController,
                                decoration: const InputDecoration(
                                  labelText: 'Số tài khoản',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: _amountController,
                                decoration: const InputDecoration(
                                  labelText: 'Số tiền (không bắt buộc)',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: _descriptionController,
                                decoration: const InputDecoration(
                                  labelText: 'Nội dung chuyển khoản (không bắt buộc)',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 24),
                              if (_selectedBank != null && _accountController.text.isNotEmpty)
                                Center(
                                  child: Column(
                                    children: [
                                      const Text(
                                        'Mã QR:',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      VietQrImage(
                                        bankId: _selectedBank!.bin,
                                        accountNo: _accountController.text,
                                        template: VnPaymentGen.templateCompact,
                                        amount: _amountController.text.isNotEmpty
                                            ? int.tryParse(_amountController.text)
                                            : null,
                                        addInfo: _descriptionController.text.isNotEmpty
                                            ? _descriptionController.text
                                            : null,
                                        width: 250,
                                        height: 250,
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadBanks,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
