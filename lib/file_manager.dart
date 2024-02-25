import 'dart:io';

import 'package:csv/csv.dart';
import 'package:demo_task/Model/test_data.dart';
import 'package:demo_task/Utils/messages.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';

class FileManager {
  // Process File: Processes the .xlsx or .csv file and returns a list of pipetting steps
  Future<TestData> processFile(String filePath) async {
    try {
      // Read file and return a list of processable data list
      List<List<dynamic>> fileData = await readFile(filePath);

      /**
       * TODO
       * 
       * Any possible validations before parsing the file data
       * 
      **/
      // LOAD ALL DATA IN MODEL
      TestData _testdata = TestData(test: []);
      List<String> rowsData = [];
      // this column for heading of CSV
      fileData.removeAt(0);
      // first access row
      for (var test in fileData) {
        // then access each and evry column value
        for (var eachDataOfRow in test) {
          rowsData.add("$eachDataOfRow");
        }
        // STORE EACH ROW'S DATA IN MODEL
        _testdata.test.add(
          Test(
            action: rowsData[0],
            source: rowsData[1],
            destination: rowsData[2],
            volume: (rowsData[3] == "-" || rowsData[3] == "null")
                ? -1
                : int.parse(rowsData[3]),
            duration: rowsData[4],
            input: rowsData[5],
            repetitions: (rowsData[6] == "-" || rowsData[6] == "null")
                ? -1
                : int.parse(rowsData[6]),
          ),
        );
        rowsData = [];
      }
      // mylog(_testdata.toString());

      return parseFileData(_testdata);
    } catch (e) {
      if (kDebugMode) {
        print('Error reading or processing file: $e');
      }
      throw 'Error reading or processing file';
    }
  }

  // Parse File Data: Parses the file data and returns a list of pipetting steps
  TestData parseFileData(TestData tests) {
    // List<String> invalidSteps = [];

    /**
       * TODO
       * 
       * Iterate over each row and identify valid and invalid steps
       * 
    **/
    // Iterate over each row and identify valid and invalid steps
    // First row is header row, so we start from the second row
    for (var test in tests.test) {
      switch (test.action.toLowerCase()) {
        case "pipette":
          if ((test.source.isEmpty || test.source == "-") ||
              (test.destination.isEmpty || test.destination == "-")) {
            // invalidSteps.add(test.action);
            test.isValidTest = false;
          }
          break;
        case "mix":
          if ((test.source.isEmpty || test.source == "-") ||
              (test.repetitions == -1 && test.volume == -1)) {
            // invalidSteps.add(test.action);
            test.isValidTest = false;
          }
          break;
        case "external":
          if ((test.input.isEmpty || test.input == "-")) {
            // invalidSteps.add(test.action);
            test.isValidTest = false;
          }
          break;
        case "incubate":
          if ((test.duration.isEmpty || test.duration == "-")) {
            // invalidSteps.add(test.action);
            test.isValidTest = false;
          }
          break;
        case "-":
          // invalidSteps.add(test.action);
          test.isValidTest = false;
          break;
        default:
      }
    }
    return tests;
  }

  // Extract Column Names: Extracts the column names from the header row for .xlsx files
  List<String> extractColumnNames(List<dynamic> headerRow) {
    return headerRow.map((header) => header.value.toString()).toList();
  }

  Future<List<List<dynamic>>> readFile(String filePath) async {
    try {
      if (filePath.endsWith('.csv')) {
        String csvContent = await File(filePath).readAsString();
        mylog("CSV FILE DATA $csvContent");
        return const CsvToListConverter()
            .convert(csvContent, convertEmptyTo: '-');
      } else if (filePath.endsWith('.xlsx')) {
        var bytes = File(filePath).readAsBytesSync();
        var excel = Excel.decodeBytes(bytes);

        List<List<dynamic>> fileData = [];

        for (var table in excel.tables.keys) {
          for (var row in excel.tables[table]!.rows) {
            fileData.add(row);
          }
        }

        return fileData;
      } else {
        throw 'Unsupported file format';
      }
    } catch (e) {
      throw 'Error reading file content $e';
    }
  }
}
