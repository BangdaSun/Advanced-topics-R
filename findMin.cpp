#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
double findMin(NumericVector x){
	// Rcpp support STL-style iterators
	NumericVector::iterator it = std::min_element(x.begin(), x.end());
	
	// we want the value so dereference
	return *it;
}

