# marc-utils
The marc-utils are a set of minimal tools to allow fast analysis of MARC and extractions from files using command line utilities. Functionality is limited to maximize speed and transparency to facilitate modification for needs at hand. They will be most useful if added to your path.

# Table of Contents
1. [**marc2text**](#marc2text) -- Convert binary MARC files to text
2. [**text2marc**](#text2marc) -- Convert text files to MARC
3. [**marcsearch**](#marcsearch) -- Extract MARC records containing a search patterns
4. [**marcfix**](#marcfix) -- Separate MARC records likely to cause processing issues
5. [**marcfc**](#marcfc) -- Provide field counts

# Disclaimers

The author has no way of knowing your needs or environment, so they may be completely unsuitable for your purposes and come without any kind of warranty or support. Use at your own risk. 

# System requirements
bash and a version of awk that understands the "-b" switch (i.e. anything from the past couple decades that's in your base linux distro should be good). 

# The utilities

## marc2text
**Usage:** *marc2text [filename]*  
**Example:** *marc2text marc_file_001\*.mrc*

Converts binary MARC to plain text. Wildcard expressions can be used to process multiple files. Records with different than reported lengths and a few other basic problems are directed to separate files where they can be analyzed separately.
All *marc2text* does is interpret the directory and stick labels in front of the contents of the fields. It does NOT replace subfield markers (hex 1F) with dollar signs, translate characters into expressions in curly braces, or replace spaces with backlashes in indicator or leader fields as this slows processing and makes working with and analyzing the file with standard text utilities more awkward.

The text output format is not the MarcBreaker format used by MarcEdit. However, tools that read that format can read these files -- it is the same, except it doesn't require string replacements before being converted to MARC.

Records with different than reported lengths and a few other basic problems are directed to separate files where they can be analyzed separately.

## text2marc
**Usage:** *text2marc [filename]*  
**Example:** *text2marc marc_file_001\*.mrc*

Converts text files created by marc2text back to MARC -- it cannot read MarcEdit files. Wildcard expressions can be used to process multiple files. 

*text2marc* only reads files created by *marc2text*. It doesn't read MarkBreaker format files -- it achieves speed by not performing nonessential analysis or string conversions (i.e. human friendly representations of subfield delimiters and certain characters) 

## marcsearch
**Usage:** *marcsearch [filename] [marc-tag] [regex_search_expression] [count]*  
**Example:** *marcsearch marcfile.mrc 856 "my_proxy.edu"*

Extracts MARC records where regex_search_expression was found in a MARC tag and directs them to a file named *[filename]_found.mrc*. If you want to target a specific subfield, you'll need to create an expression that involves the subfield delimiters (hex 1F)

The count parameter is optional. If the word "count" is sent, marcsearch only reports on how many records it found without extracting them.

## marcextract
**Usage:** *Usage: marcextract [filename] [marcfield] '[regex_search_expression]' [idtag]*  
**Example:** *marcsearch marcfile.mrc 856 "my_proxy.edu" 907*

Outputs record identifier and MARC tag searched where MARC records where regex_search_expression was found in the MARC tag to a file named *[filename]_extract.txt*. If you want to target a specific subfield, you'll need to create an expression that involves the subfield delimiters (hex 1F)

The idtag parameter is optional. If left out, the record ID will be assumed to be 001. Otherwise, the full content from the tag including all subfields will be included in the first column as the record identifier.

## marcfix
**Usage:** *marcfix [filename]*  
**Example:** *marcfix marc_file_001\*.mrc*

Somewhat misnamed, marcfix doesn't fix anything. Rather, it puts all the good records in one file, and separates out problematic records into separate files categorized by issue. Wildcard expressions can be used to process multiple files.

## marcfc
**Usage:** *marcfc [filename]*  
**Example:** *marcfc marc_file_001\*.mrc*

Gives frequency count for each MARC tag along with total record count. Does not do subfields at this point. Wildcard expressions can be used to process multiple files.



