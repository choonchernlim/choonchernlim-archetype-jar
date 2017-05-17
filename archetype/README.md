## Update archetype version 

Go to `archetype/pom.xml`, and change this line:-

    <version>X.X.X</version>

Go to `archetype/archetype-test.sh`, and change this line:-

    -DarchetypeVersion=X.X.X

## Run Build Script

In Terminal, navigate to `choonchernlim-archetype-jar` directory:-

    cd choonchernlim-archetype-jar

If the script is not executable, run this:-

    chmod 0755 ./archetype/archetype-build.sh

Execute shell script.

    ./archetype/archetype-build.sh 

## Update CHANGELOG.md

* Create an entry before release.

## Update README.md

* Update version in `Latest Release`.

## Installing Archetype

Push to Nexus
    
    cd /tmp/archetype/choonchernlim-archetype-jar/target/generated-sources/archetype
    mvn clean deploy -Possrh -Possrh-deploy

