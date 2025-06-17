<?php
if (!defined("ROOT_PATH"))
{
	header("HTTP/1.1 403 Forbidden");
	exit;
}
class pjWorkingTimeModel extends pjAppModel
{
	protected $primaryKey = 'id';
	
	protected $table = 'working_times';
	
	protected $schema = array(
		array('name' => 'id', 'type' => 'int', 'default' => ':NULL'),
		array('name' => 'location_id', 'type' => 'int', 'default' => ':NULL'),
		array('name' => 'monday_from', 'type' => 'time', 'default' => ':NULL'),
		array('name' => 'monday_to', 'type' => 'time', 'default' => ':NULL'),
		array('name' => 'monday_lunch_from', 'type' => 'time', 'default' => ':NULL'),
		array('name' => 'monday_lunch_to', 'type' => 'time', 'default' => ':NULL'),
		array('name' => 'monday_dayoff', 'type' => 'enum', 'default' => 'F'),
		array('name' => 'tuesday_from', 'type' => 'time', 'default' => ':NULL'),
		array('name' => 'tuesday_to', 'type' => 'time', 'default' => ':NULL'),
		array('name' => 'tuesday_lunch_from', 'type' => 'time', 'default' => ':NULL'),
		array('name' => 'tuesday_lunch_to', 'type' => 'time', 'default' => ':NULL'),
		array('name' => 'tuesday_dayoff', 'type' => 'enum', 'default' => 'F'),
		array('name' => 'wednesday_from', 'type' => 'time', 'default' => ':NULL'),
		array('name' => 'wednesday_to', 'type' => 'time', 'default' => ':NULL'),
		array('name' => 'wednesday_lunch_from', 'type' => 'time', 'default' => ':NULL'),
		array('name' => 'wednesday_lunch_to', 'type' => 'time', 'default' => ':NULL'),
		array('name' => 'wednesday_dayoff', 'type' => 'enum', 'default' => 'F'),
		array('name' => 'thursday_from', 'type' => 'time', 'default' => ':NULL'),
		array('name' => 'thursday_to', 'type' => 'time', 'default' => ':NULL'),
		array('name' => 'thursday_lunch_from', 'type' => 'time', 'default' => ':NULL'),
		array('name' => 'thursday_lunch_to', 'type' => 'time', 'default' => ':NULL'),
		array('name' => 'thursday_dayoff', 'type' => 'enum', 'default' => 'F'),
		array('name' => 'friday_from', 'type' => 'time', 'default' => ':NULL'),
		array('name' => 'friday_to', 'type' => 'time', 'default' => ':NULL'),
		array('name' => 'friday_lunch_from', 'type' => 'time', 'default' => ':NULL'),
		array('name' => 'friday_lunch_to', 'type' => 'time', 'default' => ':NULL'),
		array('name' => 'friday_dayoff', 'type' => 'enum', 'default' => 'F'),
		array('name' => 'saturday_from', 'type' => 'time', 'default' => ':NULL'),
		array('name' => 'saturday_to', 'type' => 'time', 'default' => ':NULL'),
		array('name' => 'saturday_lunch_from', 'type' => 'time', 'default' => ':NULL'),
		array('name' => 'saturday_lunch_to', 'type' => 'time', 'default' => ':NULL'),
		array('name' => 'saturday_dayoff', 'type' => 'enum', 'default' => 'F'),
		array('name' => 'sunday_from', 'type' => 'time', 'default' => ':NULL'),
		array('name' => 'sunday_to', 'type' => 'time', 'default' => ':NULL'),
		array('name' => 'sunday_lunch_from', 'type' => 'time', 'default' => ':NULL'),
		array('name' => 'sunday_lunch_to', 'type' => 'time', 'default' => ':NULL'),
		array('name' => 'sunday_dayoff', 'type' => 'enum', 'default' => 'F')
	);
	
	public static function factory($attr=array())
	{
		return new pjWorkingTimeModel($attr);
	}
	
	public function getDaysOff($location_id)
	{
	    $data = array();
	    $arr = $this->reset()->where('location_id', $location_id)->limit(1)->findAll()->getDataIndex(0);
	    $wdays = array(1 => 'monday', 2 => 'tuesday', 3 => 'wednesday', 4 => 'thursday', 5 => 'friday', 6 => 'saturday', 0 => 'sunday');
	    foreach($wdays as $k => $day)
	    {
	        if(empty($arr[$day]))
	        {
	            $data[] = $k;
	        }
	    }
	    return $data;
	}
	
	public function getWorkingTime($location_id)
	{
		$arr = $this->reset()
			 ->where('location_id', $location_id)
			 ->findAll()
			 ->getData();
		return !empty($arr) ? $arr[0] : array();
	}
	
	public function init($location_id)
	{
		$data = array();
		$data['location_id']     = $location_id;
		
		$data['monday_from']    = '08:00:00';
		$data['monday_to']      = '18:00:00';
		$data['tuesday_from']   = '08:00:00';
		$data['tuesday_to']     = '18:00:00';
		$data['wednesday_from'] = '08:00:00';
		$data['wednesday_to']   = '18:00:00';
		$data['thursday_from']  = '08:00:00';
		$data['thursday_to']    = '18:00:00';
		$data['friday_from']    = '08:00:00';
		$data['friday_to']      = '18:00:00';
		$data['saturday_from']  = '08:00:00';
		$data['saturday_to']    = '18:00:00';
		$data['sunday_from']    = '08:00:00';
		$data['sunday_to']      = '18:00:00';
		
		$data['monday_lunch_from']    = '12:00:00';
		$data['monday_lunch_to']      = '13:00:00';
		$data['tuesday_lunch_from']   = '12:00:00';
		$data['tuesday_lunch_to']     = '13:00:00';
		$data['wednesday_lunch_from'] = '12:00:00';
		$data['wednesday_lunch_to']   = '13:00:00';
		$data['thursday_lunch_from']  = '12:00:00';
		$data['thursday_lunch_to']    = '13:00:00';
		$data['friday_lunch_from']    = '12:00:00';
		$data['friday_lunch_to']      = '13:00:00';
		$data['saturday_lunch_from']  = '12:00:00';
		$data['saturday_lunch_to']    = '13:00:00';
		$data['sunday_lunch_from']    = '12:00:00';
		$data['sunday_lunch_to']      = '13:00:00';
		
		return $this->reset()->setAttributes($data)->insert()->getInsertId();
	}
}