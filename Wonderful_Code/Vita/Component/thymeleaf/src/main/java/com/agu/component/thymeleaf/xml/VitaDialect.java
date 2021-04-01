package com.agu.component.thymeleaf.xml;

import com.agu.component.thymeleaf.attribute.SelectDictAttrProcessor;
import com.agu.component.thymeleaf.attribute.SelectListAttrProcessor;
import org.thymeleaf.dialect.AbstractProcessorDialect;
import org.thymeleaf.dialect.IExpressionObjectDialect;
import org.thymeleaf.expression.IExpressionObjectFactory;
import org.thymeleaf.processor.IProcessor;
import org.thymeleaf.standard.StandardDialect;
import org.thymeleaf.templatemode.TemplateMode;

import java.util.LinkedHashSet;
import java.util.Set;

/**
 * 功能介绍
 *
 * @Author yuwenbo
 * @Date 2021-04-01
 **/
public class VitaDialect extends AbstractProcessorDialect implements IExpressionObjectDialect {
    private static final String NAME = "TimoDialect";
    private static final String PREFIX = "mo";
    private IExpressionObjectFactory expressionObjectFactory = null;

    public VitaDialect() {
        super(NAME, PREFIX, StandardDialect.PROCESSOR_PRECEDENCE);
    }

    @Override
    public Set<IProcessor> getProcessors(String dialectPrefix) {
        Set<IProcessor> processors = new LinkedHashSet<IProcessor>();
        processors.add(new SelectDictAttrProcessor(TemplateMode.HTML, dialectPrefix));
        processors.add(new SelectListAttrProcessor(TemplateMode.HTML, dialectPrefix));
        return processors;
    }

    @Override
    public IExpressionObjectFactory getExpressionObjectFactory() {
        if (this.expressionObjectFactory == null) {
            this.expressionObjectFactory = new VitaExpressionObjectFactory();
        }
        return this.expressionObjectFactory;
    }
}
