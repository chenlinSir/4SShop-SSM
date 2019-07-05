package com.direct.dao;

import java.util.List;

import com.direct.entity.PositionInfoEntity;

public interface IPositionInfoDao {
	public int insertPos(PositionInfoEntity pos);//添加方法
	
	public int deletePos(int pid);//删除方法
	
	public int updatePos(PositionInfoEntity pos);//修改方法
	
	public List<PositionInfoEntity> selPosId(int id);//根据id查询职位
		
	public List<PositionInfoEntity> selPos(PositionInfoEntity pos);//查询职位
	
	public List<PositionInfoEntity> selPos1();//查询所有职位数据
}
