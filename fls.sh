#!/bin/sh
if [ $# -ne 1 ]
then
        echo Usage: fls filename
        exit 0
fi
filepath=`find ~ -name ${1##*/}`
arr=(${filepath})
if [ ${#arr[@]} -gt 1 ]
then
        for i in ${arr[@]}
        do
                ls -l $i
        done
else
        if [ -n "$filepath" ] && [ -f $filepath ]
        then
                ls -l $filepath
        else
                echo does the file \"$1\" exist?
        fi
fi