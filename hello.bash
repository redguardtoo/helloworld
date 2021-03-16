#!/bin/bash

str="   blog/blog-test.org | 72 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-"
str="tests/jasmine/lib/domReady.js:86:        //http://stackoverflow.com/questions/3665561/document-readystate-of-interactive-vs-ondomcontentloaded"
echo "str=${str}"
if [[ $str =~ ^[[:space:]]*([a-z0-9A-Z_.\/-]*).*$ ]]; then
    echo "BASH_REMATCH[0]=${BASH_REMATCH[0]}"
    echo "BASH_REMATCH[1]=${BASH_REMATCH[1]}"
fi
echo ${str}