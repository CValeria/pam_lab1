import 'package:flutter/material.dart';

void main() {
  runApp(const CurrencyConverterApp());
}

class CurrencyConverterApp extends StatelessWidget {
  const CurrencyConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Converter',
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFF5F5F8),
      ),
      home: const CurrencyConverterScreen(),
    );
  }
}

class CurrencyConverterScreen extends StatefulWidget {
  const CurrencyConverterScreen({super.key});

  @override
  State<CurrencyConverterScreen> createState() => _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  String fromCurrency = 'MDL';
  String toCurrency = 'USD';
  double amount = 1000.00;
  double convertedAmount = 0.00;
  TextEditingController amountController = TextEditingController();

  // Exchange rates relative to MDL
  final Map<String, double> exchangeRates = {
    'MDL': 1.0,
    'USD': 0.056,
    'EUR': 0.051,
    'GBP': 0.044,
  };

  final Map<String, Color> currencyColors = {
    'MDL': Colors.yellow,
    'USD': Colors.blue,
    'EUR': Colors.blue.shade700,
    'GBP': Colors.purple,
  };

  @override
  void initState() {
    super.initState();
    amountController.text = amount.toStringAsFixed(2);
    convertCurrency();
  }

  void convertCurrency() {
    setState(() {
      // Convert to base currency (MDL) first, then to target currency
      double baseRate = exchangeRates[fromCurrency]!;
      double targetRate = exchangeRates[toCurrency]!;
      convertedAmount = (amount / baseRate) * targetRate;
    });
  }

  void swapCurrencies() {
    setState(() {
      String temp = fromCurrency;
      fromCurrency = toCurrency;
      toCurrency = temp;
      convertCurrency();
    });
  }

  void _showCurrencyPicker(bool isFromCurrency) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: exchangeRates.keys.map((String currency) {
              return ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: currencyColors[currency],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      currency[0],
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                title: Text(currency),
                onTap: () {
                  setState(() {
                    if (isFromCurrency) {
                      fromCurrency = currency;
                    } else {
                      toCurrency = currency;
                    }
                    convertCurrency();
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Currency Converter',
                style: TextStyle(
                  color: Color(0xFF1F2261),
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 32),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Amount',
                      style: TextStyle(
                        color: Color(0xFF6E7178),
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 16),
                    buildCurrencyRow(
                      currencyColors[fromCurrency]!,
                      fromCurrency,
                      true,
                    ),
                    SizedBox(height: 16),
                    Center(
                      child: GestureDetector(
                        onTap: swapCurrencies,
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Color(0xFF1F2261),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.swap_vert,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Converted Amount',
                      style: TextStyle(
                        color: Color(0xFF6E7178),
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 16),
                    buildCurrencyRow(
                      currencyColors[toCurrency]!,
                      toCurrency,
                      false,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),
              Text(
                'Indicative Exchange Rate',
                style: TextStyle(
                  color: Color(0xFF6E7178),
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    '1 $fromCurrency = ',
                    style: TextStyle(
                      color: Color(0xFF1F2261),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      (exchangeRates[toCurrency]! / exchangeRates[fromCurrency]!)
                          .toStringAsFixed(2),
                      style: TextStyle(
                        color: Color(0xFF1F2261),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    toCurrency,
                    style: TextStyle(
                      color: Color(0xFF1F2261),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCurrencyRow(Color flagColor, String currency, bool isEditable) {
    return Container(
      height: 56,
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: flagColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                currency[0],
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          GestureDetector(
            onTap: () => _showCurrencyPicker(isEditable),
            child: Row(
              children: [
                Text(
                  currency,
                  style: TextStyle(
                    color: Color(0xFF1F2261),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: Color(0xFF1F2261),
                ),
              ],
            ),
          ),
          Expanded(
            child: isEditable
                ? TextField(
                    controller: amountController,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: TextStyle(
                      color: Color(0xFF1F2261),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    onChanged: (value) {
                      setState(() {
                        amount = double.tryParse(value) ?? 0;
                        convertCurrency();
                      });
                    },
                  )
                : Text(
                    convertedAmount.toStringAsFixed(2),
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Color(0xFF1F2261),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }
}