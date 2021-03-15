package com.agu.common.config.properties;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

import lombok.Data;

/**
 * 项目配置项
 *
 * @author yuwenbo
 * @since 2021-03-15
 */
@Data
@Component
@ConfigurationProperties(prefix = "project")
public class ProjectProperties {
    /**
     * 是否开启验证码
     */
    private boolean captcheOpen = false;

    /**
     * 是否开启swagger数据接口文档
     */
    private boolean swaggerEnabled = true;

    /**
     * XXS 防护设置
     */
    private ProjectProperties.Xxs xxs = new ProjectProperties.Xxs();

    /**
     * xss防护设置
     */
    @Data
    public static class Xxs{
        /**
         * xss防护开关
         */
        private boolean enabled = true;

        /**
         * 拦截规则，可通过 “，”隔开多个
         */
        private String urlPatterns = "/*";

        /**
         * 默认忽略规则（无需修改）
         */
        private String defaultExcludes = "/favicon.ico,/img/*,/js/*,/css/*,/lib/*";

        /**
         * 忽略规则，可通过“,”隔开多个
         */
        private String excludes = "";

        /**
         * 拼接忽略规则
         */
        public String getExcludes(){
            if (!StringUtils.isEmpty(excludes.trim())){
                return defaultExcludes + "," + excludes;
            }
            return defaultExcludes;
        }
    }
}
