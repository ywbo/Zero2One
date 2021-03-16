package com.agu.module.system.service.impl;

import com.agu.common.enums.StatusEnum;
import com.agu.module.system.domain.Dept;
import com.agu.module.system.repository.DeptRepository;
import com.agu.module.system.repository.UserRepository;
import com.agu.module.system.service.IDeptService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Example;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @ClassName DeptServiceImpl
 * @Description TODO
 * @Author yuwenbo
 * @Date 2021-03-16 23:21
 **/
@Service
public class DeptServiceImpl implements IDeptService {

    @Autowired
    private DeptRepository deptRepository;

    @Autowired
    private UserRepository userRepository;

    @Override
    public List<Dept> getListByExample(Example<Dept> example, Sort sort) {
        return null;
    }

    @Override
    public Integer getSortMax(Long pid) {
        return null;
    }

    @Override
    public List<Dept> getListByPid(Long pid, Long notId) {
        return null;
    }

    @Override
    public List<Dept> save(List<Dept> deptList) {
        return null;
    }

    @Override
    public Dept getById(Long id) {
        return null;
    }

    @Override
    public List<Dept> getListByPidLikeOk(Long id) {
        return null;
    }

    @Override
    public Dept save(Dept dept) {
        return null;
    }

    @Override
    public Boolean updateStatus(StatusEnum statusEnum, List<Long> idList) {
        return null;
    }
}
