#!/usr/bin/RScript

# This script takes CSV data from stdin for multiple (labelled) languages
# and works out an estimated distance between the languages (essentially
# the percentage of a random sample of utterances whose meaning is agreed between
# the two languages)

# include as args comma-separated pairs of language labels to compare, e.g. to
# compare lang1 with lang2 and lang2 with lang3

# USAGE: ./language_distance.R [lang1,lang2] .. [lang2,lang3]
# INPUT: standard language format
# OUTPUT: single value measure of distance

suppressWarnings(library(optparse))

# parse command line arguments
args <- commandArgs(TRUE)

# collect data from stdin into data frame
all.data <- read.delim("stdin",
                sep=",",
                stringsAsFactors=TRUE,
                header=TRUE,
                na.strings="")

cat("lang1", "lang2", "distance","\n", sep=",") # csv header

# for each 2-combination of language labels to compare...
for(pair in args) {
    # work out names (should be 2 comma-separated labels)
    langs <- strsplit(pair, ",")
    lang.name.1 <- langs[[1]][1]
    lang.name.2 <- langs[[1]][2]

    # select these labels
    data.l1 <- subset(all.data, lang.name==lang.name.1)
    data.l2 <- subset(all.data, lang.name==lang.name.2)

    # calculate which proportion are differently labelled
    count.total <- nrow(data.l1)
    count.diff <- sum(data.l1$word != data.l2$word)
    count.proportion.error <- count.diff / count.total
    
    # print to stdout
    cat(lang.name.1, lang.name.2, count.proportion.error, "\n", sep=",") 
}
