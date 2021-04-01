package com.agu.component.fileupload.config.properties;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;


import com.agu.common.utils.ToolUtil;

import lombok.Data;

/**
 * 项目-文件上传配置项
 * @author yuwenbo
 * @date 2021-03-31
 */
@Data
@Component
@ConfigurationProperties(prefix = "project.upload")
public class UploadProjectProperties {

    /** 上传文件路径 */
    private String filePath;

    /** 上传文件静态访问路径 */
    private String staticPath = "/upload/**";

    /** 获取文件路径 */
    public String getFilePath() {
        if (filePath == null) {
            return ToolUtil.getProjectPath() + "/upload/";
        }
        if (!filePath.endsWith("/")) {
            return filePath + "/";
        }
        return filePath;
    }
}
