#!/usr/bin/env Rscript
## Adopted from
## https://github.com/eddelbuettel/littler/blob/master/inst/examples/install.r
# Released under GPL (>= 2)

argv <- commandArgs(TRUE)

## Set environment variables REPOS and LIBLOC to overrride defaults
repos <- getOption("repos")
## NULL means install file, and we supported env var previously
if (Sys.getenv("REPOS") == "NULL") repos = NULL

## this makes sense on Debian where no packages touch /usr/local
lib.loc <- Sys.getenv("LIBLOC", unset="/usr/local/lib/R/site-library")

## helper function to for existing files with matching extension
isMatchingFile <- function(f) file.exists(f) && grepl("(\\.tar\\.gz|\\.tgz|\\.zip)$", f)

## helper function which switches to local (ie NULL) repo if matching file is presented
installArg <- function(f, lib, rep) install.packages(f, lib, if (isMatchingFile(f)) NULL else repos)

## use argv [filtered by installArg()], lib.loc and repos to install the packages
sapply(argv, installArg, lib.loc, repos)

## clean up any temp file containing CRAN directory information
sapply(list.files(path=tempdir(), pattern="^(repos|libloc).*\\.rds$", full.names=TRUE), unlink)
