package com.agu.module.system.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.agu.module.system.domain.Upload;


/**
 * @author yuwenbo
 * @date 2021-04-01
 */
public interface UploadRepository extends JpaRepository<Upload, Long> {

    /**
     * 查找指定文件sha1记录
     * @param sha1 文件sha1值
     * @return 文件信息
     */
    public Upload findBySha1(String sha1);
}

