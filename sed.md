# sed


The `-i` option tells `sed` that it should write the output back into the source
file.

Replace all occurences of 'foo' with 'bar' in input file `foo_to_bar.txt`:

    $ sed -i 's/foo/bar/g' foo_to_bar.txt

Replace first occurence of 'foo' with 'foobar' in input file
`foo_to_foobar.txt`:

    $ sed -i 's/foo/&bar/1' foo_to_foobar.txt

Add a comment at the end of each line that begin with the string 'oldfunc' in
`all_funcs.txt`:

    $ sed -i '/^oldfunc/ s/$/ # TODO: needs to be refactured/g' all_funcs.txt

Note that each character can be stated as delimeter character, but typically `/`
is used. Both commands below are supposed to do the exact same thing:

    $ sed -i 's/foo/bar/1' first_foo_to_bar.txt
    $ sed -i 's:foo:bar:1' first_foo_to_bar.txt
