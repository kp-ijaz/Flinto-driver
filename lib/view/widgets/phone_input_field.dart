import 'package:flinto_driver/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneInputField extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const PhoneInputField({
    Key? key,
    required this.label,
    required this.hint,
    required this.controller,
    this.validator,
  }) : super(key: key);

  @override
  State<PhoneInputField> createState() => _PhoneInputFieldState();
}

class _PhoneInputFieldState extends State<PhoneInputField> {
  String selectedCountryCode = '+971'; // Default UAE
  String selectedFlag = '🇦🇪';

  // Popular country codes
  final List<Map<String, String>> countryCodes = [
    {'code': '+971', 'flag': '🇦🇪', 'country': 'UAE'},
    {'code': '+1', 'flag': '🇺🇸', 'country': 'USA'},
    {'code': '+44', 'flag': '🇬🇧', 'country': 'UK'},
    {'code': '+91', 'flag': '🇮🇳', 'country': 'India'},
    {'code': '+966', 'flag': '🇸🇦', 'country': 'Saudi Arabia'},
    {'code': '+974', 'flag': '🇶🇦', 'country': 'Qatar'},
    {'code': '+968', 'flag': '🇴🇲', 'country': 'Oman'},
    {'code': '+965', 'flag': '🇰🇼', 'country': 'Kuwait'},
    {'code': '+973', 'flag': '🇧🇭', 'country': 'Bahrain'},
    {'code': '+20', 'flag': '🇪🇬', 'country': 'Egypt'},
    {'code': '+92', 'flag': '🇵🇰', 'country': 'Pakistan'},
    {'code': '+880', 'flag': '🇧🇩', 'country': 'Bangladesh'},
    {'code': '+63', 'flag': '🇵🇭', 'country': 'Philippines'},
    {'code': '+62', 'flag': '🇮🇩', 'country': 'Indonesia'},
    {'code': '+86', 'flag': '🇨🇳', 'country': 'China'},
    {'code': '+81', 'flag': '🇯🇵', 'country': 'Japan'},
    {'code': '+82', 'flag': '🇰🇷', 'country': 'South Korea'},
    {'code': '+61', 'flag': '🇦🇺', 'country': 'Australia'},
    {'code': '+49', 'flag': '🇩🇪', 'country': 'Germany'},
    {'code': '+33', 'flag': '🇫🇷', 'country': 'France'},
  ];

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Country Code',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: countryCodes.length,
                  itemBuilder: (context, index) {
                    final country = countryCodes[index];
                    return ListTile(
                      leading: Text(
                        country['flag']!,
                        style: const TextStyle(fontSize: 28),
                      ),
                      title: Text(country['country']!),
                      trailing: Text(
                        country['code']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          selectedCountryCode = country['code']!;
                          selectedFlag = country['flag']!;
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label.isNotEmpty)
          Text(
            widget.label,
            style:  TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.pending,
            ),
          ),
        if (widget.label.isNotEmpty) const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          validator: widget.validator,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: const TextStyle(color: AppColors.pending, fontSize: 14),
            prefixIcon: InkWell(
              onTap: _showCountryPicker,
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(selectedFlag, style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 4),
                    Text(
                      selectedCountryCode,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.pending,
                      ),
                    ),
                    const Icon(
                      Icons.arrow_drop_down,
                      size: 18,
                      color: AppColors.pending,
                    ),
                  ],
                ),
              ),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 0,
              minHeight: 0,
            ),
            filled: true,
            fillColor: const Color.fromARGB(188, 230, 218, 218),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(80),
              borderSide: const BorderSide(color: AppColors.pending),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(80),
              borderSide: const BorderSide(color: AppColors.pending),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(80),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(80),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }
}
