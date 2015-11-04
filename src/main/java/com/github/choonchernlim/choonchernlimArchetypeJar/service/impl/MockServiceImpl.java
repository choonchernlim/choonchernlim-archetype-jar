package com.github.choonchernlim.choonchernlimArchetypeJar.service.impl;

import com.github.choonchernlim.choonchernlimArchetypeJar.service.MockService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Service
public final class MockServiceImpl implements MockService {

    private final String testProperty;

    @Autowired
    public MockServiceImpl(@Value("${test.property}") final String testProperty) {
        this.testProperty = testProperty;
    }

    @Override
    public String getHelloWorld() {
        return testProperty;
    }
}
