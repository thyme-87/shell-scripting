# Snippits to write shell scripts

check if a file `$FILENAME` exists and is writable:
    
    if [ -w $FILENAME]; then
        echo $FILENAME "exists and is writable"
    else
        echo $FILENAME "does not exist or is not writable"
        return 1
    fi

careful: `exit 1` will close the shell wheareas `return 1` will keep the shell
open!

---

check if a file exists and then if it is readable. Print back the result and
exit the program if on of the conditions does not hold:

    if [ -e $FILENAME ]; then
        echo "File "$FILENAME "exists."

        if [ -r $FILENAME ]; then
            echo "File "$FILENAME "is readable"
        else
            echo "File "$FILENAME "is not readable"
            return 1
    else
        echo "File "$FILENAME "does not exist."
        return 1
    fi

---

To set environmental variables without permanently affecting the environment of
the shell:

    PATH=/bin:/usr/bin awk '...' [files]

This sets the variable `PATH` for this single call of awk to `/bin:/usr/bin`.

---

To temporarily _change_ or remove variables from a programs environment:

    env -i PATH=$PATH HOME=$HOME LC_ALL=C awk '...' [files]

`env -i` initializes the environment (removes inherited values and passes only
those variables that are explicitely stated in the command line).

---

Variables can also be removed using the `unset` command:

    unset LC_ALL

will remove the variable `$LC_ALL`

It is also possible to remove functions using the `unset` command:

    unset -f [my_function]

will remove the function `[my_function]`

**Note that there is a difference between setting a variable to null (MY_VAR= )
and unsetting = removing a variable from the environment using `unset`.

Note also, that by default undefined variables will expand to null (empty)
string!**

---

Get the length of a string:

    ${#variable_name}

---

## substitution operators vor parameter expression:

Return value of variable `my_var` if it exists and isn't null, otherwise return
string `is_empty`:

    ${my_var:-is_empty}

Return value of variable `my_var` if it exists and isn'T null, otherwise set it
to string `was_empty` and return the new set value:

    ${my_var:=was_empty}

Return value of variable `my_var` if it exists and isn't null, otherwise print
`my_var_does_not_exist_or_is_null` and abort the current command/script. If
there is no message set will print `null or not set`. The behaviour of different
shells may vary.

    ${my_var:?my_var_does_not_exist_or_is_null}

Return `my_message` if variable `my_variable` if it exists and isn't null,
otherwise return null:

    ${my_var:+my_message}

**The colon `:` in all expressions is optional. If the colon is omitted, the
condition changes from 'exists and isn't null' to 'exists'.**

---

## pattern-matching operators


For the following overview I'll use the following example: a variable `my_var`
with the value `/home/my_user/documents/my_doc.txt.BACKUP`.

Match the pattern against the beginning of the value of the variable. If the
pattern matches, delete the shortest part that matches and return the rest of the value:

    ${my_variable#pattern}

Example:
    
    ${my_variable#/*/}

Result:

    /my_user/documents/my_doc.txt.BACKUP

Match the pattern against the beginning of the value of the variable. If the
pattern matches, delete the longest part that matches and return the rest of the
value:

    ${my_variable##pattern}

Example:
    
    ${my_variable##/*/}

Result:

    my_doc.txt.BACKUP

Match the pattern against the end of the value of the variable. If the pattern
matches, delete the shortest part that matches and return the rest of the value:

    ${my_variable%pattern}

Example:

    ${my_var%.*}

Result:

    /home/my_user/documents/my_doc.txt

Match the pattern against sthe end of the value of the variabel. If the pattern
matches, delete the longest part that matches and return the rest of the value:

    ${my_var%%pattern}

Example:
    
    ${my_var%%.*}

Result:

    /home/my_user/documents/my_doc

---

## Positional parameters

Positional parameters = command line arguments.

Parameters can be addressed via: `$[number]`, if [numbers] gets greater than `9`
it must be enclosed in braces: `${23}`.

All expressions for pattern matching can be applied also to positional
parameters:

    my_home=${HOME:-/home/my_user/}

Set variable `my_home` to the value of `HOME` if it exists and isn't null.
Otherwise set it to `/home/my_user/`.


### Special variables


Provide the total number of arguments passed to the shell script / function:

    $#

All command-line arguments at once:

    $*
    $@

All command-line arguments as one string: (uses the first character of `$IFS` as
seperator)

    "$*"

All command-line arguments as individual strings:

    "$@"
