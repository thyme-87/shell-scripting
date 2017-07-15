# awk

Snippets for `awk`

Print the first field using space (` `) as field delimiter:

    $ awk '{ print $1 }'

Print the first field using comma (`,`) as field delimiter:

    $ awk -F, '{ print $1 }'

Print the first and fith field using (`,`) as field delimiter for the input and (`;`) as
delimiter for the output:

    $ awk -F, -v 'OFS=;' '{ print $1, $5 }'
