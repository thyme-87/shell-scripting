# sed

## change the file that is used as input:

replace all occurences of 'foo' with 'bar' in input file `foo_to_bar.txt`:

    $ sed -i 's/foo/bar/g' foo_to_bar.txt

replace first occurence of 'foo' with 'foobar' in input file
`foo_to_foobar.txt`:

    $ sed -i 's/foo/&bar/1' foo_to_foobar.txt

add a comment at the end of each line that begin with the string 'oldfunc' in
`all_funcs.txt`:

    $ sed -i '/^oldfunc/ s/$/ # TODO: needs to be refactured/g' all_funcs.txt
