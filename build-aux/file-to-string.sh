#!/bin/sh

outname="datastrings.h"

IFS="
"

# Process options (output filename)
while getopts "o:" option
do
  case $option in
    o) outname=$OPTARG ;;
    *) exit 1 ;;
  esac
done


shift $(($OPTIND - 1))

# Create the macro name for the header file
macroname=`echo $outname | tr "[:lower:]" "[:upper:]" | tr -c "[:alnum:]" "_"`

# write the header
echo "#ifndef "$macroname > $outname
echo "#define "$macroname >> $outname


# convert every supplied file
for file in $@
do
  echo $file

  # Create the name of the variable
  base=`basename $file`
  cname=`echo $base | tr "[:upper:]" "[:lower:]" | tr -c "[:alnum:]" "_"`
  cname=str_$cname

  echo "const char $cname[] = " >> $outname
  # Convert line by line
  for line in `cat $file`
  do
    line=`echo $line | sed -e 's/\"/\\\"/g'`
 
    echo "\"$line  \\\\n \"" >> $outname
  done

  echo ";" >> $outname

#  gdk-pixbuf-csource --raw --struct --name=$cname $file >> $outname
done


# write footer of the file
echo "#endif" >> $outname

