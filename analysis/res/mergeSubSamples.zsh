#!/usr/bin/env zsh
# This script merges subsample runs of all the samples
# in a specified directory

# Switch to using an alias instead of passing location of binary on the command line
alias yoda-merge=`pwd`/yoda-merge
for d in $1*
do
    if [[ $d != *background* ]]; then

        # Merge subsample yoda files
        files=($d/*.<0->.yoda(:r:r))
        typeset -U files

        for BASE in $files; do
            echo "Subsample Merging "$BASE
            yoda-merge -o $BASE.yoda -f $BASE.dat $BASE.*.yoda || echo -e "\e[1;31mFAILED\e[0m"
            rm $BASE.*.yoda
        done

        #Merge Ntuples from Subsamples
        for f in $d/*NTuple.*.dat; do
            basename=${f:r:r}
            echo "NTuple Merging " $f " > " $basename.dat

            if [ -f $basename.dat ];
            then
		# remove first three lines (column headings)
                tail -n +4 $f >> $basename.dat
            else
                echo "Generating file"
		# remove first two lines anyway, for we have three copies of
		# the column header
                tail -n +3 $f >> $basename.dat
            fi

        done

        # Cleanup
        rm $d/*NTuple.*.dat
    fi
done
