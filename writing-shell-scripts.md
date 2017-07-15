# Snippits to write shell scripts

check if a file `$FILENAME` exists and is writable:
    
    if [ -w $FILENAME]; then
        echo $FILENAME "exists and is writable"
    else
        echo $FILENAME "does not exist or is not writable"
        return 1
    fi

carefull, `exit 1` will close the shell wheareas `return 1` will keep the shell
open

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
