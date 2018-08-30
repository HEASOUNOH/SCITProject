package global.sesoc.www.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import global.sesoc.www.dto.T_Schedule;

@Repository
public class T_ScheduleRepository {
	@Autowired
	SqlSession session;
	public int insertSchedule(T_Schedule schedule) {
		T_ScheduleMapper mapper=session.getMapper(T_ScheduleMapper.class);
		int result=mapper.insertSchedule(schedule);
		return result;
	}
	public List<T_Schedule> selectUserSchedule(String userId) {
		T_ScheduleMapper mapper=session.getMapper(T_ScheduleMapper.class);
		List<T_Schedule> list=mapper.selectUserSchedule(userId);
		return list;
	}
	public T_Schedule selectOneUserSchedule(T_Schedule schedule) {
		T_ScheduleMapper mapper=session.getMapper(T_ScheduleMapper.class);
		T_Schedule s=mapper.selectOneUserSchedule(schedule);
		return s;
	}
	public List<T_Schedule> selectPlannerSchedule(int plaNum) {
		T_ScheduleMapper mapper=session.getMapper(T_ScheduleMapper.class);
		List<T_Schedule> scheduleList=mapper.selectPlannerSchedule(plaNum);
		return scheduleList;
	}
	public int updateSchedule(T_Schedule schedule) {
		T_ScheduleMapper mapper=session.getMapper(T_ScheduleMapper.class);
		int result=mapper.updateSchedule(schedule);
		return result;
	}
	public int deletePlanner_Schedule(int plaNum) {
		T_ScheduleMapper mapper=session.getMapper(T_ScheduleMapper.class);
		int result=mapper.deletePlanner_Schedule(plaNum);
		return result;
	}
	public int deleteSchedule(int schNum) {
		T_ScheduleMapper mapper=session.getMapper(T_ScheduleMapper.class);
		int result=mapper.deleteSchedule(schNum);
		return result;
	}
	public List<T_Schedule> selectUserAllSchedule(String userId){
		T_ScheduleMapper mapper=session.getMapper(T_ScheduleMapper.class);
		List<T_Schedule> schduleList=mapper.selectUserAllSchedule(userId);
		return schduleList;
	}
	public List<T_Schedule> selectUserPlannerSchedule(T_Schedule schedule){
		T_ScheduleMapper mapper=session.getMapper(T_ScheduleMapper.class);
		List<T_Schedule> schduleList =mapper.selectUserPlannerSchedule(schedule);
		return schduleList;
	}
}