# marc-utils
Simple tools to analyze and manipulate MARC files

# Disclaimers
These tools are to MARC what a Skilsaw is to carpentry -- primitive, but allows you do a lot very fast. 

The author has no way of knowing your needs or environment, so they may be completely unsuitable for your purposes and come without any kind of warranty or support. Use at your own risk. 

# Purpose
The MARC utils are minimal standalone command-line utilities that can be easily modified to serve needs at hand. They are designed primarily to facilitate quick analysis of MARC files and be integrated into shell processes and assume that you already have your favorite ways of parsing/searching text. 

# System requirements
bash and a version of awk that understands the "-b" switch (i.e. anything in the past couple decades should be good)

# The utilities

### marc2text
**Usage:** *marc2text [filename]*

Converts binary MARC to plain text. All it does is interpret the directory and stick labels in front of the contents of the fields. It does NOT replace subfield markers (hex 1F) with dollar signs, translate characters into expressions in curly braces, or replace spaces with backlashes in indicator or leader fields as it makes working with and analyzing the file with standard text utilities more awkward.

Although the text output format is different than MarcEdit, MarcEdit can read it.

Records with different than reported lengths and a few other basic problems are directed to separate files where they can be analyzed separately.

### text2marc
**Usage:** *text2marc [filename]*

Converts text files created by marc2text back to MARC -- it cannot read MarcEdit files. 

### marcsearch
**Usage:** *marcsearch [filename] [marc-tag] [regex_search_expression] [count]*

Extracts MARC records where regex_search_expression was found in a MARC tag and directs them to a file named "found_records.mrc". If you want to target a specific subfield, you'll need to create an expression that involves the subfield delimiters (hex 1F)

The count parameter is optional. If the word "count" is sent, marcsearch only reports on how many records it found without extracting them.

### marcfix
**Usage:** *marcfix [filename]*

Somewhat misnamed, marcfix doesn't fix anything. Rather, it puts all the good records in one file, and separates out a bunch with a series of common problems that can trip up processing in others

### marcfc
**Usage:** *marcfc [filename]*
Gives frequency count for each MARC tag along with total record count. Does not do subfields at this point.
