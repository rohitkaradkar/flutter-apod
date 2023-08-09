import 'package:apod/app.dart';
import 'package:apod/utils/bloc_observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  BlocOverrides.runZoned(
    blocObserver: SimpleBlocObserver(),
    () {
      runApp(const ApodApp());
    },
  );
}
