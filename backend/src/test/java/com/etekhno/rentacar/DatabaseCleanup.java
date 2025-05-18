package com.etekhno.rentacar;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Service;

import javax.sql.DataSource;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

@Service
@Profile("test")
public class DatabaseCleanup implements InitializingBean {

    @PersistenceContext
    EntityManager entityManager;
    private List<String> tableNames = new ArrayList<>();
    @Autowired
    DataSource dataSource;

    @Transactional
    public void truncateTables() {
        entityManager.createNativeQuery("SET @@foreign_key_checks = 0").executeUpdate();
        for (String tableName : tableNames) {
            entityManager.createNativeQuery(String.format("truncate table %s", tableName)).executeUpdate();
        }
        entityManager.createNativeQuery("SET @@foreign_key_checks = 1").executeUpdate();
    }

    @Override
    public void afterPropertiesSet() throws Exception {
        String catalog = dataSource.getConnection().getCatalog();
        ResultSet rs = dataSource.getConnection().getMetaData()
                .getTables(catalog,null,null,null);
        while(rs.next()){
            tableNames.add(rs.getString(3));
        }
    }

}
