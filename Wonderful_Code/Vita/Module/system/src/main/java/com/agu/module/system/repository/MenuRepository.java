package com.agu.module.system.repository;

import com.agu.module.system.domain.Menu;

import java.util.List;

/**
 * 菜单信息数据操作
 *
 * @Author yuwenbo
 * @Date 2021-03-23
 **/
public interface MenuRepository extends BaseRepository<Menu, Long> {

    /**
     * 查找多个菜单
     * @param ids id列表
     * @return 菜单列表
     */
    public List<Menu> findByIdIn(List<Long> ids);




}
