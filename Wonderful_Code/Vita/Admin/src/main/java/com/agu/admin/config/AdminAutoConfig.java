package com.agu.admin.config;

import org.springframework.boot.autoconfigure.domain.EntityScan;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

/**
 * 功能介绍: Spring自动扫描
 *
 * @Author yuwenbo
 * @Date 2021-03-30
 **/
@ComponentScan(basePackages = "com.agu.admin")
@EnableJpaRepositories(basePackages = "com.agu.admin")
@EntityScan(basePackages = "com.agu.admin")
public class AdminAutoConfig {
}
