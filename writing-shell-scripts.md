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

Variables can also be removed using the `unset` command.
To remove the variable `$LC_ALL`:

    unset LC_ALL


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

## Substitution operators vor parameter expression:

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

## Pattern-matching operators


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

**Positional parameters = command line arguments.**

Parameters can be addressed via: `$[number]`, if [numbers] gets greater than `9`
it must be enclosed in braces: `${23}`.

All expressions for pattern matching can be applied also to positional
parameters:

    my_home=${HOME:-/home/my_user/}

Set variable `my_home` to the value of `HOME` if it exists and isn't null.
Otherwise set it to `/home/my_user/`.

Provide the total number of arguments passed to the shell script / function:

    $#

All command-line arguments at once:

    $*
    $@

All command-line arguments as one string: (uses the first character of `$IFS` as
separator)

    "$*"

All command-line arguments as individual strings: _(recommendation for passing
command-line arguments on to another program)_

    "$@"

Example Output for alle commands. the '' indicate end and beginning of strings:

    set -- eins zwei "und drei"

    echo $*
    > 'eins' 'zwei' 'und' 'drei'
    echo $@
    > 'eins' 'zwei' 'und' 'drei'
    echo "$*"
    > 'eins zwei und drei'
    echo "$@"
    > 'eins' zwei' 'und drei'

The `shift` command removes the first positional parameter from the list,
starting left. 

### Special variables

    $#   Number of arguments given to the current process
    $@   Command-line arguments for the current process. Words in double quotes are
    $expanded to individual arguments
    $*   Command-line arguments for the current process. Words in double qoutes are not expanded into individual arguments
    $-   Options given to the shell on invocation
    $?   Exit status of the previous command
    $$   Process ID of shell process
    $0   Name of the shell program
    $!   Process ID of last background command
    $ENV    Only used by interactive shells; The shell expects a full pathname
    to a file that it then reads and executes on startup
    $HOME   Home directory (login directory for the user)
    $IFS    Internal field separator; mostly a list of characters that act as
    word separators. Default: space, tab, newline
    $LANG   Default name of the current locale; Overriden by the other LC_*
    variables
    $LC_ALL Default name of current locale; Overrices $LANG and the other LC_*
    variables
    $LC_COLLATE Name of current locale for character collation (sorting order)
    $LC_CTYPE   Name of current locale to determine character class for pattern
    matching
    $LC_MESSAGES    Name of the current language for output messages
    $LINENO     Line number in script/function that just ran
    $NLSPATH    Path to the message catalogs for messages in the language
    determined by $LC_MESSAGES
    $PATH       Search path for commands
    $PPID       Process ID of the parent process
    $PS1        Primary command prompt string. Default: "$ "
    $PS2        String to prepend continued lines. Default is "> "
    $PS3        String for execution tracing
    $PWD        Current working directory

## Exit statuses

0 indicates the successfull termination of a function or a script.
**Any non-zero exit status indicates an error!**

    0   exit after succesfully running the command/program
    >0  Failure with either redirection or word expansion (tilde, variable,
    command, artithmetic expansion, word splitting)
    1-125   Command/program exited unsuccessfully. Meaning of the individual
    numbers may vary for each command/program
    126     Command found, file was not executable
    127     Command not found
    >128    Command died due to receiving a signal (like kill)

Via `exit` it is possible to return any exit code in a script.

    exit 2 //exit and signal that there was a failure

## The 'test' command

Tests for file attributes, the result of string and number comparison and
returns the result as exit status. POSIX only standardized a rather small subset
of what is often available. So portability might become an issue for self
written scripts.

Examples:

    if test "$input" = "expected value"
    then
        echo "Input string matches expectation"
    fi

    //is the same as:
    if [ "$input" = "expected value" ]
    then
        echo "Input string matches expectation"
    fi

**The reason to put the variable for the `test` command in quotation marks is,
that the `test` command requires at least one argument. Putting the variable in
quotation marks will return an empty string if the variable is not set and thus
lead to the expected result (a failed test) instead of unexpected behaviour
of the program.**

**Another caveat is the implementation of string comparison. Comparisions
including empty strings and/or strings that start with a minus, the convention
emerged to prefix both strings with 'X'. As both sides are prefixed, the result
will be the same and through the prefix the behaviour of the test command will
always be reliable.** _(In modern shell implementations, this is not necessary,
but it may be needed for maximal portability)_

**Unfortunately, the test command may be fooled regarding file permissions. So
its advised to program defensively and attempt to execute a non-changing command
after running the test command against a file.** Example:

    if test -r filename && cat filename /dev/null
    then
        #as cat worked, we can read from the file and continue
    else
        #as cat failed, we can't read from the file and need to handle this
    fi

**Last caveat: test does not work for floating point values.**

List of test expressions (extract): (s1 stands for a string and fn for a
filename)

    s1      true if s1 is != null
    -N s1   true if s1 is != null
    -z s1   true if s1 is null
    -b fn   true if fn is block device file
    -c fn   true if fn is a character device file
    -d fn   true if fn is a directory
    -e fn   true if fn exists
    -f fn   true if fn is a regular file
    -g fn   true if setgid bit is set for fn
    -h fn   true if fn is a symbolic link
    -L fn   true if fn is a symbolic link (same as -h)
    -p fn   true is fn is a named pipe (FIFO file)
    -r fn   true if fn is readable
    -S fn   true is fn is a socket
    -s fn   true if file is not empty
    -t n    true if file descriptor n points to a terminal
    -u fn   true if stuid bit is set for fn
    -w fn   true if fn is writable
    -x fn   true if fn is executable
    s1 != s2 true if s1 and s2 are not the same
    s1 = s2 true if s1 and s2 are the same
    n1 -eq n2   true if integers n1 and n2 are equal
    n1 -ne n2   true if integers n1 and n2 are not equal
    n1 -lt n2   true if n1 is less than n2
    n1 -gt n2   true if n1 is greater than n2
    n1 -ge n2   true if n1 is greater than or equal to n2

Tests can negated using `!`.


### if else

Example:

    if [ -w myLogfile ]
    then
        echo "execution successfull!" >> myLogfile
    elif [ -e myLogfile ] && [ ! -w myLogfile ]
    then
        echo "Logfile present but not writable!"
    elif
    then
        echo "Logfile not present!"
    fi

### case 

Example:

    echo "Please insert the day of the week:" read myVariable
    case $myVariable in
    monday | mon)
        echo "Another monday :/"
        ;;
    tuesday | tue)
        echo "Tuesday is here"
        ;;
    wednesday | wed)
        echo "Made it already half through the week!"
        ;;
    thursday | thu)
        echo "Weekend is just two days away!"
        ;;
    friday | fr)
        echo "Thank god it's friday!"
        ;;
    *)
        echo "Unknown input!"
    esac

### for loops

Example: rename all png-files in the folder by adding '_old' to their filename.

    for i in *.png
    do
        echo verschiebe $i nach $(sed 's/^\w*[^.]/&_old/'<<< $i)
        mv $i $(sed 's/^\w*[^.]/&_old/'<<< $i)
    done

If the `in ...` part is omitted, the shell loops over the command-line
arguments. So this example will print out all command-line arguments one
argument per line:

    for i
    do
        echo $i
    done

### while/until loops

Example for while loop: _(note the usage of `[ ! ... ]` and that the variable is put into
quotation marks)_

    while [ ! "$input" = "Y" ] && [ ! "$input" = "N" ]
    do
        echo "Please anser with Y for 'Yes' and N for 'No'"
        read input
    done

Example for until loop: _(note that now we test for the conditions to become
true. Also, instead of && for AND we now have to use || for OR)_

    until [ "$input" = "Y" ] || [ "$input" = "N" ]
    do
        echo "Please anser with Y for 'Yes' and N for 'No'"
        read input
    done

It is possible to use `break` and `continue` in any loop and provide an
(optional) numerical value to specify the 'level' of nested loops that should be
skipped/broken out of.

    while true #level 1
    do
        while true #level 2
        do
            while true #level 3
            do
                break 3 #breaks out of all loops
            done
        done
    done


This example uses the `while` loop together with `case` to skip throug all
command-line arguments passed to the script and match them against its defined
flags. **Note that this snippit will set the values for its variables according
to the last occurence of a defined argument. It won't give a warning or an
error, if an argument occurs multiple times.**

    file= verbose= quiet= long=

    while [ $# -gt 0 ] #while $# is greater than 0; $# is the number or arguments passed
        do
            case $1 in
                -f) file=$2
                    shift
                    ;;
                -v) verbose=true
                    quiet=
                    ;;
                -q) quiet=true
                    verbose=
                    ;;
                -l) long=true
                    ;;
                --) shift
                    break
                    ;;
                -*) echo $0: $1: unrecognized option >&2
                    ;;
                *) break
                    ;;
            esac

            shift
        done

### getopts

Using while/case or other loop constructs to handle command-line arguments is
trivial but not very convenient.

It is much simplet to use the `getopts` command instead: _(Note that the prefix
'-' is no longer needed. Note the usage of $OPTARG for the filename. Not also,
that getopts handles '--' as end end of argument list by itself.)_

    file= verbose= quiet= long=

    while getopts f:vql opt
    do
        case $opt in
        f)  file=$OPTARG
            ;;
        v)  verbose=true
            quiet=
            ;;
        q)  quiet=true
            verbose=
            ;;
        l)  long=true
            ;;
        esac
    done

    shift $((OPTIND -1)) #remove options, keep arguments

The script above now has its own problem: getops will handle all errors by
itself - so we don't have the option to print our own error message.

To change this, we can place a colon `:` in the option string as the first
character:

    while getopts :f:vql opt

With this instruction, `getopts` wil not print its own error messages. Secondly
it will set invalid variables to a question mark (upon we can now print our own
error mesage). And thirdly, it will keep the invalid option in `OPTARG` so that
we can also print that back to the user.

So the final version of our snippit looks like:

    file= verbose= quiet= long=

    while getopts :f:vql opt
    do
        case $opt in
        f)  file=$OPTARG
            ;;
        v)  verbose=true
            quiet=
            ;;
        q)  quiet=true
            verbose=
            ;;
        l)  long=true
            ;;
        '?') echo "$1: is invalid! -$OPTARG" >&2
             echo "Usage: $0 [-f file] [vql] [files ...]" >&2
             exit 1
             ;;
        esac
    done

    shift $((OPTIND -1))

**Note that the OPTIND-variable is shared between a script and child-scripts that
are called from within the first script! So the usage in  child-script requires
at least to set OPTIND=1 but in general it is not a good idea to do so.**

## Functions

* Functions need to be defined **before** they can be used.
* Within a function, positional parameters like `$1, $2 ...` refer to arguments
    that where passed to that function. So positional parameters passed to a
    script are not directly available from within a function. The only exception
    being `$0` wher ethe name of the script is stored.
* The `return` command is used to leave a function. The `return` command passes
    its argument back to the calling command and thus can be used in a control
    structure.
* Using `exit` in a function exits the whole script and not only the function.
* Functions can not declare local variables with the same name as variables
    declared at any other place in the script.

Example:

    my_happy_function() {
        echo "$1" $1
    }

    my_happy_function "This is a test!"

will print: `This is a test!` on the command line after invocation.

## Redirection Operators

Setting to protect files from being overwritten using the `>` operator:

    unset -C

Provide input data:

    <<

Provide input data but strip tabs:

    <<-

Explicitly stating the Delimiter and quoting it, will prevent the shell from
processing the content:

    cat << 'E'OF
    This is a test: $XAUTHORITY: $XAUTHORITY
    EOF

will print the exact same text and not resolve the environment variable.

It is possible to change the I/O using `exec`:

    exec 2> /tmp/my.log #redirect standard error to /tmp/my.log
    exec 3> /some/file  #open new file descriptor 3
    read myinput <&3    #read from '3'

## exec

`exec` runs a program in the same process. `exec` can be used to start another
program with the same environment variables.

## printf

`printf` is mighty!


printf [FORMAT-STRING] "argument-string"

### printf escape sequences:

    \a  alert (bell)
    \b  backspace
    \c  no final newline; ignore arguments and format string (?)
    \f  formfeed
    \n  newline
    \r  carraige return
    \t  horizontal tab
    \v  vertical tab
    \\  literal backslash
    \ddd    character represented as 1-3 digital octal value (only in format
    string)
    \0ddd   character represented as a 1-3 digital octal value

### printf format specifiers

    %b  Apply escape sequences in the current string
    %c  Print first character of the corresponding argument
    %d,%i   Decimal integer
    %e  Floating-point format ([-]d.precisione[+-]dd).
    %E  Floating-point format ([-]d.precisionE[+-]dd).
    %f  Floating-point format ([-]ddd.precision).
    %g  %e or %f conversion depending which is shorter, strip trailing zeros
    %G  %E or %F conversion depending which is shorter, strip trailing zeros
    %o  Unsigned octal value
    %s  String
    %u  Unsigned decimal value
    %x  Usigned hexadecimal (a-f)
    %X  Usigned hexadecimal (A-F)
    %%  Literal %

### format expressions

A format specifier can take up to three modifiers that are placed between `%`
and the format specifying character (_width_ and _precision_):

    width - a numerical value (right-aligned per default)
    printf "|%20s|\n" hello

Output:

    |               hello|

    precision - a numerical value that controls the number of digits in the
    output

    printf "My salary is %.6d\n" 48000
Output:

    My salary is 048000

    printf "%.12s\n" "So let me tell you the story"
Output:
    
    so let me te

    printf "Keep only two digits after the point: $.2f" 3.1415926535
Output:

    Keep only two digits after the point: 3.14



