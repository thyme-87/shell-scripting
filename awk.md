# awk

Snippets for `awk`

Print the first field using space (` `) as field delimiter:

    $ awk '{ print $1 }'

Print the first field using comma (`,`) as field delimiter:

    $ awk -F, '{ print $1 }'

Print the first and fith field using (`,`) as field delimiter for the input and (`;`) as
delimiter for the output:

    $ awk -F, -v 'OFS=;' '{ print $1, $5 }'

use awk to replace all `\n` characters with `;`

    $ awk -v '{ gsub("\n", ";"); print }'

Defining `;` as the input Record Seperator (per default the Record Seperator is
newline)

    $ awk -v RS=";"

Special case: setting `RS=""` will define a blank line as Record Seperator

Output Record Seperator: there is also a Record Seperator for `awk`'s output:

    $ awk ORS=";"
