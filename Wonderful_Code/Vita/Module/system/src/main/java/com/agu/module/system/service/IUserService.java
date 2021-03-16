package com.agu.module.system.service;

import com.agu.common.enums.StatusEnum;
import com.agu.module.system.domain.User;
import org.springframework.data.domain.Page;

import javax.transaction.Transactional;
import java.util.List;

/**
 * @ClassName IUserService
 * @Description 用户接口类
 * @Author yuwenbo
 * Date 2021-03-16 22:54
 **/
public interface IUserService {
    /**
     * 获取分页列表数据
     * @param user 用户实体类
     * @return 返回分页数据
     */
    Page<User> getPageList(User user);

    /**
     * 保存用户
     * @param user 用户实体类
     * @return 用户信息
     */
    User save(User user);

    /**
     * 保存用户列表
     * @param userList 用户实体类
     * @return 用户列表
     */
    List<User> save(List<User> userList);

    /**
     * 根据用户名查询用户数据
     * @param username
     * @return
     */
    User getByName(String username);

    /**
     * 用户名是否重复
     * @param user 用户实体类
     * @return 用户数据
     */
    Boolean repeatByUserName(User user);

    /**
     * 根据用户id查询用户数据
     * @param id 用户id
     * @return 用户数据
     */
    User getById(Long id);

    /**
     * 状态(启用，冻结，删除)/批量状态处理
     * @param statusEnum 数据状态
     * @param idList 数据ID列表
     * @return 操作结果
     */
    @Transactional
    Boolean updateStatus(StatusEnum statusEnum, List<Long> idList);

}
