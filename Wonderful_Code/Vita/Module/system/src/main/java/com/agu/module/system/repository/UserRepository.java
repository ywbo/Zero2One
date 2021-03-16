package com.agu.module.system.repository;

import com.agu.module.system.domain.Dept;
import com.agu.module.system.domain.User;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

import java.util.List;

/**
 * @ClassName UserRepository
 * @Description TODO
 * @Author yuwenbo
 * Date 2021-03-16 23:10
 **/
public interface UserRepository extends BaseRepository<User, Long>, JpaSpecificationExecutor<User> {

    /**
     * 根据用户名查询用户数据
     * @param username 用户名
     * @return 用户数据
     */
    public User findByUsername(String username);

    /**
     * 根据用户名查询用户数据,且排查指定ID的用户
     * @param username 用户名
     * @param id 排除的用户id
     * @return 用户数据
     */
    public User findByUsernameAndIdNot(String username, Long id);

    /**
     * 查找多个相应部门的数据列表
     * @param dept 部门实体类
     * @return 用户数据
     */
    public List<User> findByDept(Dept dept);

    /**
     * 删除多条数据
     * @param ids id列表
     * @return 影响数据
     */
    public Integer deleteByIdIn(List<Long> ids);

}
