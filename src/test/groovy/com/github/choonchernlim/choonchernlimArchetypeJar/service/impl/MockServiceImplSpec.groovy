package com.github.choonchernlim.choonchernlimArchetypeJar.service.impl

import com.github.choonchernlim.choonchernlimArchetypeJar.service.MockService
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.test.context.ContextConfiguration
import spock.lang.Specification

@ContextConfiguration(["classpath*:spring-test.xml"])
class MockServiceImplSpec extends Specification {

    @Autowired
    MockService mockService

    def "getHelloWorld"() {
        expect:
        'Hello World' == mockService.getHelloWorld()
    }
}
