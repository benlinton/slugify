# Bash Command: Slugify

Slugify is a bash command that converts filenames and directories to a web friendly format.

## Usage Help

Simply enter the slugify command without any arguments or with the -h option to view the usage help.

    $ slugify
    usage: slugify [-acdhintuv] source_file ...
       -a: remove spaces immediately adjacent to dashes
       -c: consolidate consecutive spaces into single space
       -d: replace spaces with dashes (instead of default underscores)
       -h: help
       -i: ignore case
       -n: dry run
       -t: treat existing dashes as spaces
       -u: treat existing underscores as spaces (useful with -a, -c, or -d)
       -v: verbose

## Usage Examples

Note, most examples below are run in verbose mode (-v) to help illustrate the results.

Verbose mode is unnecessary in real world scenarios.

#### Provide escaped filenames:

    $ slugify -v My\ \ file.txt
    rename: My  file.txt -> my__file.txt

#### Alternatively provide unescaped filenames inside quotes:

    $ slugify -v "My  file.txt"
    rename: My  file.txt -> my__file.txt

#### Globs (*, ?, etc.) work as well:

    $ slugify -v *.txt
    rename: My file.txt -> my_file.txt
    ignore: my_web_friendly_filename.txt

#### Provide an unlimited number of arguments:

    slugify -v "My first file.txt" "My second file.txt"
    rename: My first file.txt -> my_first_file.txt
    rename: My second file.txt -> my_second_file.txt

#### Directories are also supported:

    $ slugify -v "My Directory"
    rename: My Directory -> my_directory

#### Consolidate consecutive spaces into single spaces:

    $ slugify -vc "My    consolidated    file.txt"
    rename: My    consolidated    file.txt -> my_consolidated_file.txt

#### Replace spaces with dashes:

    $ slugify -vd "My dashed file.txt"
    rename: My dashed file.txt -> my-dashed-file.txt

The -d option replaces each space with a dash.

    $ slugify -vd "My  dashed  file.txt"
    rename: My  dashed  file.txt -> my--dashed--file.txt

Combine -d with -c (consolidate spaces) for a single dash between each word.

    $ slugify -vdc "My  dashed  file.txt"
    rename: My  dashed  file.txt -> my-dashed-file.txt

#### Ignore case:

    $ slugify -vi "UPPER CASE FILE.txt"
    rename: UPPER CASE FILE.txt -> UPPER_CASE_FILE.txt

#### Play it safe with a dry run:

Dry run mode does not alter the filesystem in any way.

    $ slugify -n *
    --- Begin dry run mode.
    rename: My file.txt -> my_file.txt
    ignore: web_friendly_filename.txt
    --- End dry run mode.

Dry run mode also allows you to test filenames that don't exist. Great for testing!

    slugify -n "Ghost File.txt"
    --- Begin dry run mode.
    not found: Ghost File.txt
    rename: Ghost File.txt -> ghost_file.txt
    --- End dry run mode.

Dry run mode automatically enables verbose mode so there is no need to include the -v option with -n.

#### Handle spaces adjacent to dashes:

In this example, without -a the dashes end up surrounded by underscores.

    $ slugify -v "The Beatles - Yellow Submarine.mp3"
    rename: The Beatles - Yellow Submarine.mp3 -> the_beatles_-_yellow_submarine.mp3

But with -a the adjacent spaces are removed.

    $ slugify -va "The Beatles - Yellow Submarine.mp3"
    rename: The Beatles - Yellow Submarine.mp3 -> the_beatles-yellow_submarine.mp3

The -a only removes spaces immediately adjacent to a dash, which may not be the desired effect (below three spaces get converted to two underscores).

    $ slugify -va "The Beatles   -   Yellow Submarine.mp3"
    rename: The Beatles   -   Yellow Submarine.mp3 -> the_beatles__-__yellow_submarine.mp3

But -c consolidates spaces into a single space and then -a will remove the left over adjacent single spaces.

    $ slugify -vac "The Beatles   -   Yellow Submarine.mp3"
    rename: The Beatles - Yellow Submarine.mp3 -> the_beatles-yellow_submarine.mp3

#### Convert existing underscores into dashes

The -u treats underscores as spaces and -d converts spaces into dashes.

    $ slugify -vud "Spaces Dashes-And_Underscores.txt"
    rename: Spaces Dashes-And_Underscores.txt -> spaces-dashes-and-underscores.txt

#### Convert existing dashes into underscores

    $ slugify -vt "Spaces Dashes-And_Underscores.txt"
    rename: Spaces Dashes-And_Underscores.txt -> spaces_dashes_and_underscores.txt

