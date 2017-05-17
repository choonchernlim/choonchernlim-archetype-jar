#!/bin/bash

#---------------------------------------------------------------------------
# archetype-build.sh
#
# Generates archetype from project, sanitize it, remove existing version
# from local repo, install it in local repo.
#
# NOTE: Run script from `choonchernlim-archetype-jar` dir... not from
#       `archetype` dir.
#---------------------------------------------------------------------------

set -e

# Include common functions
source archetype/archetype-functions.sh

# Use Java 1.8
export JAVA_HOME="`/usr/libexec/java_home -v '1.8*'`"

# Get archetype version from `archetype/archetype.properties`
ARCHETYPE_VERSION=`awk -F= '/^archetype.version/ { print $2 }' archetype/archetype.properties`

TMP_PATH="/tmp/archetype"

# Sanitized archetype copy
PROJECT_PATH="${TMP_PATH}/choonchernlim-archetype-jar"

ARCHETYPE_BASE_PATH="${PROJECT_PATH}/target/generated-sources/archetype"
ARCHETYPE_RESOURCES_PATH="$ARCHETYPE_BASE_PATH/src/main/resources/archetype-resources"

# ~/.m2 path for previously installed archetype
ARCHETYPE_LOCAL_REPO_PATH="$HOME/.m2/repository/com/github/choonchernlim/choonchernlim-archetype-jar/$ARCHETYPE_VERSION/"

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
--exclude="archetype/" \
--exclude=".DS_Store"

echo '# Read Me' > ${PROJECT_PATH}/README.md
echo '# Change Log' > ${PROJECT_PATH}/CHANGELOG.md

# Change dir to the temp space
cd ${PROJECT_PATH}

# Create archetype from existing project.
echo "Creating Maven archetype from existing project..."
mvn clean archetype:create-from-project -Darchetype.properties=../archetype/archetype.properties
display_line

currentPath="${ARCHETYPE_RESOURCES_PATH}/pom.xml"
insert_velocity_escape_variables_in_file "${currentPath}"

assert_string_occurrence "${ARCHETYPE_RESOURCES_PATH}" 1 '\${version}'
assert_string_occurrence "${ARCHETYPE_RESOURCES_PATH}" 0 'choonchernlim-archetype-jar'
assert_string_occurrence "${ARCHETYPE_RESOURCES_PATH}" 0 'archetypes'
assert_string_occurrence "${ARCHETYPE_RESOURCES_PATH}" 0 'com.github.choonchernlim.choonchernlimArchetypeJar'
assert_string_occurrence "${ARCHETYPE_RESOURCES_PATH}" 0 'choonchernlimArchetypeJar'
display_line

echo "Remove existing archetype from local repository..."
rm -rf "$ARCHETYPE_LOCAL_REPO_PATH"
display_line

echo "Installing new archetype in local repository..."
(cd target/generated-sources/archetype; mvn clean install)

display_line
echo 'Done'