

read -r -d '' awkscript << "ENDOFAWK"
#!/usr/bin/awk -f 

BEGIN { records_found = 0 
        if (length("а") != 2) {
                badawk = 1
                printf("Your version of awk does not support marc2tsv -- you need a version that supports the -b switch\\n")
                exit
        } 
}

function extract_subfields() { 
	if (length(marc_tag) == 4) {
		search_subfield = substr(marc_tag, 4, 1)

		split(field_content, subfields, SFS)

		for (subfield in subfields) {
			if (substr(subfields[subfield], 1, 1) == search_subfield) {
				print substr(subfields[subfield],2)
			}	
		}
		#if (substr(field_content, 1, 2) == SFS"a") { field_content = substr(field_content, 3) }
	}
}

function extract_tag() {
	if (marc_tag == "ldr"){ print leader }

	for (i=1; i<=directory_length; i=i+12) {
		if (substr(directory, i, 3) == substr(marc_tag, 1, 3)) {

			field_length = substr(directory, i + 3, 4) + 0
			starting_pos = substr(directory, i + 7, 5) 

			if (substr(record_content, starting_pos + 3, 1) == SFS) {
				field_content = substr(record_content, starting_pos + 3, field_length - 3)
			} else {
				field_content = substr(record_content, starting_pos + 1, field_length - 1)
			}
			if (length(marc_tag) == 4) {
				extract_subfields()
			} else {
				print field_content
			}
		}
	}
}

{


leader=substr($0,1,24)
baseaddress=substr(leader,13, 5) + 0
directory=substr($0,25, baseaddress - 25)
directory_length=length(directory) 
directory_check=(directory_length % 12)
record_content=substr($0, baseaddress + 1)

if (directory_check == 0) {
	if (NR == 1) { 
		print marc_tag
	}
	extract_tag() 
}


}

ENDOFAWK

tmp_awk=$(mktemp)
tmp_mrc=$(mktemp)

echo -e "${awkscript}" > $tmp_awk
chmod 700 $tmp_awk

infile="${2}"

if [[ -f "${infile}" ]];then
	echo balp
	cp "${infile}" $tmp_mrc
else
	cp /dev/stdin $tmp_mrc
fi

awk -v RS=$'\x1d' -v ORS="\n" -v SFS=$'\x1f' -v FS=$'\x1e' -v OFS="\t" -v marc_tag="${1}" -b -f $tmp_awk $tmp_mrc

rm -f $tmp_awk $tmp_mrc
