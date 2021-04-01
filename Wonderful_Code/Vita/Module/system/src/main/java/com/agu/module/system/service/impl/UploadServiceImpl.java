package com.agu.module.system.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.agu.module.system.domain.Upload;
import com.agu.module.system.repository.UploadRepository;
import com.agu.module.system.service.IUploadService;


/**
 * @author yuwenbo
 * @date 2021-04-01
 */
@Service
public class UploadServiceImpl implements IUploadService {

    @Autowired
    private UploadRepository uploadRepository;

    /**
     * 获取文件sha1值的记录
     */
    @Override
    public Upload getBySha1(String sha1) {
        return uploadRepository.findBySha1(sha1);
    }

    /**
     * 保存文件上传
     * @param upload 文件上传实体类
     */
    @Override
    public Upload save(Upload upload){
        return uploadRepository.save(upload);
    }
}
