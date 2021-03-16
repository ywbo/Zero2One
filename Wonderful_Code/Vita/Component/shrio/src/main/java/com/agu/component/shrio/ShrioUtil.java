package com.agu.component.shrio;

import com.agu.common.utils.EncryptUtil;
import com.agu.common.utils.SpringContextUtil;
import com.agu.module.system.domain.User;
import com.agu.module.system.service.IUserService;
import org.apache.shiro.SecurityUtils;
import org.hibernate.Hibernate;
import org.hibernate.LazyInitializationException;
import org.springframework.beans.BeanUtils;

/**
 * @ClassName ShrioUtil
 * @Description Shrio工具类
 * @Author yuwenbo
 * @Date 2021-03-15 23:51
 **/
public class ShrioUtil {
    /**
     * 加密算法
     */
    public final static String HASH_ALGORITHM_NAME = EncryptUtil.HASH_ALGORITHM_NAME;

    /**
     * 加密循环次数
     */
    public final static int HASH_ITERATIONS = EncryptUtil.HASH_ITERATIONS;

    /**
     * 加密处理（64位字符）
     * 【备注】采用自定义的密码加密方式，其原理与 SimpleHash 一致，
     *        为的就是在多个模块间可以使用同一套加密方式，方便共用系统用户。
     *
     * @param password
     * @param salt
     * @return
     */
    public static String encrypt(String password, String salt){
        return EncryptUtil.encrypt(password, salt, HASH_ALGORITHM_NAME, HASH_ITERATIONS);
    }

    /**
     * 获取随机加密盐值
     * @return
     */
    public static String encrypt(){
        return EncryptUtil.getRandomSalt();
    }

    /**
     * 获取当前用户对象
     * @return
     */
    public static User getSubject(){
        User user = (User) SecurityUtils.getSubject().getPrincipal();

        // 初始化延迟加载的部门信息
        if (user != null && !Hibernate.isInitialized(user.getDept())){
            try {
                Hibernate.initialize(user.getDept());
            } catch (LazyInitializationException e){
                // 部门数据延迟加载超时，重新查询用户数据（用于更新 ”记住我“ 状态登陆的数据）
                IUserService userService = SpringContextUtil.getBean(IUserService.class);
                User reload = userService.getById(user.getId());
                Hibernate.initialize(reload.getDept());
                // 将重载用户数据拷贝到登陆用户中
                BeanUtils.copyProperties(reload, user, "roles");
            }
        }
        return user;
    }
}
