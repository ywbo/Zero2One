package com.agu.module.system.service.impl;

import com.agu.common.enums.StatusEnum;
import com.agu.module.system.domain.Menu;
import com.agu.module.system.repository.MenuRepository;
import com.agu.module.system.service.IMenuService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Example;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 菜单相关功能接口实现
 *
 * @Author yuwenbo
 * @Date 2021-03-23
 **/
@Service
public class MenuServiceImpl implements IMenuService {

    @Autowired
    private MenuRepository menuRepository;

    @Override
    public List<Menu> getListByExample(Example<Menu> example, Sort sort) {
        return null;
    }

    @Override
    public Menu getByMenuToExample(Menu menu) {
        return null;
    }

    @Override
    public Menu getById(Long id) {
        return null;
    }

    @Override
    public Menu getByUrl(String url) {
        return null;
    }

    @Override
    public List<Menu> getListBySortOk() {
        return null;
    }

    @Override
    public Integer getSortMax(Long pid) {
        return null;
    }

    @Override
    public List<Menu> getListByPid(Long pid, Long notId) {
        return null;
    }

    @Override
    public Menu saveMenu(Menu menu) {
        return null;
    }

    @Override
    public Menu saveMenu(List<Menu> menuList) {
        return null;
    }

    @Override
    public Boolean updateStatus(StatusEnum statusEnum, List<Long> idList) {
        return null;
    }
}
