package com.agu.module.system.service;


import com.agu.module.system.domain.Upload;

/**
 * @author yuwenbo
 * @date 2021-04-01
 */
public interface IUploadService {

    /**
     * 获取文件sha1值的记录
     * @param sha1 文件sha1值
     * @return 文件信息
     */
    Upload getBySha1(String sha1);

    /**
     * 保存文件上传
     * @param upload 文件上传实体类
     * @return 文件信息
     */
    Upload save(Upload upload);
}
