package com.agu.module.system.domain;

import java.io.Serializable;
import java.util.Date;
import java.util.HashSet;
import java.util.Set;

import javax.persistence.Entity;
import javax.persistence.EntityListeners;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import com.agu.common.enums.StatusEnum;
import com.agu.common.utils.StatusUtil;
import org.hibernate.annotations.SQLDelete;
import org.hibernate.annotations.Where;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import com.fasterxml.jackson.annotation.JsonIgnore;

import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;

/**
 * 用户实体类
 *
 * @author yuwenbo
 * @since 2021-03-15
 */
@Data
@Entity
@Table(name = "sys_user")
@ToString(exclude = {"dept", "roles"})
@EqualsAndHashCode(exclude = {"dept", "roles"})
@EntityListeners(AuditingEntityListener.class)
@SQLDelete(sql = "update sys_user" + StatusUtil.SLICE_DELETE)
@Where(clause = StatusUtil.NOT_DELETE)
@Excel("用户数据")
public class User implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Excel(value = "用户ID", type = ExcelType.EXPORT)
    private Long id;
    @Excel("用户名")
    private String username;
    @JsonIgnore
    private String password;
    @JsonIgnore
    private String salt;
    @Excel("昵称")
    private String nickname;
    private String picture;
    @Excel(value = "性别", dict = "USER_SEX")
    private Byte sex;
    @Excel("手机号码")
    private String phone;
    @Excel("电子邮箱")
    private String email;
    @CreatedDate
    @Excel("创建时间")
    private Date createDate;
    @LastModifiedDate
    @Excel("更新时间")
    private Date updateDate;
    @Excel("备注")
    private String remark;
    @Excel(value = "状态", dict = "DATA_STATUS")
    private Byte status = StatusEnum.OK.getCode();

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "dept_id")
    @JsonIgnore
    private Dept dept;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "sys_user_role",
            joinColumns = @JoinColumn(name = "user_id"),
            inverseJoinColumns = @JoinColumn(name = "role_id"))
    @JsonIgnore
    private Set<Role> roles = new HashSet<>(0);
