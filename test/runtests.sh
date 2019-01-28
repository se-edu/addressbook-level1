#!/usr/bin/env bash

# change to script directory
cd "${0%/*}"

# create ../bin directory if not exists
if [ ! -d "../bin" ]
then
    mkdir ../bin
fi

# compile the code into the bin folder, terminates if error occurred
if ! javac  ../src/seedu/addressbook/AddressBook.java -d ../bin
then
    echo "********** BUILD FAILURE **********"
    exit 1
fi

# (invalid) no parent directory, invalid filename with no extension
java -classpath ../bin seedu.addressbook.AddressBook ' ' < /dev/null > ACTUAL.TXT
# (invalid) invalid parent directory that does not exist, valid filename
java -classpath ../bin seedu.addressbook.AddressBook 'directoryThatDoesNotExist/valid.filename' < /dev/null >> ACTUAL.TXT
# (invalid) no parent directory, invalid filename with dot on first character
java -classpath ../bin seedu.addressbook.AddressBook '.noFilename' < /dev/null >> ACTUAL.TXT
# (invalid) valid parent directory, non regular file
mkdir -p data/notRegularFile.txt
java -classpath ../bin seedu.addressbook.AddressBook 'data/notRegularFile.txt' < /dev/null >> ACTUAL.TXT
# (valid) valid parent directory, valid filename with extension.
touch data/valid.filename
java -classpath ../bin seedu.addressbook.AddressBook 'data/valid.filename' < exitinput.txt >> ACTUAL.TXT
# run the program, feed commands from input.txt file and redirect the output to the ACTUAL.TXT
java -classpath ../bin seedu.addressbook.AddressBook < input.txt >> ACTUAL.TXT

# compare the output to the expected output
diff ACTUAL.TXT EXPECTED.TXT
if [ $? -eq 0 ]
then
    echo "Test result: PASSED"
else
    echo "Test result: FAILED"
fi
