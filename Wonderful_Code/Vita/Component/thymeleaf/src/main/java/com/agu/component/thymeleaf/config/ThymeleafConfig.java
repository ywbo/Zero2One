package com.agu.component.thymeleaf.config;

import at.pollux.thymeleaf.shiro.dialect.ShiroDialect;
import com.agu.component.thymeleaf.xml.VitaDialect;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * @author yuwenbo
 * @date 2021-04-01
 */
@Configuration
public class ThymeleafConfig {

    /**
     * 配置自定义的CusDialect，用于整合thymeleaf模板
     */
    @Bean
    public VitaDialect getTimoDialect() {
        return new VitaDialect();
    }

    /**
     * 配置shiro扩展标签，用于控制权限按钮的显示
     */
    @Bean
    public ShiroDialect shiroDialect(){
        return new ShiroDialect();
    }
}
