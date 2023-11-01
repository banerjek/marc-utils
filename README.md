# marc-utils
The marc-utils are a set of minimal tools to allow fast analysis of MARC and extractions from files using command line utilities. Functionality is limited to maximize speed and transparency to facilitate modification for needs at hand. They will be most useful if added to your path.

# Table of Contents
1. [**marc2text**](#marc2text) -- Convert binary MARC files to text
2. [**marc2tsv**](#marc2tsv) -- Extract MARC fields ihto TSV file 
3. [**marcextract**](#marcextract) -- Extract record identifier and data from MARC tag matching a pattern 
3. [**marcextractbyid**](#marcextractbyid) -- Extract records matching a list of identifiers
4. [**marcfc**](#marcfc) -- Provide field and subfield counts
5. [**marcfix**](#marcfix) -- Separate MARC records likely to cause processing issues
6. [**marcid**](#marcid) -- Extract MARC records based on list of IDs or single id supplied as an argument
7. [**marcsearch**](#marcsearch) -- Extract MARC records containing a search patterns
8. [**marcsplit**](#marcsplit) -- Split large MARC file into many small files
9. [**text2marc**](#text2marc) -- Convert text files to MARC

# Disclaimers

The author has no way of knowing your needs or environment, so they may be completely unsuitable for your purposes and come without any kind of warranty or support. Use at your own risk. 

# System requirements
bash and a version of awk that understands the "-b" switch (i.e. anything from the past couple decades that's in your base linux distro should be good). However, you may need to install gawk if you're on a Mac.

# The utilities

## marc2text
**Usage:** *marc2text [filename]*  
**Example:** *marc2text marc_file_001\*.mrc*

Converts binary MARC to plain text. Wildcard expressions can be used to process multiple files. Records with different than reported lengths and a few other basic problems are directed to separate files where they can be analyzed separately.
All *marc2text* does is interpret the directory and stick labels in front of the contents of the fields. It does NOT replace subfield markers (hex 1F) with dollar signs, translate characters into expressions in curly braces, or replace spaces with backlashes in indicator or leader fields as this slows processing and makes working with and analyzing the file with standard text utilities more awkward.

The text output format is not the MarcBreaker format used by MarcEdit. However, tools that read that format can read these files -- it is the same, except it doesn't require string replacements before being converted to MARC.

Records with different than reported lengths and a few other basic problems are directed to separate files where they can be analyzed separately.

## marc2tsv
**Usage:** *Usage: marc2tsv [filename] [list of MARC fields]*  
**Example:** *marc2tsv marc_file_001\*.mrc ldr 245 337b 650a*

Extracts specific MARC tags or subfields into TSV file.

Whole tags are extracted, leading subfield marker (usually a) is stripped. The subfield delimiter (hex 1F) is left in all but first field.

001 is output by default, and repeated fields are subdelimited with a semicolon. Use "ldr" to extract the leader. Add a single subfield after tags to extract specific subfields

## marcextract
**Usage:** *Usage: marcextract [filename] [marcfield] '[regex_search_expression]' [idtag]*  
**Example:** *marcsearch marcfile.mrc 856 "my_proxy.edu" 907*

Outputs record identifier and MARC tag searched where MARC records where regex_search_expression was found in the MARC tag to a file named *[filename]_extract.txt*. If you want to target a specific subfield, you'll need to create an expression that involves the subfield delimiters (hex 1F)

The idtag parameter is optional. If left out, the record ID will be assumed to be 001. Otherwise, the full content from the tag including all subfields will be included in the first column as the record identifier.

## marcextractbyid
**Usage:** *Usage: marcextractbyid [filename] [marcid_field]*  
**Example:** *marcextractbyid marcfile.mrc 907a*

Extracts MARC records based on a list of identifiers contained in a file named "ids." The marcid_field is optional and will be presumed to be 001 unless otherwise specified.

## marcfc
**Usage:** *marcfc [filename]*  
**Example:** *marcfc marc_file_001\*.mrc*

Gives frequency count for each MARC tag and subfield count. Wildcard expressions can be used to process multiple files.

## marcfix
**Usage:** *marcfix [filename]*  
**Example:** *marcfix marc_file_001\*.mrc*

Somewhat misnamed, marcfix doesn't fix anything. Rather, it puts all the good records in one file, and separates out problematic records into separate files categorized by issue. Wildcard expressions can be used to process multiple files.

## marcid 
**Usage:** *marcid [filename] [id]*  
**Example:** *marcid marc_file_001\*.mrc*
**Example:** *marcid marc_file_001\*.mrc 12345678*

marcid extracts raw MARC records from source based on a list of ids (assumes an input file of ids named "ids") or a single id after the input file. It searches 001 and 907a based on exact match. 

## marcsearch
**Usage:** *marcsearch [filename] [marc-tag] [regex_search_expression] [count]*  
**Example:** *marcsearch marcfile.mrc 856 "my_proxy.edu"*

Extracts MARC records where regex_search_expression was found in a MARC tag and directs them to a file named *[filename]_found.mrc*. If you want to target a specific subfield, you'll need to create an expression that involves the subfield delimiters (hex 1F)

The count parameter is optional. If the word "count" is sent, marcsearch only reports on how many records it found without extracting them.

## marcssplit
**Usage:** *marcsplit [filename] [num_records]*  
**Example:** *marcsplit marc_file_001\*.mrc 1000"*

Splits large MARC file into multiple files, each containing *num_records* records. If *num_records* isn't provided, default is 500

## text2marc
**Usage:** *text2marc [filename]*  
**Example:** *text2marc marc_file_001\*.mrc*

Converts text files created by marc2text back to MARC -- it cannot read MarcEdit files. Wildcard expressions can be used to process multiple files. 

*text2marc* only reads files created by *marc2text*. It doesn't read MarkBreaker format files -- it achieves speed by not performing nonessential analysis or string conversions (i.e. human friendly representations of subfield delimiters and certain characters) 


