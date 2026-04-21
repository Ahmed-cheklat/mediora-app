import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediora/block_0/pages/sign_up/set_a_password_for_sign_up.dart';
import 'package:mediora/block_0/pages/signin_with_hellopage/sign_in.dart';
import 'package:mediora/block_2/pages/invoice_page.dart';
import 'package:mediora/Network/networkServices.dart';

class BookAndPayPage extends StatefulWidget {
  final Map<String, dynamic> doctor;

  const BookAndPayPage({super.key, required this.doctor});

  @override
  State<BookAndPayPage> createState() => _BookAndPayPageState();
}

class _BookAndPayPageState extends State<BookAndPayPage> {
  int _selectedDayIndex = 0;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  bool _isConfirming = false;

  final List<String> _daysOff = ['Saturday', 'Sunday'];

  List<DateTime> get _next7Days {
    final today = DateTime.now();
    return List.generate(7, (i) => today.add(Duration(days: i)));
  }

  bool _isDayOff(DateTime date) {
    const days = [
      'Monday', 'Tuesday', 'Wednesday',
      'Thursday', 'Friday', 'Saturday', 'Sunday'
    ];
    return _daysOff.contains(days[date.weekday - 1]);
  }

  String _weekdayShort(DateTime date) {
    const short = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return short[date.weekday - 1];
  }

  Future<void> _onConfirm() async {
    final days = _next7Days;
    final selectedDate = days[_selectedDayIndex];

    // Validate fields
    if (_nameController.text.trim().isEmpty ||
        _cardNumberController.text.trim().isEmpty ||
        _expiryController.text.trim().isEmpty ||
        _cvvController.text.trim().isEmpty) {
      CustomSnackBarForSignIn.show(
        context,
        message: 'Please fill in all payment details',
        icon: Icons.error_outline,
        backgroundColor: Colors.red,
      );
      return;
    }

    if (_cardNumberController.text.replaceAll(' ', '').length < 16) {
      CustomSnackBarForSignUp.show(
        context,
        message: 'Please enter a valid card number',
        icon: Icons.credit_card,
        backgroundColor: Colors.red,
      );
      return;
    }

    if (_expiryController.text.length < 5) {
      CustomSnackBarForSignUp.show(
        context,
        message: 'Please enter a valid expiry date (MM/YY)',
        icon: Icons.calendar_today_outlined,
        backgroundColor: Colors.red,
      );
      return;
    }

    if (_cvvController.text.length < 3) {
      CustomSnackBarForSignUp.show(
        context,
        message: 'Please enter a valid CVV',
        icon: Icons.lock_outline,
        backgroundColor: Colors.red,
      );
      return;
    }

    setState(() => _isConfirming = true);
    try {
      final user = await UserServices().getUser();
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InvoicePage(
            doctor: widget.doctor,
            patient: user,
            selectedDate: selectedDate,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      CustomSnackBarForSignUp.show(
        context,
        message: 'Failed to load user data: $e',
        icon: Icons.error_outline,
        backgroundColor: Colors.red,
      );
    } finally {
      if (mounted) setState(() => _isConfirming = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final doctor = widget.doctor;
    final picture = doctor['picture'];
    final hasValidPicture = picture != null &&
        picture.toString().startsWith('http') &&
        picture.toString() != 'string';
    final days = _next7Days;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF2463EB)),
        ),
        title: Text(
          'Book Appointment',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Doctor Card ───────────────────────────────────────
          Card(
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              leading: CircleAvatar(
                radius: 28,
                backgroundColor: const Color(0xFFE8EFFD),
                backgroundImage: hasValidPicture
                    ? NetworkImage(picture.toString())
                    : const AssetImage('assets/doctor_male_avatar.png')
                        as ImageProvider,
              ),
              title: Text(
                'Dr. ${doctor['first_name']} ${doctor['last_name']}',
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                doctor['specialty'] ?? '',
                style: TextStyle(fontSize: 12.sp, color: const Color(0xFF2463EB)),
              ),
            ),
          ),
          24.verticalSpace,

          // ── Select Date ───────────────────────────────────────
          Text(
            'Select Date',
            style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold),
          ),
          12.verticalSpace,
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: days.length,
              itemBuilder: (context, index) {
                final day = days[index];
                final isSelected = _selectedDayIndex == index;
                final isDayOff = _isDayOff(day);

                return GestureDetector(
                  onTap: isDayOff
                      ? null
                      : () => setState(() => _selectedDayIndex = index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 10),
                    width: 58,
                    decoration: BoxDecoration(
                      color: isDayOff
                          ? (isDark
                              ? const Color(0xFF2A2A2A)
                              : const Color(0xFFF0F0F0))
                          : isSelected
                              ? const Color(0xFF2463EB)
                              : (isDark
                                  ? const Color(0xFF1E1E1E)
                                  : Colors.white),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF2463EB)
                            : Colors.transparent,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: const Color(0xFF2463EB).withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              )
                            ]
                          : [],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _weekdayShort(day),
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: isDayOff
                                ? Colors.grey
                                : isSelected
                                    ? Colors.white
                                    : Colors.grey,
                          ),
                        ),
                        4.verticalSpace,
                        Text(
                          '${day.day}',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: isDayOff
                                ? Colors.grey
                                : isSelected
                                    ? Colors.white
                                    : (isDark ? Colors.white : Colors.black),
                          ),
                        ),
                        if (isDayOff)
                          Text(
                            'Off',
                            style: TextStyle(fontSize: 9.sp, color: Colors.grey),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          24.verticalSpace,

          // ── Payment Details ───────────────────────────────────
          Text(
            'Payment Details',
            style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold),
          ),
          12.verticalSpace,
          _PaymentField(
            controller: _nameController,
            hint: 'Full Name',
            icon: Icons.person_outline,
            keyboardType: TextInputType.name,
          ),
          12.verticalSpace,
          _PaymentField(
            controller: _cardNumberController,
            hint: 'Card Number',
            icon: Icons.credit_card,
            keyboardType: TextInputType.number,
            maxLength: 19,
            onChanged: (val) {
              final digits = val.replaceAll(' ', '');
              final buffer = StringBuffer();
              for (int i = 0; i < digits.length; i++) {
                if (i > 0 && i % 4 == 0) buffer.write(' ');
                buffer.write(digits[i]);
              }
              final formatted = buffer.toString();
              if (formatted != val) {
                _cardNumberController.value = TextEditingValue(
                  text: formatted,
                  selection: TextSelection.collapsed(offset: formatted.length),
                );
              }
            },
          ),
          12.verticalSpace,
          Row(
            children: [
              Expanded(
                child: _PaymentField(
                  controller: _expiryController,
                  hint: 'MM/YY',
                  icon: Icons.calendar_today_outlined,
                  keyboardType: TextInputType.number,
                  maxLength: 5,
                  onChanged: (val) {
                    final digits = val.replaceAll('/', '');
                    if (digits.length >= 2 && !val.contains('/')) {
                      final formatted =
                          '${digits.substring(0, 2)}/${digits.substring(2)}';
                      _expiryController.value = TextEditingValue(
                        text: formatted,
                        selection:
                            TextSelection.collapsed(offset: formatted.length),
                      );
                    }
                  },
                ),
              ),
              12.horizontalSpace,
              Expanded(
                child: _PaymentField(
                  controller: _cvvController,
                  hint: 'CVV',
                  icon: Icons.lock_outline,
                  keyboardType: TextInputType.number,
                  maxLength: 3,
                  obscure: true,
                ),
              ),
            ],
          ),
          16.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.shield_outlined, size: 14, color: Colors.grey),
              6.horizontalSpace,
              Text(
                'Your payment data is encrypted and secure',
                style: TextStyle(fontSize: 11.sp, color: Colors.grey),
              ),
            ],
          ),
          24.verticalSpace,

          // ── Confirm button ────────────────────────────────────
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isConfirming ? null : _onConfirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2463EB),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: _isConfirming
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      'Confirm and Pay',
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          24.verticalSpace,
        ],
      ),
    );
  }
}

// ── _PaymentField ─────────────────────────────────────────────────────────────

class _PaymentField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final TextInputType keyboardType;
  final int? maxLength;
  final bool obscure;
  final Function(String)? onChanged;

  const _PaymentField({
    required this.controller,
    required this.hint,
    required this.icon,
    required this.keyboardType,
    this.maxLength,
    this.obscure = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscure,
      maxLength: maxLength,
      onChanged: onChanged,
      cursorColor: const Color(0xFF2463EB),
      style: TextStyle(color: isDark ? Colors.white : Colors.black),
      decoration: InputDecoration(
        counterText: '',
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: Icon(icon, color: const Color(0xFF2463EB), size: 20),
        filled: true,
        fillColor: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF3F4F6),
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF2463EB), width: 1.5),
        ),
      ),
    );
  }
}