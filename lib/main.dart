import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/ComboBoxScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ComboBoxCubit(),
      child: const MaterialApp(
        title: 'Combo Box',
        home: ComboBoxScreen(),
      ),
    );
  }
}
