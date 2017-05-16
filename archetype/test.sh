#!/usr/bin/env bash

export JAVA_HOME="`/usr/libexec/java_home -v '1.8*'`"

rm -rf /tmp/archetype/test

cd /tmp/archetype

mvn archetype:generate -DinteractiveMode=false \
-DarchetypeGroupId=com.github.choonchernlim -DarchetypeArtifactId=choonchernlim-archetype-jar -DarchetypeVersion=0.2.0 \
-DgroupId=org.project.test -DartifactId=test -Dversion=1.0.0-SNAPSHOT