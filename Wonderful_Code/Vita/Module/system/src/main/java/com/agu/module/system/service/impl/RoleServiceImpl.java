package com.agu.module.system.service.impl;

import java.util.List;
import java.util.Set;

import com.agu.common.enums.StatusEnum;
import com.agu.module.system.domain.Role;
import org.springframework.data.domain.Example;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Sort;

import com.agu.module.system.service.IRoleService;

/**
 * 角色接口实现类
 *
 * @author yuwenbo
 * @since 2021-03-15
 */
public class RoleServiceImpl implements IRoleService {

    @Override
    public Set<Role> getUserOkRoleList(Long id) {
        return null;
    }

    @Override
    public Boolean existsUserOk(Long id) {
        return null;
    }

    @Override
    public Role getById(Long id) {
        return null;
    }

    @Override
    public Page<Role> getPageList(Example<Role> example) {
        return null;
    }

    @Override
    public List<Role> getListBySortOk(Sort sort) {
        return null;
    }

    @Override
    public boolean repeatByName(Role role) {
        return false;
    }

    @Override
    public Role save(Role role) {
        return null;
    }

    @Override
    public Boolean updateStatus(StatusEnum statusEnum, List<Long> idList) {
        return null;
    }
}
