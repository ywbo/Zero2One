package com.agu.module.system.service.impl;

import com.agu.common.data.PageSort;
import com.agu.module.system.domain.ActionLog;
import com.agu.module.system.repository.ActionLogRepository;
import com.agu.module.system.service.IActionLogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Example;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.util.List;

/**
 * 功能介绍: 日志相关操作
 *
 * @Author yuwenbo
 * @Date 2021-03-30
 **/
@Service
public class ActionLogServiceImpl implements IActionLogService {

    @Autowired
    private ActionLogRepository actionLogRepository;

    @Override
    public Page<ActionLog> getPageList(Example<ActionLog> example) {
        // 创建分页对象
        PageRequest page = PageSort.pageRequest();
        actionLogRepository.findAll(example, page);
        return null;
    }

    @Override
    public ActionLog getById(Long id) {
        return actionLogRepository.findById(id).orElse(null);
    }

    @Override
    public List<ActionLog> getDataLogList(String model, Long recordId) {
        return actionLogRepository.findByModelAndRecordId(model, recordId);
    }

    @Override
    public ActionLog save(ActionLog actionLog) {
        return actionLogRepository.save(actionLog);
    }

    @Override
    public void deleteId(Long id) {
        actionLogRepository.deleteById(id);
    }

    @Override
    @Transactional
    public void clearLog() {
        actionLogRepository.deleteAll();
    }
}
