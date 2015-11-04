#!/usr/bin/env bash

#---------------------------------------------------------------------------
# build.sh
#
# Generates archetype from project, sanitize it, remove existing version
# from local repo, install it in local repo.
#---------------------------------------------------------------------------

set -e

# Must run script with Java 6 to prevent weird errors
export JAVA_HOME="`/usr/libexec/java_home -v '1.6*'`"

# Get archetype version from `archetype/archetype.properties`
ARCHETYPE_VERSION=`awk -F= '/^archetype.version/ { print $2 }' archetype/archetype.properties`

TMP_PATH="/tmp/archetype"

# Sanitized archetype copy
PROJECT_PATH="${TMP_PATH}/choonchernlim-archetype-jar"

ARCHETYPE_BASE_PATH="${PROJECT_PATH}/target/generated-sources/archetype"
ARCHETYPE_RESOURCES_PATH="$ARCHETYPE_BASE_PATH/src/main/resources/archetype-resources"

# ~/.m2 path for previously installed archetype
ARCHETYPE_LOCAL_REPO_PATH="$HOME/.m2/repository/com/github/choonchernlim/choonchernlim-archetype-jar/$ARCHETYPE_VERSION/"

# Asserts that the file path exists
# $1 = file path
assertFileExist() {
    local path=$1

    if [ ! -f ${path} ]
    then
        echo "CheckFileExistException: Path is not a file: ${path}"
        exit 1
    fi
}

# Asserts that the variable value is not blank.
# $1 = variable name
# $2 = value
assertNotBlank() {
    local varName=$1
    local value=$2

    if [ -z "${value}" ]
    then
        echo "CheckNotBlankException: ${varName} cannot be blank."
        exit 1
    fi
}

# Displays the count of given string pattern
# $1 = file path
# $2 = search string
countStringMatched() {
    local path=$1
    local searchString=$2
    local count=`grep -c "${searchString}" ${path}`

    echo "${count} : ${searchString}"
}


# Draws a line
display_line() {
    echo "------------------------------------------------------------"
}

# Replaces a string in a file.
# $1 = file path
# $2 = replacing this string...
# $3 = ... with this string
replace_string_in_file() {
    local path=$1
    local fromString=$2
    local toString=$3

    assertNotBlank 'path' "${path}"
    assertNotBlank 'fromString' "${fromString}"
    assertNotBlank 'toString' "${toString}"

    assertFileExist "${path}"

    display_line
    echo "File    : ${path}"
    echo "   From : ${fromString}"
    echo "   To   : ${toString}"
    echo " "
    echo "BEFORE:"

    countStringMatched "${path}" "${fromString}"
    countStringMatched "${path}" "${toString}"

    # Mac requires extension to be set, so an empty string is used.
    # Using | as delimiter instead of default / to prevent escaping special characters
    # http://backreference.org/2010/02/20/using-different-delimiters-in-sed/
    sed -i '' "s|${fromString}|${toString}|g" "${path}"

    echo " "
    echo "AFTER:"

    countStringMatched "${path}" "${fromString}"
    countStringMatched "${path}" "${toString}"

    echo " "
}

# Inserts the following Velocity's escape variables on top of the file:-
# - #set( $symbol_pound = '#' )
# - #set( $symbol_dollar = '$' )
# - #set( $symbol_escape = '\' )
insert_velocity_escape_variables_in_file() {
    local path=$1

    sed -i '' "1i\\
    #set( \$symbol_pound = '\#' )\\
    #set( \$symbol_dollar = '\$' )\\
    #set( \$symbol_escape = '\\\\' )\\
    " "${path}"
}

# Finds string occurence and prints them on console
# $1 = path
# $2 = expected count
# $3 = search string
find_string_occurence() {
    local path=$1
    local expectedCount=$2
    local searchString=$3

    display_line
    echo "Files that contain '${searchString}'. ( Should have ${expectedCount} ):-"
    find "${path}" -type f -exec grep -e "${searchString}" {} \; -print
}

# Remove all `target` dirs first, if any
mvn clean

# Recreate temp space
rm -rf ${TMP_PATH}
mkdir ${TMP_PATH}

# Move archetype/ dir to be sibling of choonchernlim-archetype-jar/ dir so that it won't get included
# into the archetype itself
rsync . ${TMP_PATH} -av \
--include="archetype/" \
--include="archetype.properties" \
--include="build.sh" \
--exclude="*" \

# Remove all unneeded files for the archetype. `archetype/` dir cannot be removed at this point because
# `mvn archetype:create-from-project` needs a property file that resides in it.
rsync . ${PROJECT_PATH} -av \
--exclude="*.iml" \
--exclude="LICENSE" \
--exclude="README.md" \
--exclude="CHANGELOG.md" \
--exclude=".git/" \
--exclude=".idea/" \
--exclude="archetype/"

echo '# Read Me' > ${PROJECT_PATH}/README.md
echo '# Change Log' > ${PROJECT_PATH}/CHANGELOG.md

# Change dir to the temp space
cd ${PROJECT_PATH}

# Create archetype from existing project.
echo "Creating Maven archetype from existing project..."
mvn clean archetype:create-from-project -Darchetype.properties=../archetype/archetype.properties
display_line

# Pluck out `<parent>...</parent>` from `pom.xml` and replace all line breaks with blank string to prevent `sed`
# from throwing "unescaped newline inside substitute pattern" error. Then, use xmllint to reformat the file back.
echo "Adding parent pom to archetype pom..."
PARENT_POM=`awk '/<parent>/,/<\/parent>/' pom.xml | tr '\n' ' '`
sed -i '' "s|</modelVersion>|</modelVersion> ${PARENT_POM}|g" "$ARCHETYPE_BASE_PATH/pom.xml"
export XMLLINT_INDENT="    "
xmllint --output "$ARCHETYPE_BASE_PATH/pom.xml" --format "$ARCHETYPE_BASE_PATH/pom.xml"

currentPath="${ARCHETYPE_RESOURCES_PATH}/pom.xml"
replace_string_in_file "${currentPath}" '#' '$symbol_pound'
replace_string_in_file "${currentPath}" 'com.github.choonchernlim.choonchernlimArchetypeJar' '${package}'
insert_velocity_escape_variables_in_file "${currentPath}"

find_string_occurence "${ARCHETYPE_RESOURCES_PATH}" 1 '\${version}'
find_string_occurence "${ARCHETYPE_RESOURCES_PATH}" 0 'choonchernlim-archetype-jar'
find_string_occurence "${ARCHETYPE_RESOURCES_PATH}" 0 'archetypes'
find_string_occurence "${ARCHETYPE_RESOURCES_PATH}" 0 'com.github.choonchernlim.choonchernlimArchetypeJar'
find_string_occurence "${ARCHETYPE_RESOURCES_PATH}" 0 'choonchernlimArchetypeJar'
display_line

echo "Remove existing archetype from local repository..."
rm -rf "$ARCHETYPE_LOCAL_REPO_PATH"
display_line

echo "Installing new archetype in local repository..."
(cd target/generated-sources/archetype; mvn clean install)

display_line
echo 'Done'