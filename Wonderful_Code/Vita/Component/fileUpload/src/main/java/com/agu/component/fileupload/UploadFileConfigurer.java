package com.agu.component.fileupload.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import com.agu.common.utils.SpringContextUtil;
import com.agu.component.fileupload.FileUpload;
import com.agu.component.fileupload.config.properties.UploadProjectProperties;


/**
 * @author yuwenbo
 * @date 2021-03-31
 */
@Configuration
public class UploadFileConfigurer implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        UploadProjectProperties properties = SpringContextUtil.getBean(UploadProjectProperties.class);
        registry.addResourceHandler(properties.getStaticPath()).addResourceLocations("file:" + FileUpload.getUploadPath());
    }
}
