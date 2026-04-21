import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool _firstNameEditable = false;
  bool _lastNameEditable = false;
  bool _usernameEditable = false;

  String? _selectedGender;
  DateTime? _selectedDob;
  String? _pictureUrl;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadFromStorage();
  }

  Future<void> _loadFromStorage() async {
    final firstName   = await _secureStorage.read(key: 'first_name')   ?? '';
    final lastName    = await _secureStorage.read(key: 'last_name')     ?? '';
    final username    = await _secureStorage.read(key: 'username')      ?? '';
    final email       = await _secureStorage.read(key: 'email')         ?? '';
    final gender      = await _secureStorage.read(key: 'gender');
    final dobStr      = await _secureStorage.read(key: 'date_of_birth');
    final picture     = await _secureStorage.read(key: 'picture');

    setState(() {
      _firstNameController.text = firstName;
      _lastNameController.text  = lastName;
      _usernameController.text  = username;
      _emailController.text     = email;
      _selectedGender = (gender != null && gender.isNotEmpty) ? gender : null;
      _selectedDob = (dobStr != null && dobStr.isNotEmpty)
          ? DateTime.tryParse(dobStr)
          : null;
      _pictureUrl = (picture != null &&
              picture.startsWith('http') &&
              picture != 'string')
          ? picture
          : null;
    });
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDob ?? DateTime(now.year - 25),
      firstDate: DateTime(1920),
      lastDate: now,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF2463EB),
            onPrimary: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDob = picked);
  }

  Future<void> _onSave() async {
    setState(() => _isSaving = true);
    try {
      await _secureStorage.write(key: 'first_name', value: _firstNameController.text.trim());
      await _secureStorage.write(key: 'last_name',  value: _lastNameController.text.trim());
      await _secureStorage.write(key: 'username',   value: _usernameController.text.trim());
      if (_selectedGender != null) {
        await _secureStorage.write(key: 'gender', value: _selectedGender!);
      }
      if (_selectedDob != null) {
        await _secureStorage.write(
          key: 'date_of_birth',
          value: _selectedDob!.toIso8601String(),
        );
      }

      // TODO: call API to update profile

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 10),
              Text('Profile updated successfully'),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );

      // disable all edit modes
      setState(() {
        _firstNameEditable = false;
        _lastNameEditable  = false;
        _usernameEditable  = false;
      });
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF2463EB)),
        ),
        title: Text(
          'Edit Profile',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        children: [

          // ── Avatar ────────────────────────────────────────────
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 55.r,
                  backgroundColor: const Color(0xFFE8EFFD),
                  backgroundImage: _pictureUrl != null
                      ? NetworkImage(_pictureUrl!) as ImageProvider
                      : const AssetImage('assets/default_avatar.png'),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      // TODO: image picker
                    },
                    child: Container(
                      width: 34.r,
                      height: 34.r,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2463EB),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark ? const Color(0xFF121212) : Colors.white,
                          width: 2.5,
                        ),
                      ),
                      child: Icon(Icons.camera_alt, color: Colors.white, size: 16.r),
                    ),
                  ),
                ),
              ],
            ),
          ),
          28.verticalSpace,

          // ── Email (read-only) ─────────────────────────────────
          _SectionLabel(label: 'Email'),
          8.verticalSpace,
          _ReadOnlyField(
            controller: _emailController,
            icon: Icons.email_outlined,
            isDark: isDark,
          ),
          20.verticalSpace,

          // ── First Name ────────────────────────────────────────
          _SectionLabel(label: 'First Name'),
          8.verticalSpace,
          _EditableField(
            controller: _firstNameController,
            icon: Icons.person_outline,
            isEditable: _firstNameEditable,
            isDark: isDark,
            onToggle: () => setState(() {
              _firstNameEditable = !_firstNameEditable;
            }),
          ),
          20.verticalSpace,

          // ── Last Name ─────────────────────────────────────────
          _SectionLabel(label: 'Last Name'),
          8.verticalSpace,
          _EditableField(
            controller: _lastNameController,
            icon: Icons.person_outline,
            isEditable: _lastNameEditable,
            isDark: isDark,
            onToggle: () => setState(() {
              _lastNameEditable = !_lastNameEditable;
            }),
          ),
          20.verticalSpace,

          // ── Username ──────────────────────────────────────────
          _SectionLabel(label: 'Username'),
          8.verticalSpace,
          _EditableField(
            controller: _usernameController,
            icon: Icons.alternate_email,
            isEditable: _usernameEditable,
            isDark: isDark,
            onToggle: () => setState(() {
              _usernameEditable = !_usernameEditable;
            }),
          ),
          20.verticalSpace,

          // ── Gender ────────────────────────────────────────────
          _SectionLabel(label: 'Gender'),
          8.verticalSpace,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(14),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedGender,
                hint: Text(
                  'Select gender',
                  style: TextStyle(color: Colors.grey, fontSize: 13.sp),
                ),
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF2463EB)),
                dropdownColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                items: ['Male', 'Female'].map((g) {
                  return DropdownMenuItem(
                    value: g,
                    child: Row(
                      children: [
                        Icon(
                          Icons.circle,
                          size: 10,
                          color: g == 'Male'
                              ? const Color(0xFF2463EB)
                              : const Color(0xFFFF4D9E),
                        ),
                        8.horizontalSpace,
                        Text(g, style: TextStyle(fontSize: 13.sp)),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedGender = val),
              ),
            ),
          ),
          20.verticalSpace,

          // ── Date of Birth ─────────────────────────────────────
          _SectionLabel(label: 'Date of Birth'),
          8.verticalSpace,
          GestureDetector(
            onTap: _pickDate,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(Icons.cake_outlined, color: Color(0xFF2463EB), size: 20),
                  12.horizontalSpace,
                  Text(
                    _selectedDob != null
                        ? '${_selectedDob!.day}/${_selectedDob!.month}/${_selectedDob!.year}'
                        : 'Select date of birth',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: _selectedDob != null
                          ? (isDark ? Colors.white : Colors.black)
                          : Colors.grey,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.keyboard_arrow_down, color: Color(0xFF2463EB)),
                ],
              ),
            ),
          ),
          36.verticalSpace,

          // ── Save Button ───────────────────────────────────────
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSaving ? null : _onSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2463EB),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: _isSaving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      'Save Changes',
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

// ── Helpers ───────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w600,
        color: Colors.grey,
      ),
    );
  }
}

class _ReadOnlyField extends StatelessWidget {
  final TextEditingController controller;
  final IconData icon;
  final bool isDark;

  const _ReadOnlyField({
    required this.controller,
    required this.icon,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFEEEEEE),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey, size: 20),
          12.horizontalSpace,
          Expanded(
            child: Text(
              controller.text.isEmpty ? '—' : controller.text,
              style: TextStyle(fontSize: 13.sp, color: Colors.grey),
            ),
          ),
          const Icon(Icons.lock_outline, color: Colors.grey, size: 16),
        ],
      ),
    );
  }
}

class _EditableField extends StatelessWidget {
  final TextEditingController controller;
  final IconData icon;
  final bool isEditable;
  final bool isDark;
  final VoidCallback onToggle;

  const _EditableField({
    required this.controller,
    required this.icon,
    required this.isEditable,
    required this.isDark,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: isEditable,
      cursorColor: const Color(0xFF2463EB),
      style: TextStyle(
        fontSize: 13.sp,
        color: isDark ? Colors.white : Colors.black,
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFF2463EB), size: 20),
        suffixIcon: GestureDetector(
          onTap: onToggle,
          child: Icon(
            isEditable ? Icons.check : Icons.edit,
            color: isEditable ? Colors.green : const Color(0xFF2463EB),
            size: 18,
          ),
        ),
        filled: true,
        fillColor: isEditable
            ? (isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF3F4F6))
            : (isDark ? const Color(0xFF2A2A2A) : const Color(0xFFEEEEEE)),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF2463EB), width: 1.5),
        ),
        disabledBorder: OutlineInputBorder(
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