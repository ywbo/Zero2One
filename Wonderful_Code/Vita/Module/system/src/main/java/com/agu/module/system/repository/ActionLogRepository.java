package com.agu.module.system.repository;

import com.agu.module.system.domain.ActionLog;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

/**
 * 功能介绍
 *
 * @Author yuwenbo
 * Date 2021-03-30
 **/
public interface ActionLogRepository extends JpaRepository<ActionLog, Long> {

    /**
     * 根据模型和数据ID查询日志列表
     * @param model 模型（表名）
     * @param recordId 数据ID
     * @return 日志列表
     */
    public List<ActionLog> findByModelAndRecordId(String model, Long recordId);
}
