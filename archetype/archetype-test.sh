#!/usr/bin/env bash

echo "Using Java 1.8..."
export JAVA_HOME="`/usr/libexec/java_home -v '1.8*'`"

echo "Removing /tmp/archetype/testProject..."
rm -rf /tmp/archetype/testProject

echo "Navigating to /tmp/archetype..."
cd /tmp/archetype

echo "Generating project from archetype..."
mvn archetype:generate -DinteractiveMode=false -DarchetypeCatalog=local \
-DarchetypeGroupId=com.github.choonchernlim -DarchetypeArtifactId=choonchernlim-archetype-jar -DarchetypeVersion=0.2.0 \
-DgroupId=com.github.choonchernlim.testProject -DartifactId=testProject -Dversion=1.0.0-SNAPSHOT
