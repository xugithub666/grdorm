package cn.xxh.service;

import cn.xxh.pojo.Dorm;

import java.io.InputStream;
import java.util.List;

/**
 * Description:

 */
public interface DormService {

    List<Dorm> findAll(int page,int size) throws Exception;

    List<Dorm> search(int page,int size,String keyword) throws Exception;

    void add(Dorm dorm) throws Exception;

    void update(Dorm dorm) throws Exception;

    InputStream getInputStream() throws Exception;

    Dorm findByDormId(String dorm_id) throws Exception;

    Dorm findById(String id) throws Exception;

    List<Dorm> findByTeacher(String teacher) throws Exception;
}
