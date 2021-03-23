package com.agu.module.system.service;

import com.agu.common.enums.StatusEnum;
import com.agu.module.system.domain.Menu;
import org.springframework.data.domain.Example;
import org.springframework.data.domain.Sort;

import javax.transaction.Transactional;
import java.util.List;

/**
 * 菜单相关功能接口
 *
 * @Author yuwenbo
 * Date 2021-03-23
 **/
public interface IMenuService {

    /**
     * 根据实例获取菜单数据
     * @param example 查询实体
     * @param sort 排序对象
     * @return 菜单列表
     */
    List<Menu> getListByExample(Example<Menu> example, Sort sort);

    /**
     * 根据菜单对象的 Example 判断是否存在
     * @param menu 菜单对象
     * @return 菜单信息
     */
    Menu getByMenuToExample(Menu menu);

    /**
     * 根据菜单 ID 查询菜单数据
     * @param id 菜单id
     * @return 菜单信息
     */
    Menu getById(Long id);

    /**
     * 根据菜单的 url 查询菜单数据
     * @param url 菜单url
     * @return 菜单数据
      */
    Menu getByUrl(String url);

    /**
     * 获取菜单列表数据
     * @return 菜单列表
     */
    List<Menu> getListBySortOk();

    /**
     * 获取排序最大值
     * @param pid 父菜单id
     * @return 最大值
     */
    Integer getSortMax(Long pid);

    /**
     * 根据父级菜单id获取本级全部菜单
     * @param pid 父菜单id
     * @param notId 需要排除的菜单id
     * @return 菜单列表
     */
    List<Menu> getListByPid(Long pid, Long notId);

    /**
     * 保存菜单
     * @param menu 菜单实体
     * @return 菜单信息
     */
    Menu saveMenu(Menu menu);

    /**
     * 保存多个菜单
     * @param menuList 菜单实体类列表
     * @return 菜单列表
     */
    Menu saveMenu(List<Menu> menuList);

    /**
     * 状态（启用、冻结、删除）/批量状态处理
     * @param statusEnum 数据状态
     * @param idList 数据id列表
     * @return 操作结果
     */
    @Transactional
    Boolean updateStatus(StatusEnum statusEnum, List<Long> idList);
}
