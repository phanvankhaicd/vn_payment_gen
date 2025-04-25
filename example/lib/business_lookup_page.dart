import 'package:flutter/material.dart';
import 'package:vn_payment_gen/vn_payment_gen.dart';
import 'package:vn_payment_gen/models/index.dart';

class BusinessLookupPage extends StatefulWidget {
  const BusinessLookupPage({super.key});

  @override
  State<BusinessLookupPage> createState() => _BusinessLookupPageState();
}

class _BusinessLookupPageState extends State<BusinessLookupPage> {
  final TextEditingController _taxCodeController = TextEditingController();
  Business? _business;
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void dispose() {
    _taxCodeController.dispose();
    super.dispose();
  }

  Future<void> _lookupBusiness() async {
    final taxCode = _taxCodeController.text.trim();
    if (taxCode.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập mã số thuế')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _business = null;
    });

    try {
      final response = await VnPaymentGen.instance.getBusinessByTaxCode(taxCode);
      
      setState(() {
        _isLoading = false;
        if (response.isSuccess && response.data != null) {
          _business = response.data;
        } else {
          _errorMessage = response.desc;
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tra cứu mã số thuế'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taxCodeController,
                    decoration: const InputDecoration(
                      labelText: 'Mã số thuế',
                      hintText: 'Nhập mã số thuế, VD: 0316794479',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _isLoading ? null : _lookupBusiness,
                  child: const Text('Tra cứu'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_errorMessage.isNotEmpty)
              Center(
                child: Text(
                  'Lỗi: $_errorMessage',
                  style: const TextStyle(color: Colors.red),
                ),
              )
            else if (_business != null)
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _business!.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Mã số thuế: ${_business!.id}'),
                      const SizedBox(height: 4),
                      Text('Tên quốc tế: ${_business!.internationalName}'),
                      const SizedBox(height: 4),
                      Text('Tên viết tắt: ${_business!.shortName}'),
                      const SizedBox(height: 8),
                      const Text(
                        'Địa chỉ:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(_business!.address),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
} 