# choonchernlim-archetype-jar

Groovy-based JAR archetype with Spring Boot and CI integration.

## Latest Release

```xml
<dependency>
  <groupId>com.github.choonchernlim</groupId>
  <artifactId>choonchernlim-archetype-jar</artifactId>
  <version>0.2.0</version>
</dependency>
```

For example:

```bash
mvn archetype:generate 
-DinteractiveMode=false 
-DarchetypeGroupId=com.github.choonchernlim 
-DarchetypeArtifactId=choonchernlim-archetype-jar 
-DarchetypeVersion=0.2.0
-DgroupId=com.github.choonchernlim.testProject 
-DartifactId=testProject 
-Dversion=1.0.0-SNAPSHOT
```

## Sample Project Structure

If `groupId` is `com.github.choonchernlim.testProject` and `artifactId` is `testProject`, the generated project structure looks like this:-

```text
➜  tree . 
.
├── CHANGELOG.md
├── README.md
├── pom.xml
└── src
    ├── main
    │   ├── groovy
    │   │   └── com
    │   │       └── github
    │   │           └── choonchernlim
    │   │               └── testProject
    │   │                   ├── Application.groovy
    │   │                   └── service
    │   │                       └── HelloWorldService.groovy
    │   └── resources
    │       └── application.yml
    └── test
        ├── groovy
        │   └── com
        │       └── github
        │           └── choonchernlim
        │               └── testProject
        │                   └── service
        │                       └── HelloWorldServiceSpec.groovy
        └── resources
            ├── application.yml
            └── logback-test.xml

17 directories, 9 files
```                    

## Prerequisites

* Java 1.8.
* Maven 3.3.9.

## Usage

### Jenkins Integration

* Create a "Freestyle project" job.

* Under "Add build steps, select "Invoke top-level Maven targets".
    * Goals: `clean test site`
    * POM: `[project]/pom.xml`

* Configure post-build actions accordingly.
