#SHELL := /bin/bash
.DELETE_ON_ERROR:

# for printing variable values
# usage: make print-VARIABLE
#        > VARIABLE = value_of_variable
print-%  : ; @echo $*=$($*)

PKG_VERSION=2.0.0.1

R_BUILD_ARGS= --no-manual --no-build-vignettes
R_CHECK_ARGS= --no-manual --no-build-vignettes --as-cran

R_HOME=$(shell R RHOME)
R=$(R_HOME)/bin/R
RSCRIPT=$(R_HOME)/bin/Rscript

default: build/JadesKernel_$(PKG_VERSION).tar.gz

build/JadesKernel_$(PKG_VERSION).tar.gz: $(wildcard R/*R) $(wildcard src/*cpp) DESCRIPTION
	@echo "building " $@ " because " $?
	@${RSCRIPT} -e 'Rcpp::compileAttributes()'
	@$(RSCRIPT) -e 'roxygen2::roxygenize()'
	@$(R) CMD build $(R_BUILD_ARGS) .
	@[ -d build ] || mkdir build
	@mv JadesKernel_$(PKG_VERSION).tar.gz build/

#.PHONY: install
install:
	R CMD INSTALL --build .

check: build/JadesKernel_$(PKG_VERSION).tar.gz
	@echo "running R CMD check"
	@$(R) CMD check $(R_CHECK_ARGS) build/JadesKernel_$(PKG_VERSION).tar.gz
	@$(R) -f scripts/r_cmd_check_validate.R

.PHONY: clean
clean:
	rm -rf build
	rm -rf man
	rm -rf JadesKernel.Rcheck
	rm -rf R/RcppExports.R src/RcppExports.cpp
	rm -rf src/*o
	rm -rf *gz *zip
	rm -rf src/Makevars
	rm -rf src/*dll
	rm -rf inst/zmq
	rm -rf inst/include/zmq*
	rm -rf inst/include/x*
	rm -rf src/*gz
	rm -rf src/._*
	rm -rf src/x64
	rm -rf inst/._*
	rm -rf *.ipynb*
	rm -rf inst/libs
	rm -rf src-*
