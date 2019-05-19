#include <Rcpp.h>
#include "swmm5.h"
using namespace Rcpp;

// [[Rcpp::export]]
IntegerVector swmmVersion() {

  // from main.c
  int  version, vMajor, vMinor, vRelease;
  version = swmm_getVersion();
  vMajor = version / 10000;
  vMinor = (version - 10000 * vMajor) / 1000;
  vRelease = (version - 10000 * vMajor - 1000 * vMinor);

  return IntegerVector::create(vMajor, vMinor, vRelease);
}

// [[Rcpp::export]]
List swmmRun(String inputFileIn, String reportFileIn, String binaryFileIn) {

  // I have no idea what the difference between char* and const char* is
  // casting seems to work
  char* inputFile = (char *)inputFileIn.get_cstring();
  char* reportFile = (char *)reportFileIn.get_cstring();
  char* binaryFile = (char *)binaryFileIn.get_cstring();

  // run swmm (this can't be cancelled yet)
  swmm_run(inputFile, reportFile, binaryFile);

  // get errors and warnings
  // from main.c
  char errMsg[128];
  int  msgLen = 127;
  int error = swmm_getError(errMsg, msgLen);
  int warning = swmm_getWarnings();

  // output is a named list, the class of which
  // we can deal with in R
  List out = List::create(
    Named("input_file") = inputFileIn,
    Named("report_file") = reportFileIn,
    Named("binary_file") = binaryFileIn,
    Named("error") = error,
    Named("warning") = warning
  );

  return out;
}
