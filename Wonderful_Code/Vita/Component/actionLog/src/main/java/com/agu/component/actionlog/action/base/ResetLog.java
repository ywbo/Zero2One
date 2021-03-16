package com.agu.component.actionlog.action.base;

import com.agu.common.enums.ResultEnum;
import com.agu.common.utils.EntityBeanUtil;
import com.agu.common.vo.ResultVo;
import com.agu.component.actionlog.annotation.ActionLog;
import com.agu.component.actionlog.annotation.EntityParam;
import com.agu.component.shrio.ShrioUtil;
import lombok.Data;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.reflect.MethodSignature;
import org.omg.CORBA.OBJ_ADAPTER;

import javax.jws.Oneway;
import java.lang.annotation.Annotation;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * @ClassName ResetLog
 * @Description 自定义日志数据
 * @Author yuwenbo
 * @Date 2021-03-15 22:01
 **/
@Data
public class ResetLog {
    /**
     * 封装操作对象
     */

    /* 注解日志的方法返回值 */
    private Object returnValue;

    /* 获取日志实体对象 */
    private ActionLog actionLog;

    /* AOP连接点信息对象 */
    private JoinPoint joinPoint;

    /* 是否记录日志（默认记录） */
    private Boolean record = true;



    /**
     * 辅助方法
     */
    /**
     * 判断返回值是否为 ResultVo 对象
     * @return
     */
    public boolean isResultVo(){
        return returnValue instanceof ResultVo;
    }

    /**
     * 判断 ResultVo 状态码是否成功
     * @return
     */
    public boolean isSuccess(){
        return returnValue instanceof ResultVo && ((ResultVo) returnValue).getCode().equals(ResultEnum.SUCCESS.getCode());
    }

    /**
     * 获取切入点方法指定的参数名
     * @param name
     * @return
     */
    public Object getParam(String name){
        Object[] args = joinPoint.getArgs();
        if (args.length > 0){
            MethodSignature methodSignature = (MethodSignature) joinPoint.getSignature();
            String[] parameterNames = methodSignature.getParameterNames();
            for (int i = 0; i < parameterNames.length; i++){
                if (parameterNames[i].endsWith(name)){
                    return args[i];
                }
            }
        }
        return null;
    }

    /**
     * 获取切入点参数注解 @EntityParam 的对象
     * @return
     */
    public Object getEntityParam(){
        Object[] args = joinPoint.getArgs();
        if (args.length > 0){
            MethodSignature signature = (MethodSignature) joinPoint.getSignature();
            Method method = signature.getMethod();
            Annotation[][] parameterAnnotation = method.getParameterAnnotations();
            for (int i = 0; i < parameterAnnotation.length; i++){
                for (int j = 0; j < parameterAnnotation.length; j++)
                if (parameterAnnotation[i][j] instanceof EntityParam){
                    return args[i];
                }
            }
        }
        return null;
    }

    private static final Pattern FILL_PATTERN = Pattern.compile("\\$\\{[a-zA-Z0-9]+\\}");

    /**
     * 内容填充规则
     * @param beanObject
     * @param content
     * @return
     */
    public String fillRule(Object beanObject, String content){
        Matcher matcher = FILL_PATTERN.matcher(content);
        while (matcher.find()){
            String matchWord = matcher.group();
            String property = matchWord
                    .substring(2, matchWord.length()-1);
            String fill = null;
            try {
                fill = String.valueOf(EntityBeanUtil.getField(beanObject, property));
            } catch (InvocationTargetException | IllegalAccessException e){
            } finally {
                content = content.replace(matchWord, fill);
            }
        }
        return content;
    }


    /* 快捷数据 */
    /**
     * 获取用户名
     */
    public String getUsername(){
        return ShrioUtil.getSubject().getUsername();
    }
    /**
     * 获取用户昵称
     */
    public String getNickname(){
        return ShrioUtil.getSubject().getNickname();
    }
    /**
     * 获取当前时间
     */
    public String getDatetime(){
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        return df.format(new Date());
    }
    /**
     * 获取当前时间（自定义时间格式）
     */
    public String getDatetime(String pattern){
        SimpleDateFormat df = new SimpleDateFormat(pattern);
        return df.format(new Date());
    }
}
