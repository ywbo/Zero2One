package com.agu.component.thymeleaf.utility;

import com.agu.common.utils.SpringContextUtil;
import com.agu.module.system.domain.Dict;
import com.agu.module.system.service.IDictService;
import net.sf.ehcache.Cache;
import net.sf.ehcache.Element;

import java.util.LinkedHashMap;
import java.util.Map;

/**
 * 功能介绍: 字典提取工具对象
 *
 * @Author yuwenbo
 * @Date 2021-04-01
 **/
public class DictUtil {

    private static Cache dictCache = EhCacheUtil.getDictCache();

    /**
     * 获取字典值集合
     * @param label 字典标识
     */
    @SuppressWarnings("unchecked")
    public static Map<String, String> value(String label){
        Map<String, String> value = null;
        Element dictEle = dictCache.get(label);
        if(dictEle != null){
            value = (Map<String, String>) dictEle.getObjectValue();
        }else {
            IDictService dictService = SpringContextUtil.getBean(IDictService.class);
            Dict dict = dictService.getByNameOk(label);
            if(dict != null){
                String dictValue = dict.getValue();
                String[] outerSplit = dictValue.split(",");
                value = new LinkedHashMap<>();
                for (String osp : outerSplit) {
                    String[] split = osp.split(":");
                    if(split.length > 1){
                        value.put(split[0], split[1]);
                    }
                }
                dictCache.put(new Element(dict.getName(), value));
            }
        }
        return value;
    }

    /**
     * 根据选项编码获取选项值
     * @param label 字典标识
     * @param code 选项编码
     */
    public static String keyValue(String label, String code){
        Map<String, String> list = DictUtil.value(label);
        if(list != null){
            return list.get(code);
        }else{
            return "";
        }
    }

    /**
     * 封装数据状态字典
     * @param status 状态
     */
    public static String dataStatus(Byte status){
        String label = "DATA_STATUS";
        return DictUtil.keyValue(label, String.valueOf(status));
    }

    /**
     * 清除缓存中指定的数据
     * @param label 字典标识
     */
    public static void clearCache(String label){
        Element dictEle = dictCache.get(label);
        if (dictEle != null){
            dictCache.remove(label);
        }
    }
}
