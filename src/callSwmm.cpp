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
List swmmRun(String inpFile, String rptFile, String outFile) {

  // I have no idea what the difference between char* and const char* is
  // casting seems to work
  char* inputFile = (char *)inpFile.get_cstring();
  char* reportFile = (char *)rptFile.get_cstring();
  char* binaryFile = (char *)outFile.get_cstring();

  // run swmm (this has a built-in check for interrupts)
  swmm_run(inputFile, reportFile, binaryFile);

  // get errors and warnings
  // I think this is the code of the *last* error and the *last* warning
  // (or 0 if there was none).
  // from main.c
  char errMsg[128];
  int  msgLen = 127;
  int last_error = swmm_getError(errMsg, msgLen);
  int last_warning = swmm_getWarnings();

  // output is a named list, the class of which
  // we can deal with in R
  List out = List::create(
    Named("inp") = inpFile,
    Named("rpt") = rptFile,
    Named("out") = outFile,
    Named("last_error") = last_error,
    Named("last_warning") = last_warning
  );

  return out;
}
