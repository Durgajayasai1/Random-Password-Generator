import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> with SingleTickerProviderStateMixin {
  bool includeLowerCase = true;
  bool includeUpperCase = true;
  bool includeNumbers = true;
  bool includeSpecialCharacters = true;
  double passwordLength = 16;
  String generatedPwd = '';
  bool isGenerating = false;

  late AnimationController _controller;
  String animatingPwd = '';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _controller.addListener(() {
      setState(() {
        animatingPwd = _generateRandomChars(generatedPwd.length);
      });
    });
    generatePassword();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void generatePassword() {
    if (!includeLowerCase &&
        !includeUpperCase &&
        !includeNumbers &&
        !includeSpecialCharacters) {
      setState(() {
        generatedPwd = '';
      });
      return;
    }

    setState(() {
      isGenerating = true;
      _controller.reset();
      _controller.forward().then((_) {
        setState(() {
          isGenerating = false;
          generatedPwd = _generatePassword();
        });
      });
    });
  }

  String _generateRandomChars(int length) {
    const allChars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*()_-+=<>?/{}[]|';
    final random = Random();
    return String.fromCharCodes(
      List.generate(
        length,
        (_) => allChars.codeUnitAt(random.nextInt(allChars.length)),
      ),
    );
  }

  String _generatePassword() {
    String charset = '';
    if (includeLowerCase) charset += 'abcdefghijklmnopqrstuvwxyz';
    if (includeUpperCase) charset += 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    if (includeNumbers) charset += '0123456789';
    if (includeSpecialCharacters) charset += '!@#\$%^&*()_-+=<>?/{}[]|';

    if (charset.isEmpty) return '';

    final random = Random();
    final length = passwordLength.toInt();

    return String.fromCharCodes(
      List.generate(
        length,
        (_) => charset.codeUnitAt(random.nextInt(charset.length)),
      ),
    );
  }

  void copyToClipboard() {
    if (generatedPwd.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: generatedPwd));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.grey.shade900,
          content: Center(
            child: Text(
              'Password copied to clipboard',
              style: GoogleFonts.sora(color: Colors.white),
            ),
          ),
        ),
      );
    }
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(40),
      child: AppBar(
        title: Text(
          'Random Password Generator',
          style: GoogleFonts.sora(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    color: Colors.grey.shade900,
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  isGenerating ? animatingPwd : generatedPwd,
                                  style: GoogleFonts.sora(color: Colors.white),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Iconsax.copy,
                                  color: Colors.white,
                                ),
                                onPressed:
                                    generatedPwd.isEmpty
                                        ? null
                                        : copyToClipboard,
                                tooltip: 'Copy to clipboard',
                              ),
                              IconButton(
                                onPressed: generatePassword,
                                icon: Icon(
                                  Iconsax.refresh,
                                  color: Colors.white,
                                ),
                                tooltip: 'Generate new password',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Password Length: ${passwordLength.toInt()}',
                    style: GoogleFonts.sora(color: Colors.grey.shade300),
                  ),
                  Slider(
                    activeColor: Colors.white,
                    inactiveColor: Colors.grey,
                    thumbColor: Colors.white,
                    value: passwordLength.toDouble(),
                    min: 4,
                    max: 50,
                    divisions: 46,
                    label: passwordLength.toInt().toString(),
                    onChanged: (value) {
                      setState(() {
                        passwordLength = value;
                      });
                      generatePassword();
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Character Types:',
                    style: GoogleFonts.sora(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  CheckboxListTile(
                    activeColor: Colors.white,
                    checkColor: Colors.black,
                    title: Text(
                      'abc',
                      style: GoogleFonts.sora(color: Colors.grey.shade300),
                    ),
                    value: includeLowerCase,
                    onChanged: (value) {
                      setState(() {
                        includeLowerCase = value!;
                      });
                      generatePassword();
                    },
                  ),
                  CheckboxListTile(
                    activeColor: Colors.white,
                    checkColor: Colors.black,
                    title: Text(
                      'ABC',
                      style: GoogleFonts.sora(color: Colors.grey.shade300),
                    ),
                    value: includeUpperCase,
                    onChanged: (value) {
                      setState(() {
                        includeUpperCase = value!;
                      });
                      generatePassword();
                    },
                  ),
                  CheckboxListTile(
                    activeColor: Colors.white,
                    checkColor: Colors.black,
                    title: Text(
                      '123',
                      style: GoogleFonts.sora(color: Colors.grey.shade300),
                    ),
                    value: includeNumbers,
                    onChanged: (value) {
                      setState(() {
                        includeNumbers = value!;
                      });
                      generatePassword();
                    },
                  ),
                  CheckboxListTile(
                    activeColor: Colors.white,
                    checkColor: Colors.black,
                    title: Text(
                      '!@#\$%^&*()',
                      style: GoogleFonts.sora(color: Colors.grey.shade300),
                    ),
                    value: includeSpecialCharacters,
                    onChanged: (value) {
                      setState(() {
                        includeSpecialCharacters = value!;
                      });
                      generatePassword();
                    },
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 50.0),
                child: Text(
                  'Made with ❤️ by _insane.dev',
                  style: GoogleFonts.sora(
                    color: Colors.grey.shade300,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
