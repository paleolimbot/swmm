// Generated by using Rcpp::compileAttributes() -> do not edit by hand
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include <Rcpp.h>

using namespace Rcpp;

// swmmVersion
IntegerVector swmmVersion();
RcppExport SEXP _swmm_swmmVersion() {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    rcpp_result_gen = Rcpp::wrap(swmmVersion());
    return rcpp_result_gen;
END_RCPP
}
// swmmRun
List swmmRun(String inputFileIn, String reportFileIn, String binaryFileIn);
RcppExport SEXP _swmm_swmmRun(SEXP inputFileInSEXP, SEXP reportFileInSEXP, SEXP binaryFileInSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< String >::type inputFileIn(inputFileInSEXP);
    Rcpp::traits::input_parameter< String >::type reportFileIn(reportFileInSEXP);
    Rcpp::traits::input_parameter< String >::type binaryFileIn(binaryFileInSEXP);
    rcpp_result_gen = Rcpp::wrap(swmmRun(inputFileIn, reportFileIn, binaryFileIn));
    return rcpp_result_gen;
END_RCPP
}

static const R_CallMethodDef CallEntries[] = {
    {"_swmm_swmmVersion", (DL_FUNC) &_swmm_swmmVersion, 0},
    {"_swmm_swmmRun", (DL_FUNC) &_swmm_swmmRun, 3},
    {NULL, NULL, 0}
};

RcppExport void R_init_swmm(DllInfo *dll) {
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
