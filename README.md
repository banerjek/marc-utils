# marc-utils
The marc-utils are a set of minimal tools to allow fast analysis of MARC and extractions from files using command line utilities. Functionality is limited to maximize speed and transparency to facilitate modification for needs at hand. They will be most useful if added to your path.

# Table of Contents
* [**marc**](#marc) -- Converts text in text2marc format sent to stdin to MARC
* [**marcadd**](#marcadd) -- Add a field to a MARC record from command line or source file
* [**marccopy**](#marccocopy) -- Copies one MARC field to another
* [**marccount**](#marccount) -- Simple count of MARC records
* [**marctac**](#marctac) -- Reverse order of records in MARC file
* [**marc2text**](#marc2text) -- Convert binary MARC files to text
* [**marc2tsv**](#marc2tsv) -- Extract MARC fields into TSV file 
* [**marcdelete**](#marcdelete) -- Delete MARC field based on tag and regex
* [**marcextract**](#marcextract) -- Extract record identifier and data from MARC tag 
* [**marcextractbyid**](#marcextractbyid) -- Extract records matching or not matching a list of identifiers
* [**marcfc**](#marcfc) -- Provide field and subfield counts
* [**marcfield2tsv**](#marcfield2tsv) -- Extract bib identifier and subfields from single MARC tag
* [**marcfix**](#marcfix) -- Divide MARC records by type and fix some common issues
* [**marcgrep**](#marcgrep) -- Search raw file or stdin for regex and render output as text
* [**marchead**](#marchead) -- Extract first part of MARC files 
* [**marcmissing**](#marcmissing) -- Extract MARC records based absence of a specified tag
* [**marcless**](#marcless) -- Page through MARC records through unix less command
* [**marcremap**](#marcremap) -- Remap one MARC field to another 
* [**marcreplace**](#marcreplace) -- MARC regex replacement within a field tag
* [**marcsample**](#marcsample) -- Extract at least one record with every field/subfield combination from a MARC stream and delivers field/subfield counts for the entire file 
* [**marcsearch**](#marcsearch) -- Extract MARC records containing a search pattern
* [**marcslice**](#marcslice) -- Extract sequence of records from a MARC file
* [**marcsort**](#marcsort) -- Sort MARC files by field
* [**marcsplit**](#marcsplit) -- Split large MARC file into many small files
* [**marctail**](#marctail) -- Extract last part of MARC files 
* [**tag**](#tag) -- Extract single MARC tag
* [**tagfc**](#tagfc) -- Counts MARC fields and subfields from stdin 
* [**text**](#text) -- Converts MARC on stdin to text
* [**text2marc**](#text2marc) -- Convert text files to MARC

# Disclaimers

The author has no way of knowing your needs or environment, so they may be completely unsuitable for your purposes and come without any kind of warranty or support. Use at your own risk. 

# System requirements
bash and a version of awk that understands the "-b" switch (i.e. anything from the past couple decades that's in your base linux distro should be good). However, you may need to install gawk if you're on a Mac.

# The utilities

## marc
**Usage:** *marc*   
**Example:** *%! marc* (within vi subshell to convert text record to MARC)
**Example:** *cat marcfile.txt | marc > out.mrc*   

Lightweight conversion of MARC to text to simplify viewing binary MARC files without creating temp files. Handy for converting text representations from marc2text(not Marcedit) into MARC while in a vi viewing pane. 

## marcadd
**Usage:** *marcadd [marcfile] [tag] [value]*   
**Usage:** *marcadd [marcfile] [tagfile] [idtag]*   
**Example:** *marcadd marc_file.mrc 997 "  "$'\x1f'"asomevalue"*
**Example:** *marcadd marc_file.mrc values_to_add.tsv 001*

Adds a MARC field to every record if given an interactive argument, adds specified tags to matching records in a tab delimited file containing identifier, tag, and value. Indicators and subfield characters should be included in [value] but not the terminating end of field marker

## marctac
**Usage:** *marctac [filename]*   
**Example:** *marctac marc_file.mrc*

Reverses order of records in MARC file

## marc2text
**Usage:** *marc2text [filename]*   
**Example:** *marc2text marc_file\*.mrc*   

Converts binary MARC to plain text. Wildcard expressions can be used to process multiple files. All *marc2text* does is interpret the directory and stick labels in front of the contents of the fields. It does NOT replace subfield markers (hex 1F) with dollar signs, translate characters into expressions in curly braces, or replace spaces with backlashes in indicator or leader fields as this slows processing and makes working with and analyzing the file with standard text utilities more awkward.

The text output format is not the MarcBreaker format used by MarcEdit. However, tools that read that format can read these files -- it is the same, except it doesn't require string replacements before being converted to MARC.

## marc2tsv
**Usage:** *Usage: marc2tsv [filename] [list of MARC fields]*   
**Example:** *marc2tsv marc_file.mrc ldr 245 337b 650a*   

Extracts specific MARC tags or subfields into TSV file.

Whole tags are extracted, leading subfield marker (usually a) is stripped. The subfield delimiter (hex 1F) is left in all but first field.

001 is output by default, and repeated fields are subdelimited with a semicolon. Use "ldr" to extract the leader. Add a single subfield after tags to extract specific subfields

## marccopy
**Usage:** *marccopy [filename] [sourcetag] [destinationtag]*   
**Example:** *marccopy myfile.mrc 852 952*   

Copies one MARC field to another

## marccount
**Usage:** *marccount [filename]*   
**Example:** *marccount myfilelist*.mrc*   

Counts MARC records based on detection of end of record markers

## marcdelete
**Usage:** *marcdelete [filename] [tag_regex] [regex]*   
**Example:** *marcdelete myfile.mrc 856 ezproxy*   
**Example:** *marcdelete myfile.mrc ^65 .*   

Delete MARC tag based on regex. Tag can be expressed as regex

## marcextract
**Usage:** *Usage: marcextract [filename] [marcfield] [idtag]*   
**Example:** *marcextract marcfile.mrc 852p*   

Outputs record identifier and MARC tag. The idtag parameter is optional. If left out, the record ID will be assumed to be 001. If no subfield is given, the full content from the tag including all subfields will be included.

## marcextractbyid
**Usage:** *Usage: marcextractbyid [filename] [marcid_field]*   
**Usage:** *Usage: marcextractbyid [filename] [id_value] [marcid_field]*   
**Example:** *marcextractbyid marcfile.mrc 907a*   
**Example:** *marcextractbyid marcfile.mrc*   
**Example:** *marcextractbyid marcfile.mrc 1234567*   
**Example:** *marcextractbyid marcfile.mrc 1234567 907a*   

Extracts MARC records based on a list of identifiers contained in a file named "ids" or a single identifier argument. The marcid_field is optional and will be presumed to be 001 unless otherwise specified. Separate output files are created for records matching and not matching the list of identifiers 

## marcfc
**Usage:** *marcfc [filename]*   
**Example:** *marcfc marc_file\*.mrc*   

Gives frequency count for each MARC tag and subfield count. Wildcard expressions can be used to process multiple files.

## marcfield2tsv
**Usage:** *Usage: marcfield2tsv [filename] [idfield] [marctag] [subfield1] [subfield2] ...*   

id field is optional. If not supplied, 001 is assumed

**Example:** *marcfield2tsv marcfile.mrc 949 907a a b c d*   
**Example:** *marcfield2tsv marcfile.mrc 952 a b c d*   

Extract bib identifier and subfields from single MARC tag. 

## marcfix
**Usage:** *marcfix [filename]*   
**Example:** *marcfix marc_file\*.mrc*   

Analyzes a MARC stream separating out bib, holdings, and authority records performing minor repairs to some leader values. Problematic records into separate files categorized by issue. Wildcard expressions can be used to process multiple files.

## marcgrep
**Usage:** *marcgrep [regex] [filename]*   
**Example:** *marcgrep 12345 marc_file.mrc*   
**Example:** *%! marcgrep 12345 (within vi subshell)*   

Simple regex match through binary MARC file with output to text.

## marchead
**Usage:** *marchead [numlines] [filename]*   
**Example:** *marchead -1000 marc_file.mrc*   

Output first [numlines] records, *nix head style

## marcmissing
**Usage:** *marcmissing [filename] [tag]*   
**Example:** *marcmissing marc_file\*.mrc*   
**Example:** *marcmissing marc_file\*.mrc 245a*   

Extracts MARC records based on absence of a 3 digit tag or 3 digit tag and one character subfield. If no tag is specified, 001 is assumed. 

## marcless
**Usage:** *marcless [filename]*   
**Example:** *marcmissing marc_file\*.mrc*   

Page through MARC records dynamically rendered as text. Requires "text" command from this page is in the PATH 

## marcremap
**Usage:** *marcremap [filename] [from-tag] [to-tag]*   
**Example:** *marcremap marcfile.mrc 999 949*   

Remaps one MARC field to another. Currently only does whole field content, not individual subfields.

## marcreplace
**Usage:** *marcreplace [filename] [searchfor] [replacewith]*   
**Example:** *marcreplace myfile.mrc 856u my.edu somevendor.com*   
**Example:** *marcreplace myfile.mrc 001 ^ myprefix_* [prefixes the field]
**Example:** *marcreplace myfile.mrc 001 $ _mysuffix* [suffixes the field]

Replace contents of field based on regex replacement. 

## marcsample
**Usage:** *marcsample [filename] *   
**Example:** *marcsample marcfile.mrc

Extracts at least one record with every field/subfield combination from a MARC stream and delivers field/subfield counts for the entire file 

## marcsearch
**Usage:** *marcsearch [filename] [marc-tag] [regex_search_expression] [count]*   
**Example:** *marcsearch marcfile.mrc 856 "my_proxy.edu"*   

Extracts MARC records where regex_search_expression was found in a MARC tag and directs them to a file named *[filename]_found.mrc*. If you want to target a specific subfield, you'll need to create an expression that involves the subfield delimiters (hex 1F)

To negate a search, add an exclamation point to the end of the regex, e.g. *marcsearch marcfile.mrc 856 "my_proxy.edu!"*   

The count parameter is optional. If the word "count" is sent, marcsearch only reports on how many records it found without extracting them.

## marcslice
**Usage:** *marcslice [filename] [startrecord] [endrecord] [count]*   
**Example:** *marcsearch marcfile.mrc 5000 6000*   
**Example:** *marcsearch marcfile.mrc 15 20 |text*   

Extracts MARC records from record [startrecord] which is an integer starting at 1 to [endrecord]. 

Output is to stdout. If you wish to view in text, run it through the |text filter

## marcsort
**Usage:** *marcsort [filename] *   
**Example:** *marcsort mrc_00\*.mrc*   

Sort MARC records in tag order

## marcsplit
**Usage:** *marcsplit [filename] [num_records]*   
**Example:** *marcsplit marc_file.mrc 1000*   
**Example:** *marcsplit marc_file.mrc -f 5*   

Splits large MARC file into multiple files, each containing *num_records* records. If *num_records* isn't provided, default is 1000. If -f switch is provided, the number following is the number of files desired.

## marctail
**Usage:** *marctail [numlines] [filename]*   
**Example:** *marctail -1000 marc_file.mrc*   

Output last [numlines] records, *nix head style

## tag
**Usage:** *tag [marc tag] [filename]*   
**Example:** *tag 650x marc_file.mrc*   
**Example:** *%! tag 650x* (within vi subshell to view 650x)

Extract a single tag from raw MARC file on stdin. 

## tagfc
**Usage:** *tagfc*   
**Example:** *%! tagfc (within vi subshell)

Get a frequency count of all tags and subfields from raw MARC file on stdin

## text
**Usage:** *text*   
**Example:** *%! text* (within vi subshell to view binary record as text)
**Example:** *cat marcfile.mrc | text > out.txt*   

Lightweight conversion of MARC to text to simplify viewing binary MARC files without creating temp files. Handy for converting text representations from marc2text into MARC while in a vi viewing pane. 

## text2marc
**Usage:** *text2marc [filename]*   
**Example:** *text2marc marc_file\*.mrc*   

Converts text files created by marc2text back to MARC -- it cannot read MarcEdit files. Wildcard expressions can be used to process multiple files. 

*text2marc* only reads files created by *marc2text*. It doesn't read MarkBreaker format files -- it achieves speed by not performing nonessential analysis or string conversions (i.e. human friendly representations of subfield delimiters and certain characters) 


