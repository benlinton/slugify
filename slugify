#!/usr/bin/env bash
#: Name        : slugify
#: Date        : 2012-05-01
#: Author      : "Benjamin Linton" <developer@benlinton.com>
#: Version     : 1.0.0
#: Description : Convert filenames into a web friendly format.
#: Options     : See print_usage() function.

## Initialize defaults
script_name=${0##*/}
dashes_omit_adjacent_spaces=0
consolidate_spaces=0
space_replace_char='_'
ignore_case=0
dry_run=0
dashes_to_spaces=0
underscores_to_spaces=0
verbose=0

## Initialize valid options
opt_string=acdhintuv

## Usage function
function print_usage(){
  echo "usage: $script_name [-$opt_string] source_file ..."
  echo "   -a: remove spaces immediately adjacent to dashes"
  echo "   -c: consolidate consecutive spaces into single space"
  echo "   -d: replace spaces with dashes (instead of default underscores)"
  echo "   -h: help"
  echo "   -i: ignore case"
  echo "   -n: dry run"
  echo "   -t: treat existing dashes as spaces"
  echo "   -u: treat existing underscores as spaces (useful with -a, -c, or -d)"
  echo "   -v: verbose"
}

## For each provided option arg
while getopts $opt_string opt
do
  case $opt in
    a) dashes_omit_adjacent_spaces=1 ;;
    c) consolidate_spaces=1 ;;
    d) space_replace_char='-' ;;
    h) print_usage; exit 0 ;;
    i) ignore_case=1 ;;
    n) dry_run=1 ;;
    t) dashes_to_spaces=1 ;;
    u) underscores_to_spaces=1 ;;
    v) verbose=1 ;;
    *) exit 1 ;;
  esac
done

## Remove options from args
shift "$(( $OPTIND - 1 ))"

## Unless source_file arg(s) found, print usage and exit (0 to avoid breaking pipes)
if [[ ! -n "$1" ]]; then
  print_usage
  exit 0
fi

## Identify case insensitive filesystems
case_sensitive_filesystem=1
case $OSTYPE in
  darwin*) case_sensitive_filesystem=0 ;; # OS X
  *) ;; # Do nothing
esac

## Notify if in dry_run mode
if [ $dry_run -eq 1 ]; then
  echo "--- Begin dry run mode."
fi

## For each file, directory, or glob
for source in "$@"; do

  ## Verify source exists
  if [ ! -e "$source" ]; then
    echo "not found: $source"
    ## Skip to next loop iteration unless in dry run mode
    if [ $dry_run -eq 0 ]; then
      continue
    fi
  fi

  ## Initialize target
  target="$source"

  ## Optionally convert to lowercase
  if [ $ignore_case -eq 0 ]; then
    target=$(echo "$target" | tr A-Z a-z )
  fi

  ## Optionally convert existing underscores to spaces
  if [ $underscores_to_spaces -eq 1 ]; then
    target=$(echo "$target" | tr _ ' ')
  fi

  ## Optionally convert existing dashes to spaces
  if [ $dashes_to_spaces -eq 1 ]; then
    target=$(echo "$target" | tr - ' ')
  fi

  ## Optionaly consolidate spaces
  if [ $consolidate_spaces -eq 1 ]; then
    target=$(echo "$target" | tr -s ' ')
  fi

  ## Optionally remove spaces immediately adjacent to dashes
  if [ $dashes_omit_adjacent_spaces -eq 1 ]; then
    target=$(echo "$target" | sed 's/\- /-/')
    target=$(echo "$target" | sed 's/ \-/-/')
  fi

  ## Replace spaces with underscores or dashes
  target=$(echo "$target" | tr ' ' "$space_replace_char")

  ## Handle moving the source to target
  if [ "$target" == "$source" ]; then
    ## If filename hasn't changed, skip move
    ## Print if verbose is true
    if [ $verbose -eq 1 ]; then
      echo "ignore: $source"
    fi
  elif [ -e "$target" -a $case_sensitive_filesystem -eq 1 ]; then
    ## If conflicts with existing filename, skip move and complain
    echo "conflict: $source"
  else
    ## If move is legal
    ## Skip move if dry_run is true
    if [ $dry_run -eq 0 ]; then
      mv "$source" "$target"
    fi
    ## Print if verbose or dry_run is true
    if [ $verbose -eq 1 -o $dry_run -eq 1 ]; then
      echo "rename: $source -> $target"
    fi
  fi

done

## Notify if in dry_run mode
if [ $dry_run -eq 1 ]; then
  echo "--- End dry run mode."
fi
