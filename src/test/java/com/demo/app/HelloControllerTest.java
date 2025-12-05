package com.demo.app;

import org.junit.jupiter.api.Test;
import com.demo.app.controller.HelloController;


import static org.assertj.core.api.Assertions.assertThat;

public class HelloControllerTest {

    @Test
    void helloReturnsGreeting() {
        HelloController c = new HelloController();
        assertThat(c.hello().getBody()).isEqualTo("Hello from Springboot app");
    }
}
