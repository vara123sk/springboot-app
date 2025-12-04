package com.example.app;

import com.example.app.controller.HelloController;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThat;

public class HelloControllerTest {

    @Test
    void helloReturnsGreeting() {
        HelloController c = new HelloController();
        assertThat(c.hello().getBody()).isEqualTo("Hello from sample app");
    }
}
