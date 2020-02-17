package ru.progmatik.main;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
public class FiasLoaderMainClass {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    public static void main(String[] args) {
        System.out.println(String.format("%.2f", 120.0));
        SpringApplication.run(FiasLoaderMainClass.class);
    }
}
