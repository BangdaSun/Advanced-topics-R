#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
double findMinIdx(NumericVector x) {
	NumericVector::iterator it = std::min_element(x.begin(), x.end());
	return it - x.begin();
}