# choonchernlim-archetype-jar

This Maven archetype creates a jar-packaged project that plays nicely with Jenkins and Sonar. 

The following development stack is pre-configured:-

* [Spring](http://projects.spring.io/spring-framework/) - for dependency injection
* [Guava](https://github.com/google/guava) - utility API and for creating immutable collections 
* [Spock](https://github.com/spockframework/spock) - for writing Groovy test cases
* [Better Preconditions](https://github.com/choonchernlim/better-preconditions) - More fluent precondition API
* [Build Reports](https://github.com/choonchernlim/build-reports) - for configuring static code analysis reports for Jenkins and Sonar
* [Pojo Builder](https://github.com/mkarneim/pojobuilder) - for creating immutable objects

## Latest Release

```xml
<dependency>
  <groupId>com.github.choonchernlim</groupId>
  <artifactId>choonchernlim-archetype-jar</artifactId>
  <version>0.1.0</version>
</dependency>
```

For example:

```bash
mvn archetype:generate 
-DinteractiveMode=false 
-DarchetypeGroupId=com.github.choonchernlim 
-DarchetypeArtifactId=choonchernlim-archetype-jar 
-DarchetypeVersion=0.1.0
-DgroupId=com.github.choonchern.testProject 
-DartifactId=testProject 
-Dversion=1.0.0-SNAPSHOT
```

## Sample Project Structure

If the `groupId` is `com.github.choonchern.testProject` and the `artifactId` is `testProject`, the generated project structure looks like this:-

```text
➜  tree . -I '*.iml' 
├── CHANGELOG.md
├── README.md
├── pom.xml
└── src
    ├── main
    │   ├── java
    │   │   └── com
    │   │       └── github
    │   │           └── choonchernlim
    │   │               └── testProject
    │   │                   ├── main
    │   │                   │   └── Main.java
    │   │                   └── service
    │   │                       ├── MockService.java
    │   │                       └── impl
    │   │                           └── MockServiceImpl.java
    │   └── resources
    │       ├── log4j.xml
    │       ├── messages.properties
    │       └── spring-config.xml
    └── test
        ├── groovy
        │   └── com
        │       └── github
        │           └── choonchernlim
        │               └── testProject
        │                   └── service
        │                       └── impl
        │                           └── MockServiceImplSpec.groovy
        ├── java
        │   └── com
        │       └── github
        │           └── choonchernlim
        │               └── testProject
        │                   └── DummyTest.java
        └── resources
            └── spring-test.xml

25 directories, 12 files
```                    

## Prerequisites

* Maven version must be 3.2.5.
    * Maven 3.3.x requires Java 7.

## Usage

### Jenkins Integration

* Create a "Freestyle project" job. [Don't create a "Maven project" job if you are using Java 6](https://issues.jenkins-ci.org/browse/JENKINS-29004).

* Under "Add build steps, select "Invoke top-level Maven targets".
    * Goals: `clean test site`
    * POM: `[project]/pom.xml`

* Configure post-build actions accordingly.
