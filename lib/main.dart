import 'package:demo_task/Model/test_data.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'file_manager_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FileManagerCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.green,
          primaryColor: Colors.white,
          appBarTheme: const AppBarTheme(
            color: Colors.greenAccent,
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
            bodyMedium: TextStyle(
                color: Colors.green, fontWeight: FontWeight.w400, fontSize: 14),
          ),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Let's start",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
      body: BlocBuilder<FileManagerCubit, FileManagerState>(
        builder: (context, state) {
          return Center(
            child: state is FileManagerInitialState
                ? _readFileButton(context)
                : state is FileManagerLoadingState
                    ? const CircularProgressIndicator()
                    : state is FileManagerLoadedState
                        ? _viewCSVFileAndTestResult(state.testData)
                        : Container(),
          );
        },
      ),
    );
  }

  Widget _viewCSVFileAndTestResult(TestData data) {
    return Column(
      children: [
        // DISPLAY CSV FILE DATA
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20.0),
            child: Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              defaultColumnWidth: const FixedColumnWidth(120.0),
              border: TableBorder.all(
                color: Colors.black,
                style: BorderStyle.solid,
                width: 2,
              ),
              children: [
                // HEDER ROW
                TableRow(
                  children: [
                    Center(
                      child: Text(
                        "Action",
                        style: _commanTextStyle(),
                      ),
                    ),
                    Center(
                      child: Text(
                        "Source",
                        style: _commanTextStyle(),
                      ),
                    ),
                    Center(
                      child: Text(
                        "Destination",
                        style: _commanTextStyle(),
                      ),
                    ),
                    Center(
                      child: Text(
                        "Volume",
                        style: _commanTextStyle(),
                      ),
                    ),
                    Center(
                      child: Text(
                        "Duration",
                        style: _commanTextStyle(),
                      ),
                    ),
                    Center(
                      child: Text(
                        "Input",
                        style: _commanTextStyle(),
                      ),
                    ),
                    Center(
                      child: Text(
                        "Repetitions",
                        style: _commanTextStyle(),
                      ),
                    ),
                  ],
                ),
                // DATA"S ROWS
                for (int i = 0; i < data.test.length; i++)
                  TableRow(
                    decoration: BoxDecoration(
                        color: data.test[i].isValidTest
                            ? null
                            : Colors.amberAccent),
                    children: [
                      Center(
                        child: Text(
                          data.test[i].action,
                          style: _commanTextStyle(data.test[i].isValidTest),
                        ),
                      ),
                      Center(
                        child: Text(
                          data.test[i].source,
                          style: _commanTextStyle(data.test[i].isValidTest),
                        ),
                      ),
                      Center(
                        child: Text(
                          data.test[i].destination,
                          style: _commanTextStyle(data.test[i].isValidTest),
                        ),
                      ),
                      Center(
                        child: Text(
                          "${data.test[i].volume == -1 ? "-" : data.test[i].volume}",
                          style: _commanTextStyle(data.test[i].isValidTest),
                        ),
                      ),
                      Center(
                        child: Text(
                          data.test[i].duration,
                          style: _commanTextStyle(data.test[i].isValidTest),
                        ),
                      ),
                      Center(
                        child: Text(
                          data.test[i].input,
                          style: _commanTextStyle(data.test[i].isValidTest),
                        ),
                      ),
                      Center(
                        child: Text(
                          "${data.test[i].repetitions == -1 ? "-" : data.test[i].repetitions}",
                          style: _commanTextStyle(data.test[i].isValidTest),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
        // DISPLAY TEST RESULT
        Text("TOTAL PROCESSED TEST :- ${data.test.length}"),
        Text(
            "Valid Test :- ${data.test.length - (data.test.where((element) => !element.isValidTest)).length}"),
        Text(
            "Invalid Test :- ${(data.test.where((element) => !element.isValidTest)).length}")
      ],
    );
  }

  TextStyle _commanTextStyle([bool isValidTest = true]) {
    return TextStyle(
      color: isValidTest ? Colors.black : Colors.black,
    );
  }

  Widget _readFileButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        //Pick file
        FilePickerResult? csvFile = await FilePicker.platform.pickFiles(
          // allowedExtensions: ['xlsv', 'csv'],
          type: FileType.any,
          allowMultiple: false,
          allowCompression: false,
        );
        await context.read<FileManagerCubit>().processFile(csvFile!.paths[0]!);
      },
      child: const Text('Load/Read data'),
    );
  }
}
