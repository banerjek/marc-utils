# marc-utils
The marc-utils are a set of minimal tools to allow fast analysis of MARC and extractions from files using command line utilities. Functionality is limited to maximize speed and transparency to facilitate modification for needs at hand. They will be most useful if added to your path.

# Table of Contents
* [**marc**](#marc) -- Converts MARC sent to stdin to text 
* [**marc2text**](#marc2text) -- Convert binary MARC files to text
* [**marc2tsv**](#marc2tsv) -- Extract MARC fields into TSV file 
* [**marcextract**](#marcextract) -- Extract record identifier and data from MARC tag matching a pattern 
* [**marcextractbyid**](#marcextractbyid) -- Extract records matching a list of identifiers
* [**marcfc**](#marcfc) -- Provide field and subfield counts
* [**marcfix**](#marcfix) -- Separate MARC records likely to cause processing issues
* [**marcmissing**](#marcmissing) -- Extract MARC records based absence of a specified tag
* [**marcsearch**](#marcsearch) -- Extract MARC records containing a search pattern
* [**marcsplit**](#marcsplit) -- Split large MARC file into many small files
* [**text2marc**](#text2marc) -- Convert text files to MARC

# Disclaimers

The author has no way of knowing your needs or environment, so they may be completely unsuitable for your purposes and come without any kind of warranty or support. Use at your own risk. 

# System requirements
bash and a version of awk that understands the "-b" switch (i.e. anything from the past couple decades that's in your base linux distro should be good). However, you may need to install gawk if you're on a Mac.

# The utilities

## marc
**Usage:** *marc*  
**Example:** *%! marc* (within vi subshell to view binary record as text)
**Example:** *cat marcfile.mrc | marc > out.mrc*

Lightweight conversion of MARC to text to simplify viewing binary MARC files without creating temp files. If you want to convert rather than viewfiles, marc2text is a better options

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

## marcextract
**Usage:** *Usage: marcextract [filename] [marcfield] '[regex_search_expression]' [idtag]*  
**Example:** *marcextract marcfile.mrc 856 "my_proxy.edu" 907*

Outputs record identifier and MARC tag searched where MARC records where regex_search_expression was found in the MARC tag to a file named *[filename]_extract.txt*. If you want to target a specific subfield, you'll need to create an expression that involves the subfield delimiters (hex 1F)

The idtag parameter is optional. If left out, the record ID will be assumed to be 001. Otherwise, the full content from the tag including all subfields will be included in the first column as the record identifier.

## marcextractbyid
**Usage:** *Usage: marcextractbyid [filename] [marcid_field]*  
**Example:** *marcextractbyid marcfile.mrc 907a*

Extracts MARC records based on a list of identifiers contained in a file named "ids." The marcid_field is optional and will be presumed to be 001 unless otherwise specified.

## marcfc
**Usage:** *marcfc [filename]*  
**Example:** *marcfc marc_file\*.mrc*

Gives frequency count for each MARC tag and subfield count. Wildcard expressions can be used to process multiple files.

## marcfix
**Usage:** *marcfix [filename]*  
**Example:** *marcfix marc_file\*.mrc*

Somewhat misnamed, marcfix doesn't fix anything. Rather, it puts all the good records in one file, and separates out problematic records into separate files categorized by issue. Wildcard expressions can be used to process multiple files.

## marcmissing
**Usage:** *marcmissing [filename] [tag]*  
**Example:** *marcmissing marc_file\*.mrc* 
**Example:** *marcmissing marc_file\*.mrc 245a*

Extracts MARC records based on absence of a 3 digit tag or 3 digit tag and one character subfield. If no tag is specified, 001 is assumed. 

## marcsearch
**Usage:** *marcsearch [filename] [marc-tag] [regex_search_expression] [count]*  
**Example:** *marcsearch marcfile.mrc 856 "my_proxy.edu"*

Extracts MARC records where regex_search_expression was found in a MARC tag and directs them to a file named *[filename]_found.mrc*. If you want to target a specific subfield, you'll need to create an expression that involves the subfield delimiters (hex 1F)

The count parameter is optional. If the word "count" is sent, marcsearch only reports on how many records it found without extracting them.

## marcssplit
**Usage:** *marcsplit [filename] [num_records]*  
**Example:** *marcsplit marc_file.mrc 1000"*

Splits large MARC file into multiple files, each containing *num_records* records. If *num_records* isn't provided, default is 500

## text2marc
**Usage:** *text2marc [filename]*  
**Example:** *text2marc marc_file\*.mrc*

Converts text files created by marc2text back to MARC -- it cannot read MarcEdit files. Wildcard expressions can be used to process multiple files. 

*text2marc* only reads files created by *marc2text*. It doesn't read MarkBreaker format files -- it achieves speed by not performing nonessential analysis or string conversions (i.e. human friendly representations of subfield delimiters and certain characters) 


