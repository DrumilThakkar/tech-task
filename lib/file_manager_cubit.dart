// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:demo_task/Model/test_data.dart';
import 'package:demo_task/Utils/messages.dart';

import 'file_manager.dart';

class FileManagerCubit extends Cubit<FileManagerState> {
  final _fileManager = FileManager();

  FileManagerCubit() : super(FileManagerInitialState());

  // List<dynamic>? get loadedSteps {
  //   if (state is FileManagerLoadedState) {
  //     return (state as FileManagerLoadedState).steps;
  //   } else {
  //     return null;
  //   }
  // }

  Future<void> processFile(String filePath) async {
    emit(FileManagerLoadingState());
    try {
      mylog(filePath);
      // Process file method will return valid and invalid steps
      final csvFileData = await _fileManager.processFile(filePath);
      emit(FileManagerLoadedState(csvFileData));
    } catch (e) {
      emit(FileManagerErrorState(e.toString()));
      return;
    }
  }
}

abstract class FileManagerState extends Equatable {
  const FileManagerState();

  @override
  List<Object?> get props => [];
}

class FileManagerInitialState extends FileManagerState {}

class FileManagerLoadingState extends FileManagerState {}

class FileManagerLoadedState extends FileManagerState {
  final TestData testData;

  const FileManagerLoadedState(
    this.testData,
  );

  @override
  List<Object?> get props => [];
}

class FileManagerErrorState extends FileManagerState {
  final String error;

  const FileManagerErrorState(this.error);

  @override
  List<Object?> get props => [error];
}
