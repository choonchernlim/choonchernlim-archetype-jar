package com.github.choonchernlim.choonchernlimArchetypeJar.main;

import com.github.choonchernlim.choonchernlimArchetypeJar.service.MockService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;


public final class Main {

    private static final Logger LOGGER = LoggerFactory.getLogger(Main.class);

    public static void main(final String[] args) {
        ApplicationContext context = new ClassPathXmlApplicationContext("spring-config.xml");
        MockService mockService = context.getBean(MockService.class);

        LOGGER.info(mockService.getHelloWorld());
    }
}
