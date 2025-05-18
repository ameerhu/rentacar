package com.etekhno.rentacar.common.exceptions;

import com.etekhno.rentacar.common.exceptions.superClasses.CustomError;
import com.etekhno.rentacar.common.exceptions.superClasses.CustomException;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.config.BeanDefinition;
import org.springframework.context.annotation.ClassPathScanningCandidateComponentProvider;
import org.springframework.core.type.filter.AssignableTypeFilter;

import java.lang.reflect.Field;
import java.util.*;
import java.util.stream.Collectors;

public class ExceptionErrorCodeTest {

    public static List<Class<?>> getAllSubClasses(Class<?> clazz, String basePackageToScan) throws ClassNotFoundException{
        ClassPathScanningCandidateComponentProvider provider=new ClassPathScanningCandidateComponentProvider(false);
        provider.addIncludeFilter(new AssignableTypeFilter(clazz));

        List <Class<?>> classes=new ArrayList<>();
        Set<BeanDefinition> components=provider.findCandidateComponents(basePackageToScan);
        for(BeanDefinition component : components){
            Class<?> cls=Class.forName(component.getBeanClassName());
            classes.add(cls);
        }
        return classes;
    }

    @Test
    public void testExceptionEnumCodeShouldNotDuplicate() throws ClassNotFoundException{
        Class<?> clazz= CustomException.class;
        Set<String> duplicate = null;
        String basePackageToScan="com.etekhno.resume.common.exceptions";
        System.out.println(clazz.getName());
        List<Class<?>> subClasses= getAllSubClasses(clazz,basePackageToScan);
        for(Class<?> subClazz:subClasses) {
            if (subClazz.getDeclaredClasses() != null)
                if (subClazz.getDeclaredClasses()[0].isEnum()) {
                    Object[] enums = subClazz.getDeclaredClasses()[0].getEnumConstants();
                    List<String> errorCodes = Arrays.stream(enums).map(e -> ((CustomError) e).getErrorCode()).collect(Collectors.toList());
                    duplicate = errorCodes.stream()
                            .filter(e -> Collections.frequency(errorCodes, e) > 1)
                            .collect(Collectors.toSet());
                }
            Assertions.assertEquals(0, duplicate.size(), "Error code duplicated: " + duplicate);
        }
    }


    //group


    public static List<Class<?>> getAllSubGroupClasses(Class<?> clazz, String basePackageToScan) throws ClassNotFoundException {
        ClassPathScanningCandidateComponentProvider provider = new ClassPathScanningCandidateComponentProvider(false);
        provider.addIncludeFilter(new AssignableTypeFilter(clazz));

        List<Class<?>> classes = new ArrayList<>();
        Set<BeanDefinition> components = provider.findCandidateComponents(basePackageToScan);
        for (BeanDefinition component : components) {
            Class<?> cls = Class.forName(component.getBeanClassName());
            classes.add(cls);
        }
        return classes;
    }


    @Test
    public void testExceptionEnumGroupCodeShouldNotDuplicate() throws ClassNotFoundException {
        Class<?> clazz = CustomException.class;
        Set<String> duplicate = null;
        String basePackageToScan = "com.etekhno.resume.common.exceptions";
        System.out.println(clazz.getName());
        List<Class<?>> subClasses = getAllSubClasses(clazz, basePackageToScan);
        List<String> errorGroupList = new ArrayList<>();
        for (Class<?> subClazz : subClasses) {
            if (subClazz.equals(clazz))
                continue;

            Field field = subClazz.getDeclaredFields()[0];
            field.setAccessible(true);
            try {
                String errorGroup = (String) field.get(subClazz);
                errorGroupList.add(errorGroup);
            } catch (IllegalAccessException e) {
                e.printStackTrace();
            }
        }
        duplicate = errorGroupList.stream()
                .filter(e -> Collections.frequency(errorGroupList, e) > 1)
                .collect(Collectors.toSet());

        Assertions.assertEquals(0, duplicate.size(), "Error group duplicated: " + duplicate);
    }

}



