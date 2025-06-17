<?php
if (!defined("ROOT_PATH"))
{
	header("HTTP/1.1 403 Forbidden");
	exit;
}
class pjAdminBookings extends pjAdmin
{
	public function pjActionCheckPickup()
	{
		$this->checkLogin();
		$this->setAjax(true);
	
		if ($this->isXHR())
		{
			$get = $this->_get->raw();
			$pickup_id = $get['pickup_id'];
			$result = 'true';
			if(!empty($pickup_id))
			{
				$pjDateModel = pjDateModel::factory();
				$pjWorkingTimeModel = pjWorkingTimeModel::factory();

				$from_arr = pjUtil::convertDateTime($get['date_from'], $this->option_arr['o_date_format'], $this->option_arr['o_time_format']);
				$from_ts = $from_arr['ts'];
				$wt_arr = $pjDateModel->getDailyWorkingTime($pickup_id, $from_arr['iso_date']);
				if($wt_arr !== false && !empty($wt_arr))
				{
					if($from_ts < $wt_arr['start_ts']){
						$result = 'false';
					}else if($from_ts > $wt_arr['end_ts']){
						$result = 'false';
					}elseif ($from_ts >= $wt_arr['lunch_start_ts'] && $from_ts < $wt_arr['lunch_end_ts']){
						$result = 'false';
					}
				}else{
					$wt_arr = $pjWorkingTimeModel->getWorkingTime($pickup_id);
					if(!empty($wt_arr))
					{
						$pickup_weekday = strtolower(date('l', $from_ts));
						if($wt_arr[$pickup_weekday . '_dayoff'] == 'T')
						{
							$result = 'false';
						}else if($from_ts < strtotime($from_arr['iso_date'] . ' ' . $wt_arr[$pickup_weekday . '_from'])){
							$result = 'false';
						}else if($from_ts > strtotime($from_arr['iso_date'] . ' ' . $wt_arr[$pickup_weekday . '_to'])){
							$result = 'false';
						}else if($from_ts >= strtotime($from_arr['iso_date'] . ' ' . $wt_arr[$pickup_weekday . '_lunch_from']) && $from_ts < strtotime($from_arr['iso_date'] . ' ' . $wt_arr[$pickup_weekday . '_lunch_to'])){
							$result = 'false';
						}
					}
				}
			}
			echo $result;
		}
		exit;
	}
	
	public function pjActionCheckReturn()
	{
		$this->checkLogin();
		$this->setAjax(true);
	
		if ($this->isXHR())
		{
			$get = $this->_get->raw();
			$return_id = $get['return_id'];
			$result = 'true';
			if(!empty($return_id))
			{
				$pjDateModel = pjDateModel::factory();
				$pjWorkingTimeModel = pjWorkingTimeModel::factory();

				$to_arr = pjUtil::convertDateTime($get['date_to'], $this->option_arr['o_date_format'], $this->option_arr['o_time_format']);
				$to_ts = $to_arr['ts'];
				$wt_arr = $pjDateModel->getDailyWorkingTime($return_id, $to_arr['iso_date']);
				if($wt_arr !== false && !empty($wt_arr))
				{
					if($to_ts < $wt_arr['start_ts']){
						$result = 'false';
					}else if($to_ts > $wt_arr['end_ts']){
						$result = 'false';
					}elseif ($to_ts >= $wt_arr['lunch_start_ts'] && $to_ts < $wt_arr['lunch_end_ts']){
						$result = 'false';
					}
				}else{
					$wt_arr = $pjWorkingTimeModel->getWorkingTime($return_id);
					if(!empty($wt_arr))
					{
						$return_weekday = strtolower(date('l', $to_ts));
						if($wt_arr[$return_weekday . '_dayoff'] == 'T')
						{
							$result = 'false';
						}else if($to_ts < strtotime($to_arr['iso_date'] . ' ' . $wt_arr[$return_weekday . '_from'])){
							$result = 'false';
						}else if($to_ts > strtotime($to_arr['iso_date'] . ' ' . $wt_arr[$return_weekday . '_to'])){
							$result = 'false';
						}else if($to_ts >= strtotime($to_arr['iso_date'] . ' ' . $wt_arr[$return_weekday . '_lunch_from']) && $to_ts < strtotime($to_arr['iso_date'] . ' ' . $wt_arr[$return_weekday . '_lunch_to'])){
							$result = 'false';
						}
					}
				}
			}
			echo $result;
		}
		exit;
	}
	
	public function pjActionGetBooking()
	{
		$this->checkLogin();
		$this->setAjax(true);
	
		if ($this->isXHR())
		{
			$pjBookingModel = pjBookingModel::factory();
			$get = $this->_get->raw();
			
			$column = 'created';
			$direction = 'DESC';
			
			if (isset($get['status']) && !empty($get['status']) && in_array($get['status'], array('confirmed', 'pending','cancelled', 'collected', 'completed')))
			{
				$pjBookingModel->where('t1.status', $get['status']);
			}
			
			if(isset($get['filter']) && in_array($get['filter'], array('p_today', 'p_tomorrow','r_today', 'r_tomorrow')))
			{
				switch ($get['filter']) {
					case 'p_today':
					    $pjBookingModel->where(sprintf("(DATE(t1.from)='%s' AND t1.status='confirmed')", date('Y-m-d')));
					;
					break;
					case 'p_tomorrow':
					    $pjBookingModel->where(sprintf("(DATE(t1.from)='%s' AND t1.status='confirmed')", date('Y-m-d', strtotime(date('Y-m-d') . ' +1 day'))));
					;
					break;
					case 'r_today':
					    $pjBookingModel->where(sprintf("(DATE(t1.to)='%s' AND t1.status='collected')", date('Y-m-d')));
					;
					break;
					case 'r_tomorrow':
						$pjBookingModel->where(sprintf("(DATE(t1.to)='%s' AND t1.status='collected')", date('Y-m-d', strtotime(date('Y-m-d') . ' +1 day'))));
					;
					break;
				}
			}
			if (isset($get['booking_id']) && !empty($get['booking_id']))
			{
				$pjBookingModel->where("t1.booking_id LIKE '%".$get['booking_id']."%'");
			}
			if (isset($get['car_id']) && (int) $get['car_id'] > 0)
			{
				$pjBookingModel->where('t1.car_id', $get['car_id']);
			}
			
			if (isset($get['type_id']) && (int) $get['type_id'] > 0)
			{
				$pjBookingModel->where('t1.type_id', $get['type_id']);
			}
			
			if (isset($get['pickup_from']) && !empty($get['pickup_from']) && isset($get['pickup_to']) && !empty($get['pickup_to']))
			{
				$pjBookingModel->where(sprintf("((`from` BETWEEN '%1\$s' AND '%2\$s') OR (`from` BETWEEN '%1\$s' AND '%2\$s'))",
					pjDateTime::formatDate($get['pickup_from'], $this->option_arr['o_date_format']),
					pjDateTime::formatDate($get['pickup_to'], $this->option_arr['o_date_format'])
				));
			} else {
				if (isset($get['pickup_from']) && !empty($get['pickup_from']))
				{
					$pjBookingModel->where('t1.from >=', pjDateTime::formatDate($get['pickup_from'], $this->option_arr['o_date_format']));
				}
				if (isset($get['pickup_to']) && !empty($get['pickup_to']))
				{
					$pjBookingModel->where('t1.from <=', pjDateTime::formatDate($get['pickup_to'], $this->option_arr['o_date_format']));
				}
			}
			
			if (isset($get['return_from']) && !empty($get['return_from']) && isset($get['return_to']) && !empty($get['return_to']))
			{
				$pjBookingModel->where(sprintf("((`to` BETWEEN '%1\$s' AND '%2\$s') OR (`to` BETWEEN '%1\$s' AND '%2\$s'))",
					pjDateTime::formatDate($get['return_from'], $this->option_arr['o_date_format']),
					pjDateTime::formatDate($get['return_from'], $this->option_arr['o_date_format'])
				));
			} else {
				if (isset($get['return_from']) && !empty($get['return_from']))
				{
					$pjBookingModel->where('t1.to >=', pjDateTime::formatDate($get['return_from'], $this->option_arr['o_date_format']));
				}
				if (isset($get['return_to']) && !empty($get['return_to']))
				{
					$pjBookingModel->where('t1.to <=', pjDateTime::formatDate($get['return_to'], $this->option_arr['o_date_format']));
				}
			}
			
			
			if (isset($get['pickup_id']) && (int) $get['pickup_id'] > 0)
			{
				$pjBookingModel->where('t1.pickup_id', $get['pickup_id']);
			}
			
			if (isset($get['return_id']) && (int) $get['return_id'] > 0)
			{
				$pjBookingModel->where('t1.return_id', $get['return_id']);
			}
			
			if (isset($get['q']) && !empty($get['q']))
			{
				
				$q = pjObject::escapeString($get['q']);
				$q = str_replace(array('%', '_'), array('\%', '\_'), $q);
				$pjBookingModel->where("(t1.c_name LIKE '%$q%' OR t1.c_email LIKE '%$q%' OR t1.c_phone LIKE '%$q%')");
			}
			
			if (isset($get['direction']) && isset($get['column']) && in_array(strtoupper($get['direction']), array('ASC', 'DESC')))
			{
				$column = $get['column'];
				$direction = strtoupper($get['direction']);
			}
			
			$total = $pjBookingModel->findCount()->getData();
			$rowCount = isset($get['rowCount']) && (int) $get['rowCount'] > 0 ? (int) $get['rowCount'] : 10;
			$pages = ceil($total / $rowCount);
			$page = isset($get['page']) && (int) $get['page'] > 0 ? intval($get['page']) : 1;
			$offset = ((int) $page - 1) * $rowCount;
			if ($page > $pages)
			{
				$page = $pages;
			}
			$data = $pjBookingModel->join('pjCar', 't2.id=t1.car_id', 'left outer')
							->join('pjMultiLang', "t3.foreign_id = t2.id AND t3.model = 'pjCar' AND t3.locale = '".$this->getLocaleId()."' AND t3.field = 'model'", 'left')
							->join('pjType', "t4.id = t1.type_id", 'left')
							->join('pjMultiLang', "t5.foreign_id = t4.id AND t5.model = 'pjType' AND t5.locale = '".$this->getLocaleId()."' AND t5.field = 'name'", 'left')
							->join('pjMultiLang', "t6.foreign_id = t1.pickup_id AND t6.model = 'pjLocation' AND t6.locale = '".$this->getLocaleId()."' AND t6.field = 'name'", 'left')
							->join('pjMultiLang', "t7.foreign_id = t1.return_id AND t7.model = 'pjLocation' AND t7.locale = '".$this->getLocaleId()."' AND t7.field = 'name'", 'left')
							->join('pjMultiLang', "t8.model='pjCar' AND t8.foreign_id=t1.car_id AND t8.field='make' AND t8.locale='".$this->getLocaleId()."'", 'left')
							->join('pjMultiLang', "t9.model='pjCar' AND t9.foreign_id=t1.car_id AND t9.field='model' AND t9.locale='".$this->getLocaleId()."'", 'left')
							->select("t1.id, t1.type_id,t1.car_id,t1.from, t1.to, t1.status, t1.total_price , t1.c_name, t1.c_phone, t3.content as model , t2.registration_number, t5.content as type, t6.content as pickup_location, t7.content as return_location, t8.content as make, t9.content as model")
							->orderBy("$column $direction")->limit($rowCount, $offset)->findAll()->getData();
			$data = pjSanitize::clean($data);
			foreach ($data as $key => $val){
				$data[$key]['pick_drop'] = date($this->option_arr['o_date_format'], strtotime($val['from'])) . ', ' . date($this->option_arr['o_time_format'], strtotime($val['from'])) . ' ' . __('booking_at', true, false) . ' ' . $val['pickup_location'] . "<br/>";
				$data[$key]['pick_drop'] .= date($this->option_arr['o_date_format'], strtotime($val['to'])) . ', ' . date($this->option_arr['o_time_format'], strtotime($val['to'])) . ' ' . __('booking_at', true, false) . ' ' . $val['return_location'];
				$data[$key]['car_info'] = $val['registration_number'] . ',<br/>' . $val['make'] . " " . $val['model'];
				$data[$key]['client'] = $val['c_name'] . '<br/>' . $val['c_phone'];
				$data[$key]['total_price'] = pjCurrency::formatPrice($val['total_price']);
			}
			pjAppController::jsonResponse(compact('data', 'total', 'pages', 'page', 'rowCount', 'column', 'direction'));
		}
		exit;
	}
	
	public function pjActionIndex()
	{
		$this->checkLogin();
	    if (!pjAuth::factory()->hasAccess())
	    {
	        $this->sendForbidden();
	        return;
	    }
	    
		$type_arr = pjTypeModel::factory()->select('t1.*, t2.content AS name')
											->join('pjMultiLang', "t2.model='pjType' AND t2.foreign_id=t1.id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left')
											->where('status', 'T')->orderBy('name ASC')->findAll()->getData();
		$this->set('type_arr', pjSanitize::clean($type_arr));
		
		$pickup_arr = pjLocationModel::factory()->select('t1.*, t2.content AS name')
				->join('pjMultiLang', "t2.model='pjLocation' AND t2.foreign_id=t1.id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left')
				->where('status', 'T')->orderBy('name ASC')->findAll()->getData();
				
		$this->set('pickup_arr', pjSanitize::clean($pickup_arr));
		
		$return_arr = pjLocationModel::factory()->select('t1.*, t2.content AS name')
				->join('pjMultiLang', "t2.model='pjLocation' AND t2.foreign_id=t1.id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left')
				->where('status', 'T')->orderBy('name ASC')->findAll()->getData();
				
		$this->set('return_arr', pjSanitize::clean($return_arr));
		
		$this->set('date_format', pjUtil::toBootstrapDate($this->option_arr['o_date_format']));
		
		$this->appendCss('datepicker3.css', PJ_THIRD_PARTY_PATH . 'bootstrap_datepicker/');
		$this->appendJs('bootstrap-datepicker.js', PJ_THIRD_PARTY_PATH . 'bootstrap_datepicker/');		
		$this->appendJs('jquery.datagrid.js', PJ_FRAMEWORK_LIBS_PATH . 'pj/js/');
		$this->appendJs('pjAdminBookings.js');
		
		$this->set('has_update', pjAuth::factory('pjAdminBookings', 'pjActionUpdate')->hasAccess());
		$this->set('has_create', pjAuth::factory('pjAdminBookings', 'pjActionCreate')->hasAccess());
		$this->set('has_delete', pjAuth::factory('pjAdminBookings', 'pjActionDeleteBooking')->hasAccess());
		$this->set('has_delete_bulk', pjAuth::factory('pjAdminBookings', 'pjActionDeleteBookingBulk')->hasAccess());
		$this->set('has_update_type', pjAuth::factory('pjAdminTypes', 'pjActionUpdate')->hasAccess());
		$this->set('has_update_car', pjAuth::factory('pjAdminCars', 'pjActionUpdate')->hasAccess());
	}
	
	public function pjActionCreate()
	{
		$this->checkLogin();
	    if (!pjAuth::factory()->hasAccess())
	    {
	        $this->sendForbidden();
	        return;
	    }
		
		if ($this->_post->check('booking_create'))
		{
			$pjBookingModel = pjBookingModel::factory();
			$pjBookingExtraModel = pjBookingExtraModel::factory();
			
			$post = $this->_post->raw();
			$data = array();
			$data['uuid'] = time();
			$data['booking_id'] = $this->getBookingID();
			$data['ip'] = pjUtil::getClientIp();
			$data['locale_id'] = $this->getLocaleId();
			$from_arr = pjUtil::convertDateTime($post['date_from'], $this->option_arr['o_date_format'], $this->option_arr['o_time_format']);
			$to_arr = pjUtil::convertDateTime($post['date_to'], $this->option_arr['o_date_format'], $this->option_arr['o_time_format']);
						
			$data['from'] = $from_arr['iso_date_time'];
			$data['to'] = $to_arr['iso_date_time'];
			
			if(isset($post['pickup_date']) && !empty($post['pickup_date']))
			{
				$pickup_date_arr = pjUtil::convertDateTime($post['pickup_date'], $this->option_arr['o_date_format'], $this->option_arr['o_time_format']);
				$data['pickup_date'] = $pickup_date_arr['iso_date_time'];
			}else{
				$data['pickup_date'] = ':NULL';
			}			
			$post = array_merge($post, $data);			
			$id = $pjBookingModel->setAttributes($post)->insert()->getInsertId();
			if ($id !== false && (int) $id > 0)
			{
				if (isset($post['ex_id']) && is_array($post['ex_id']) && count($post['ex_id']) > 0)
				{
					$pjBookingExtraModel->begin();
					foreach ($post['ex_id'] as $k => $extra_id)
					{
						if ((int)$extra_id > 0 && (int)$post['ex_cnt'][$k] > 0) {
							$pjBookingExtraModel
								->reset()
								->set('booking_id', $id)
								->set('extra_id', $extra_id)
								->set('price', $post['ex_price'][$k])
								->set('quantity', $post['ex_cnt'][$k])
								->insert();
						}
					}
					$pjBookingExtraModel->commit();
				}
				
				pjUtil::redirect($_SERVER['PHP_SELF'] . "?controller=pjAdminBookings&action=pjActionIndex&err=AR03");
			} else {
				pjUtil::redirect($_SERVER['PHP_SELF'] . "?controller=pjAdminBookings&action=pjActionIndex&err=AR04");
			}
		}else{
			$type_arr = pjTypeModel::factory()->select('t1.*, t2.content AS name')
					->join('pjMultiLang', "t2.model='pjType' AND t2.foreign_id=t1.id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left')
					->where('status', 'T')->orderBy('name ASC')->findAll()->getData();
					
			$this->set('type_arr', pjSanitize::clean($type_arr));
			
			
			$pickup_arr = pjLocationModel::factory()->select('t1.*, t2.content AS name')
					->join('pjMultiLang', "t2.model='pjLocation' AND t2.foreign_id=t1.id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left')
					->where('status', 'T')->orderBy('name ASC')->findAll()->getData();
					
			$this->set('pickup_arr', pjSanitize::clean($pickup_arr));
			
			$return_arr = pjLocationModel::factory()->select('t1.*, t2.content AS name')
					->join('pjMultiLang', "t2.model='pjLocation' AND t2.foreign_id=t1.id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left')
					->where('status', 'T')->orderBy('name ASC')->findAll()->getData();
					
			$this->set('return_arr', pjSanitize::clean($return_arr));
			
			$country_arr = pjBaseCountryModel::factory()
					->select('t1.id, t2.content AS name')
					->join('pjMultiLang', "t2.model='pjBaseCountry' AND t2.foreign_id=t1.id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left outer')
					->where('t1.status', 'T')
					->orderBy('`name` ASC')->findAll()->getData();			
			$this->set('country_arr', pjSanitize::clean($country_arr));
			
			if(pjObject::getPlugin('pjPayments') !== NULL)
			{
				$this->set('payment_option_arr', pjPaymentOptionModel::factory()->getOptions($this->getForeignId()));
				$this->set('payment_titles', pjPayments::getPaymentTitles($this->getForeignId(), $this->getLocaleId()));
			}
			else
			{
				$this->set('payment_titles', __('payment_methods', true));
			}
			
			$this->appendCss('css/select2.min.css', PJ_THIRD_PARTY_PATH . 'select2/');
			$this->appendJs('js/select2.full.min.js', PJ_THIRD_PARTY_PATH . 'select2/');
			
			$this->appendJs('moment-with-locales.min.js', PJ_THIRD_PARTY_PATH . 'moment/');
	        $this->appendCss('build/css/bootstrap-datetimepicker.min.css', PJ_THIRD_PARTY_PATH . 'bootstrap_datetimepicker/');
	        $this->appendJs('build/js/bootstrap-datetimepicker.min.js', PJ_THIRD_PARTY_PATH . 'bootstrap_datetimepicker/');
			$this->appendJs('pjAdminBookings.js');
		}
	}
	
	public function pjActionUpdate()
	{
		$this->checkLogin();
	    if (!pjAuth::factory()->hasAccess())
	    {
	        $this->sendForbidden();
	        return;
	    }
		$pjBookingModel = pjBookingModel::factory();
		$pjCarModel = pjCarModel::factory();
		$pjCarTypeModel = pjCarTypeModel::factory();
		$pjTypeExtraModel = pjTypeExtraModel::factory();
		$pjBookingExtraModel = pjBookingExtraModel::factory();

		if ($this->_get->check('id') && $this->_get->toInt('id')) {
			$pjBookingModel->where('t1.id', $this->_get->toInt('id'));
		}
		if ($this->_post->check('id') && $this->_post->toInt('id')) {
			$pjBookingModel->where('t1.id', $this->_post->toInt('id'));
		}
		
		$booking_arr = $pjBookingModel
			->select("t1.*")
			->join('pjCar', 't2.id=t1.car_id', 'left outer')
			->join('pjType', "t3.id = t1.type_id", 'left outer')
			->limit(1)
			->findAll()
			->getDataIndex(0);

		if (empty($booking_arr) || count($booking_arr) == 0)
		{
			pjUtil::redirect($_SERVER['PHP_SELF'] . "?controller=pjAdminBookings&action=pjActionIndex&err=AR08");
		}		
		
		if ($this->_post->check('booking_update'))
		{
			$post = $this->_post->raw();
			$data = array();
			$from_arr = pjUtil::convertDateTime($post['date_from'], $this->option_arr['o_date_format'], $this->option_arr['o_time_format']);
			$to_arr = pjUtil::convertDateTime($post['date_to'], $this->option_arr['o_date_format'], $this->option_arr['o_time_format']);
						
			$data['from'] = $from_arr['iso_date_time'];
			$data['to'] = $to_arr['iso_date_time'];
			
			if(isset($post['pickup_date']) && !empty($post['pickup_date']))
			{
				$pickup_date_arr = pjUtil::convertDateTime($post['pickup_date'], $this->option_arr['o_date_format'], $this->option_arr['o_time_format']);
				$data['pickup_date'] = $pickup_date_arr['iso_date_time'];
			}else{
				$data['pickup_date'] = ':NULL';
			}	
			
			if(isset($post['actual_dropoff_datetime']) && !empty($post['actual_dropoff_datetime']))
			{
				$actual_dropoff_datetime_arr = pjUtil::convertDateTime($post['actual_dropoff_datetime'], $this->option_arr['o_date_format'], $this->option_arr['o_time_format']);
				$data['actual_dropoff_datetime'] = $actual_dropoff_datetime_arr['iso_date_time'];
			}else{
				$data['actual_dropoff_datetime'] = ':NULL';
			}								
			$post = array_merge($post, $data);			
			if (!$pjBookingModel->validates($post))
			{
				pjUtil::redirect($_SERVER['PHP_SELF'] . "?controller=pjAdminBookings&action=pjActionIndex&err=AR02");
			}			
			$pjBookingModel->reset()->set('id', $booking_arr['id'])->modify($post);			
			$pjBookingExtraModel->where('booking_id', $booking_arr['id'])->eraseAll();			
			if (isset($post['ex_id']) && is_array($post['ex_id']) && count($post['ex_id']) > 0)
			{
				$pjBookingExtraModel->begin();
				foreach ($post['ex_id'] as $k => $extra_id)
				{
					if ((int)$extra_id > 0 && (int)$post['ex_cnt'][$k] > 0) {
						$pjBookingExtraModel
							->reset()
							->set('booking_id', $booking_arr['id'])
							->set('extra_id', $extra_id)
							->set('price', $post['ex_price'][$k])
							->set('quantity', $post['ex_cnt'][$k])
							->insert();
					}
				}
				$pjBookingExtraModel->commit();
			}
			
			$pjBookingPaymentModel = pjBookingPaymentModel::factory();
			$pjBookingPaymentModel->where('booking_id', $booking_arr['id'])->eraseAll();			
			if (isset($post['p_payment_method']) && count($post['p_payment_method']) > 0)
			{
				foreach ($post['p_payment_method'] as $k => $v)
				{
					if(floatval($post['p_amount'][$k]) > 0)
					{
						$payment_arr = array(
										'booking_id' => $post['id'],
										'payment_method' => @$post['p_payment_method'][$k],
										'payment_type' => @$post['p_payment_type'][$k],
										'amount' => @$post['p_amount'][$k],
										'status' => @$post['p_payment_status'][$k]
									);
						$pjBookingPaymentModel->reset()->setAttributes($payment_arr)->insert();
					}
				}
			}							
			pjUtil::redirect($_SERVER['PHP_SELF'] . "?controller=pjAdminBookings&action=pjActionUpdate&id=".$post['id']. "&tab=" . $post['tab_id']."&err=AR01");
		}else {
			$this->set('arr', $booking_arr);
			$car_arr = $pjCarModel->find($booking_arr['car_id'])->getData();		
			if (empty($car_arr) || count($car_arr) == 0)
			{
				//pjUtil::redirect($_SERVER['PHP_SELF'] . "?controller=pjAdminBookings&action=pjActionIndex&err=AC08");
			}
			$this->set('booking_car_arr', $car_arr);
			
			$car_arr = array();
			$extra_price_arr = array();
			if ((int) $booking_arr['type_id'] > 0)
			{
				$car_arr = $pjCarTypeModel->select('t1.*,t4.registration_number, t2.content AS make, t3.content as model')
				->join('pjMultiLang', "t2.model='pjCar' AND t2.foreign_id=t1.car_id AND t2.field='make' AND t2.locale='".$this->getLocaleId()."'", 'left')
				->join('pjMultiLang', "t3.model='pjCar' AND t3.foreign_id=t1.car_id AND t3.field='model' AND t3.locale='".$this->getLocaleId()."'", 'left')
				->join('pjCar', "t4.id = t1.car_id")
				->orderBy('t2.content ASC, t3.content ASC')
				->where('t1.type_id',$booking_arr['type_id'])
				->findAll()->getData()
				;
			}
			$this->set('car_arr', pjSanitize::clean($car_arr));
			
			$extra_arr = $pjTypeExtraModel->select('t1.*, t2.content as name , t3.price, t3.per, t3.count, t3.type')
				->join('pjMultiLang', "t2.model='pjExtra' AND t2.foreign_id=t1.extra_id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left')
				->join('pjExtra', "t3.id = t1.extra_id")
				->orderBy('t2.content ASC')
				->where('t1.type_id',$booking_arr['type_id'])
				->findAll()->getData();
			
			$per_extra = __('per_extras', true, false);
			foreach($extra_arr as $v)
			{
				$extra_price_arr[$v['extra_id']] = $v;
			}
			$this->set('extra_arr', pjSanitize::clean($extra_arr));
			$this->set('extra_price_arr', $extra_price_arr);
			$be_arr = $pjBookingExtraModel->where('booking_id', $booking_arr['id'])->findAll()->getDataPair('extra_id', 'extra_id');
			$this->set('be_arr', $be_arr);
			
			$be_quantity_arr = array();
			$extended_extra_arr = array();
			$be_quantity = $pjBookingExtraModel
							->where('t1.booking_id',$booking_arr['id'])
							->findAll()->getData();
			
			foreach ($be_quantity as $key => $val){
				$be_quantity_arr[$val['extra_id']] = $val['quantity'];
				$extended_extra_arr[$val['extra_id']] = $val;
			}
			
			$this->set('be_quantity_arr', $be_quantity_arr);
			$this->set('extended_extra_arr', $extended_extra_arr);
					
			$type_arr = pjTypeModel::factory()->select('t1.*, t2.content AS name')
					->join('pjMultiLang', "t2.model='pjType' AND t2.foreign_id=t1.id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left')
					->where('status', 'T')->orderBy('name ASC')->findAll()->getData();
					
			$this->set('type_arr', pjSanitize::clean($type_arr));
			
			$pickup_arr = pjLocationModel::factory()->select('t1.*, t2.content AS name')
					->join('pjMultiLang', "t2.model='pjLocation' AND t2.foreign_id=t1.id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left')
					->where('status', 'T')->orderBy('name ASC')->findAll()->getData();
					
			$this->set('pickup_arr', pjSanitize::clean($pickup_arr));
			
			$return_arr = pjLocationModel::factory()->select('t1.*, t2.content AS name')
					->join('pjMultiLang', "t2.model='pjLocation' AND t2.foreign_id=t1.id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left')
					->where('status', 'T')->orderBy('name ASC')->findAll()->getData();
					
			$this->set('return_arr', pjSanitize::clean($return_arr));
				
			$country_arr = pjBaseCountryModel::factory()
					->select('t1.id, t2.content AS name')
					->join('pjMultiLang', "t2.model='pjBaseCountry' AND t2.foreign_id=t1.id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left outer')
					->where('t1.status', 'T')
					->orderBy('`name` ASC')->findAll()->getData();			
			$this->set('country_arr', pjSanitize::clean($country_arr));
	
			$payment_arr = pjBookingPaymentModel::factory()->where('t1.booking_id',$booking_arr['id'])->findAll()->getData();
			$this->set('payment_arr', $payment_arr);
			
			$collected = 0;
			$security_returned = 0;
			foreach($payment_arr as $v)
			{
				if($v['payment_type'] != 'securityreturned' && $v['status'] == 'paid')
				{
					$collected += $v['amount'];
				}
				if($v['payment_type'] == 'securityreturned' && $v['status'] == 'paid'){
					$security_returned += $v['amount'];
				}
			}
			$this->set('collected', $collected - $security_returned);
			
			if(pjObject::getPlugin('pjPayments') !== NULL)
			{
				$this->set('payment_option_arr', pjPaymentOptionModel::factory()->getOptions($this->getForeignId()));
				$this->set('payment_titles', pjPayments::getPaymentTitles($this->getForeignId(), $this->getLocaleId()));
			}
			else
			{
				$this->set('payment_titles', __('payment_methods', true));
			}
			
			$this->appendCss('css/select2.min.css', PJ_THIRD_PARTY_PATH . 'select2/');
			$this->appendJs('js/select2.full.min.js', PJ_THIRD_PARTY_PATH . 'select2/');
			$this->appendJs('tinymce.min.js', PJ_THIRD_PARTY_PATH . 'tinymce/');
			$this->appendJs('moment-with-locales.min.js', PJ_THIRD_PARTY_PATH . 'moment/');
	        $this->appendCss('build/css/bootstrap-datetimepicker.min.css', PJ_THIRD_PARTY_PATH . 'bootstrap_datetimepicker/');
	        $this->appendJs('build/js/bootstrap-datetimepicker.min.js', PJ_THIRD_PARTY_PATH . 'bootstrap_datetimepicker/');
			$this->appendJs('pjAdminBookings.js');			
		}
	}
	
		
	public function pjActionDeleteBooking()
	{
		$this->setAjax(true);
	
		if (!pjAuth::factory()->hasAccess())
		{
		    self::jsonResponse(array('status' => 'ERR', 'code' => 103, 'text' => 'Access denied.'));
		}
		
		if (!$this->isXHR())
		{
		    self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
		}
		
		if (!self::isGet() && !$this->_get->check('id') && $this->_get->toInt('id') < 0)
		{
		    self::jsonResponse(array('status' => 'ERR', 'code' => 101, 'text' => 'HTTP method not allowed.'));
		}
		if ($this->_get->toInt('id') > 0) {
			$id = $this->_get->toInt('id');
			$pjBookingModel = pjBookingModel::factory();
			if ($pjBookingModel->setAttributes(array('id' => $id))->erase()->getAffectedRows() == 1)
			{
				pjBookingPaymentModel::factory()->where('booking_id', $id)->eraseAll();
				pjBookingExtraModel::factory()->where('booking_id', $id)->eraseAll();
				pjAppController::jsonResponse(array('status' => 'OK', 'code' => 200, 'text' => 'Booking has been deleted.'));
			} else {
				pjAppController::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Booking has not been deleted.'));
			}
		} else {
			pjAppController::jsonResponse(array('status' => 'ERR', 'code' => 101, 'text' => 'Missing or empty parameters.'));
		}
		exit;
	}
	
	public function pjActionDeleteBookingBulk()
	{
		$this->setAjax(true);
	
		if (!pjAuth::factory()->hasAccess())
		{
		    self::jsonResponse(array('status' => 'ERR', 'code' => 103, 'text' => 'Access denied.'));
		}
		if (!$this->isXHR())
		{
		    self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
		}
		
		if (!self::isPost())
		{
		    self::jsonResponse(array('status' => 'ERR', 'code' => 101, 'text' => 'HTTP method not allowed.'));
		}
	
		$record = $this->_post->toArray('record');		
		if (!empty($record))
		{
			$pjBookingModel = pjBookingModel::factory();
			
			$pjBookingModel->reset()->whereIn('id', $record)->eraseAll();
			pjBookingPaymentModel::factory()->whereIn('booking_id', $record)->eraseAll();
			pjBookingExtraModel::factory()->whereIn('booking_id', $record)->eraseAll();
			self::jsonResponse(array('status' => 'OK', 'code' => 200, 'text' => 'Booking(s) has been deleted.'));
		}
		self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing or empty parameters.'));
		exit;
	}
	
	public function pjActionSaveBooking()
	{
		$this->checkLogin();
		$this->setAjax(true);
	
		if ($this->isXHR())
		{
			$get = $this->_get->raw();
			$post = $this->_post->raw();
			pjBookingModel::factory()->where('id', $get['id'])->limit(1)->modifyAll(array($post['column'] => $post['value']));
		}
		exit;
	}
	
	public function pjActionConfirmation()
	{
		$this->checkLogin();
	    $this->setAjax(true);
	    
	    if ($this->isXHR())
	    {
	        if (self::isPost())
	        {
	            if($this->_post->toInt('send_email') && $this->_post->toString('to') && $this->_post->toString('subject') && $this->_post->toString('message') && $this->_post->toInt('id'))
	            {
	                $Email = self::getMailer($this->option_arr);
	                $r = $Email
	                ->setTo($this->_post->toString('to'))
	                ->setSubject($this->_post->toString('subject'))
	                ->send($this->_post->toString('message'));
	                if (isset($r) && $r)
	                {
	                    pjAppController::jsonResponse(array('status' => 'OK', 'code' => 200, 'text' => ''));
	                }
	                pjAppController::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => ''));
	            }
	        }
	        if (self::isGet())
	        {
	            if($booking_id = $this->_get->toInt('booking_id'))
	            {
	            	$pjNotificationModel = pjNotificationModel::factory();
	               	$arr = pjBookingModel::factory()->select(sprintf("t1.*, t2.content as type, t3.content as pickup_location , t4.content as return_location, AES_DECRYPT(t1.cc_num, '%s') AS `cc_num`, AES_DECRYPT(t1.cc_exp, '%s') AS `cc_exp`, AES_DECRYPT(t1.cc_code, '%s') AS `cc_code`", PJ_SALT, PJ_SALT, PJ_SALT))
											  ->join('pjMultiLang', "t2.foreign_id = t1.type_id AND t2.model = 'pjType' AND t2.locale = t1.locale_id AND t2.field = 'name'", 'left')
											  ->join('pjMultiLang', "t3.foreign_id = t1.pickup_id AND t3.model = 'pjLocation' AND t3.locale = t1.locale_id AND t3.field = 'name'", 'left')
											  ->join('pjMultiLang', "t4.foreign_id = t1.return_id AND t4.model = 'pjLocation' AND t4.locale = t1.locale_id AND t4.field = 'name'", 'left')
						->find($booking_id)
						->getData();
					$locale_id = (int)$arr['locale_id'] > 0 ? (int)$arr['locale_id'] : $this->getLocaleId();
					$extra_arr = pjBookingExtraModel::factory()->select("t1.*, t2.content as name, t3.price")
													 ->join('pjMultiLang', "t2.foreign_id = t1.extra_id AND t2.model = 'pjExtra' AND t2.locale = '".$locale_id."' AND t2.field = 'name'", 'left')
													 ->join('pjExtra', "t3.id = t1.extra_id")
													 ->where('t1.booking_id',$arr['id'])
													 ->findAll()->getData();
					$arr['extra_arr'] = $extra_arr;
					$tokens = pjAppController::getTokens($arr, $this->option_arr, PJ_SALT, $locale_id);
					
					$notification = $pjNotificationModel->reset()->where('recipient', 'client')->where('transport', 'email')->where('variant', 'confirmation')->findAll()->getDataIndex(0);
					if((int) $notification['id'] > 0 && $notification['is_active'] == 1)
					{
					    $resp = pjFront::pjActionGetSubjectMessage($notification, $locale_id, $this->getForeignId());
					    $lang_message = $resp['lang_message'];
					    $lang_subject = $resp['lang_subject'];
					   
					    $subject_client = str_replace($tokens['search'], $tokens['replace'], $lang_subject[0]['content']);
					    $message_client = str_replace($tokens['search'], $tokens['replace'], $lang_message[0]['content']);
					    
					    $this->set('arr', array(
					        'id' => $booking_id,
					        'to' => $arr['c_email'],
					        'message' => $message_client,
					        'subject' => $subject_client
					    ));
					}
					
	            }
	        }
	    }
	}
	
	public function pjActionSms()
	{
		$this->checkLogin();
	    $this->setAjax(true);
	    
	    if ($this->isXHR())
	    {
	        if (self::isPost())
	        {
	            if($this->_post->toInt('send_sms') && $this->_post->toString('to') && $this->_post->toString('message') && $this->_post->toInt('id'))
	            {
	            	$params = array(
	                    'text' => stripslashes($this->_post->toString('message')),
	                    'type' => 'unicode',
	                    'key' => md5($this->option_arr['private_key'] . PJ_SALT)
	                );
	                $params['number'] = $this->_post->toString('to');
	                $response = pjBaseSms::init($params)->pjActionSend();	                
			        if($response == 1)
			        {
			            pjAppController::jsonResponse(array('status' => 'OK', 'code' => 200, 'text' => ''));
			        }else{
			            pjAppController::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => ''));
			        }
	            }
	        }
	        if (self::isGet())
	        {
	            if($booking_id = $this->_get->toInt('booking_id'))
	            {
	            	$pjNotificationModel = pjNotificationModel::factory();
	               	$arr = pjBookingModel::factory()->select(sprintf("t1.*, t2.content as type, t3.content as pickup_location , t4.content as return_location, AES_DECRYPT(t1.cc_num, '%s') AS `cc_num`, AES_DECRYPT(t1.cc_exp, '%s') AS `cc_exp`, AES_DECRYPT(t1.cc_code, '%s') AS `cc_code`", PJ_SALT, PJ_SALT, PJ_SALT))
											  ->join('pjMultiLang', "t2.foreign_id = t1.type_id AND t2.model = 'pjType' AND t2.locale = t1.locale_id AND t2.field = 'name'", 'left')
											  ->join('pjMultiLang', "t3.foreign_id = t1.pickup_id AND t3.model = 'pjLocation' AND t3.locale = t1.locale_id AND t3.field = 'name'", 'left')
											  ->join('pjMultiLang', "t4.foreign_id = t1.return_id AND t4.model = 'pjLocation' AND t4.locale = t1.locale_id AND t4.field = 'name'", 'left')
						->find($booking_id)
						->getData();
					$locale_id = (int)$arr['locale_id'] > 0 ? (int)$arr['locale_id'] : $this->getLocaleId();
					$extra_arr = pjBookingExtraModel::factory()->select("t1.*, t2.content as name, t3.price")
													 ->join('pjMultiLang', "t2.foreign_id = t1.extra_id AND t2.model = 'pjExtra' AND t2.locale = '".$locale_id."' AND t2.field = 'name'", 'left')
													 ->join('pjExtra', "t3.id = t1.extra_id")
													 ->where('t1.booking_id',$arr['id'])
													 ->findAll()->getData();
					$arr['extra_arr'] = $extra_arr;
					$tokens = pjAppController::getTokens($arr, $this->option_arr, PJ_SALT, $locale_id);
					
					$notification = $pjNotificationModel->reset()->where('recipient', 'client')->where('transport', 'sms')->where('variant', 'reminder')->findAll()->getDataIndex(0);
					if((int) $notification['id'] > 0 && $notification['is_active'] == 1)
					{
					    $resp = pjFront::pjActionGetSmsMessage($notification, $locale_id, $this->getForeignId());
					    $lang_message = $resp['lang_message'];
					    $message_client = str_replace($tokens['search'], $tokens['replace'], $lang_message[0]['content']);					    
					    $this->set('arr', array(
					        'id' => $booking_id,
					        'to' => $arr['c_phone'],
					        'message' => $message_client
					    ));
					}
					
	            }
	        }
	    }
	}
	
	public function pjActionGetCars()
	{
		$this->checkLogin();
		$this->setAjax(true);
	
		if ($this->isXHR())
		{
			$arr = array();
			if ($this->_get->check('type_id') && (int) $this->_get->toInt('type_id') > 0)
			{
				$pjCarModel = pjCarModel::factory();
				$pjCarTypeModel = pjCarTypeModel::factory();
				
				$arr = $pjCarTypeModel
				->select('t2.id as car_id, t2.registration_number, t3.content AS make, t4.content AS model')
				->join('pjCar', "t1.car_id = t2.id", 'left')
				->join('pjMultiLang', "t3.model='pjCar' AND t3.foreign_id=t2.id AND t3.field='make' AND t3.locale='".$this->getLocaleId()."'", 'left')
				->join('pjMultiLang', "t4.model='pjCar' AND t4.foreign_id=t2.id AND t4.field='model' AND t4.locale='".$this->getLocaleId()."'", 'left')
				->where('type_id', $this->_get->toInt('type_id'))
				->where('t2.status', 'T')
				->orderBy('make ASC')
				->findAll()->getData();
			
				$arr = pjSanitize::clean($arr);
			}
			
			$this->set('car_arr', $arr);
		}
	}
	
	public function pjActionGetExtras()
	{
		$this->checkLogin();
		$this->setAjax(true);
	
		if ($this->isXHR())
		{
			$arr = array();
			if ($this->_get->check('type_id') && (int) $this->_get->toInt('type_id') > 0)
			{
				$pjTypeExtraModel = pjTypeExtraModel::factory();				
				$arr = $pjTypeExtraModel
				->select('t2.type, t2.id as extra_id, t2.price , t2.per, t2.count , t3.content AS name')
				->join('pjExtra', "t1.extra_id = t2.id", 'left')
				->join('pjMultiLang', "t3.model='pjExtra' AND t3.foreign_id=t2.id AND t3.field='name' AND t3.locale='".$this->getLocaleId()."'", 'left')
				->where('type_id', $this->_get->toInt('type_id'))
				->where('t2.status', 'T')
				->orderBy('name ASC')
				->findAll()->getData();
				$arr = pjSanitize::clean($arr);				
			}
			$this->set('extra_arr', $arr);
		}
	}
	
	public function pjActionGetPrices()
	{
		$this->checkLogin();
		$this->setAjax(true);
	
		if ($this->isXHR())
		{
		
			$pjExtraModel = pjExtraModel::factory();
			$pjPriceModel = pjPriceModel::factory();
			$pjTypeModel = pjTypeModel::factory();
			
			$post = $this->_post->raw();
			
			$from_arr = pjUtil::convertDateTime($post['date_from'], $this->option_arr['o_date_format'], $this->option_arr['o_time_format']);
			$to_arr = pjUtil::convertDateTime($post['date_to'], $this->option_arr['o_date_format'], $this->option_arr['o_time_format']);
			
			$date_from = $from_arr['iso_date_time'];
			$date_to = $to_arr['iso_date_time'];
	
			$seconds = abs(strtotime($date_to) - strtotime($date_from));
			$rental_days = floor($seconds / 86400);
			$rental_hours = ceil($seconds / 3600);			
			$hours = intval($rental_hours - ($rental_days * 24));
			
			$price = 0;
	    	$extra_price = 0;
	    	$price_per_day = 0;
	    	$price_per_hour = 0;
	    	$price_per_day_detail = '';
	    	$price_per_hour_detail = '';
	    	$car_rental_fee = 0;
	    	$car_rental_fee_detail = '';
	    	$sub_total = 0;
	    	$total_price = 0;
	    	$required_deposit = 0;
	    	$insurance_detail = '';
	    	$tax_detail = '';
	    	$required_deposit_detail = '';
	    	
	    	$car_rental_fee_arr = array();
					
			$e_arr = array();
			$extra_arr = array();
			$extra_qty_arr = array();
			if(isset($post['ex_id'])){
				foreach ($post['ex_id'] as $key => $extra_id){
					if((int) $extra_id > 0 && (int)$post['ex_cnt'][$key] > 0){
						$e_arr[] = $extra_id;
						$extra_qty_arr[$extra_id] = $post['ex_cnt'][$key];
					}					
				}
			}
			if(count($e_arr) > 0){
				$extra_arr = $pjExtraModel->where('t1.status', 'T')
										  ->where('t1.id  IN ('.implode(',',$e_arr).')')
										  ->findAll()
										  ->getData();
			}
	
			$real_rental_days = pjAppController::getRealRentalDays($date_from, $date_to, $this->option_arr);
			foreach ($extra_arr as $key => $val){
				switch ($val['per'])
				{
					case 'day':
						$extra_price +=  $val['price'] * $real_rental_days * $extra_qty_arr[$val['id']];
						break;
					case 'booking':
						$extra_price +=  $val['price'] * $extra_qty_arr[$val['id']];
						break;
				}
			}
			
			$type_arr = $pjTypeModel->find($post['type_id'])->getData();
			if ($type_arr) {
				$price_arr = pjAppController::getPrices($date_from, $date_to, $type_arr, $this->option_arr);
				if($price_arr['price'] == 0)
				{
					$price_arr = pjAppController::getDefaultPrices($date_from, $date_to, $type_arr, $this->option_arr);
				}
				$car_rental_fee = $price_arr['price'];
				$price_per_day = $price_arr['price_per_day'];
		    	$price_per_hour = $price_arr['price_per_hour'];
		    	$price_per_day_detail = $price_arr['price_per_day_detail'];
		    	$price_per_hour_detail = $price_arr['price_per_hour_detail'];
			}
			
	    	$price = $car_rental_fee + $extra_price;
	    	
	    	$insurance_types = __('insurance_type_arr', true, false);
			$insurance = $this->option_arr['o_insurance_payment'];
			$insurance_detail = pjCurrency::formatPriceOnly($this->option_arr['o_insurance_payment']) . ' ' . strtolower($insurance_types['perbooking']);
	    	if($this->option_arr['o_insurance_payment_type'] == 'percent')
			{
				$insurance = ($price * $this->option_arr['o_insurance_payment']) / 100;
				$insurance_detail = $this->option_arr['o_insurance_payment'] . '% ' . __('lblOf', true, false) . ' ' . pjCurrency::formatPriceOnly($price);
			}elseif($this->option_arr['o_insurance_payment_type'] == 'perday'){
				$_rental_days = $rental_days;
				if($hours > 0)
				{
					if($this->option_arr['o_new_day_per_day'] == 0 && $this->option_arr['o_booking_periods'] == 'perday')
					{
						$_rental_days++;
					}
					if($this->option_arr['o_new_day_per_day'] > 0 && $hours > $this->option_arr['o_new_day_per_day']){
					    $_rental_days++;
					}
				}
				$insurance = $_rental_days * $this->option_arr['o_insurance_payment'];
				$insurance_detail = pjCurrency::formatPriceOnly($this->option_arr['o_insurance_payment']) . ' ' . strtolower($insurance_types['perday']);
			}
	    	$sub_total = $car_rental_fee + $extra_price + $insurance;
			
			$tax =  $this->option_arr['o_tax_payment'];
	    	if($this->option_arr['o_tax_type'] == 'percent')
	    	{
	    		$tax = ($sub_total * $this->option_arr['o_tax_payment']) / 100;
	    		$tax_detail = $this->option_arr['o_tax_payment'] . '% ' . __('lblOf', true, false) . ' ' . pjCurrency::formatPrice($sub_total);
	    	}
	    	$total_price = $sub_total + $tax;
	    	    	
	    	$security_deposit  = $this->option_arr['o_security_payment'];
			
			switch ($this->option_arr['o_deposit_type'])
			{
				case 'percent':
					$required_deposit = ($total_price * $this->option_arr['o_deposit_payment']) / 100;
					$required_deposit_detail = $this->option_arr['o_deposit_payment'] . '% ' . __('lblOf', true, false) . ' ' . pjCurrency::formatPrice($total_price);
					break;
				case 'amount':
					$required_deposit = $this->option_arr['o_deposit_payment'];
					$required_deposit_detail = '';
					break;
			}
			
			$total_amount_due = $total_price;
			if($post['status'] == 'confirmed'){
				$total_amount_due = $total_price - $required_deposit;
			}
						
			$price_per_day_label = pjCurrency::formatPrice($price_per_day);
			$price_per_hour_label = pjCurrency::formatPrice($price_per_hour);
			$car_rental_fee_label = pjCurrency::formatPrice($car_rental_fee);
			$extra_price_label = pjCurrency::formatPrice($extra_price);
			$insurance_label = pjCurrency::formatPrice($insurance);
			$sub_total_label = pjCurrency::formatPrice($sub_total);
			$tax_label = pjCurrency::formatPrice($tax);
			$total_price_label = pjCurrency::formatPrice($total_price);
			$security_deposit_label = pjCurrency::formatPrice($security_deposit);
			$required_deposit_label = pjCurrency::formatPrice($required_deposit);
			$total_amount_due_label = pjCurrency::formatPrice($total_amount_due);
			
			if($price_per_day > 0)
			{
				$car_rental_fee_arr[] = $price_per_day_label;
			}
			if($price_per_hour > 0)
			{
				$car_rental_fee_arr[] = $price_per_hour_label;
			}
			$car_rental_fee_detail = join(" + ", $car_rental_fee_arr);
			
			$rental_time = '';
			if($rental_days > 0 || $hours > 0){
				if($rental_days > 0){
					$rental_time .= $rental_days . ' ' . ($rental_days > 1 ? __('plural_day', true, false) : __('singular_day', true, false));
				}
				if($hours > 0){
					$rental_time .= ' ' . $hours . ' ' . ($hours > 1 ? __('plural_hour', true, false) : __('singular_hour', true, false));
				}
			}
			
			pjAppController::jsonResponse(compact('rental_time', 'rental_days', 'hours',
													'price_per_day', 'price_per_hour', 'price_per_day_detail', 'price_per_hour_detail',
													'car_rental_fee', 'extra_price', 'insurance', 'sub_total', 'tax',
			    'total_price', 'required_deposit', 'security_deposit', 'total_amount_due',
													'price_per_day_label', 'price_per_hour_label', 'car_rental_fee_label',
													'extra_price_label', 'insurance_label', 'sub_total_label', 'tax_label',
			    'total_price_label', 'required_deposit_label', 'security_deposit_label', 'total_amount_due_label',
													'car_rental_fee_detail', 'insurance_detail', 'tax_detail', 'required_deposit_detail'));
		
		}
	}
	
	public function pjActionExtraHoursUsage()
	{
		$this->checkLogin();
		$this->setAjax(true);
	
		if ($this->isXHR())
		{
			$post = $this->_post->raw();
			$extra_hours_usage = 0;
			$from_arr = pjUtil::convertDateTime($post['date_to'], $this->option_arr['o_date_format'], $this->option_arr['o_time_format']);
			$to_arr = pjUtil::convertDateTime($post['actual_dropoff_datetime'], $this->option_arr['o_date_format'], $this->option_arr['o_time_format']);
			
			$date_from = $from_arr['iso_date_time'];
			$date_to = $to_arr['iso_date_time'];
			
			$seconds = strtotime($date_to) - strtotime($date_from);
			if($seconds > 0)
			{
				$extra_hours_usage = ceil($seconds / 3600);
			}
			$extra_hours_usage = $extra_hours_usage > 0 ? $extra_hours_usage . ' ' . ($extra_hours_usage > 1 ? __('plural_hour', true, false) : __('singular_hour', true, false)) : __('booking_no', true, false);
			
			pjAppController::jsonResponse(compact('extra_hours_usage'));
		}
	}
	
	public function pjActionExtraMileageCharge()
	{
		$this->checkLogin();
		$this->setAjax(true);
	
		if ($this->isXHR())
		{
			$post = $this->_post->raw();
			$extra_mileage_charge = 0;			
			$type_arr = pjTypeModel::factory()->find($post['type_id'])->getData();
			
			$rental_days = $post['rental_days'];
			$daily_mileage_limit = floatval($type_arr['default_distance']);
			$price_for_extra_mileage = floatval($type_arr['extra_price']);
			
			$actual_mileage = $_em_charge = 0;
			$extra_mileage_charge = 0;
			if(!empty($post['dropoff_mileage']) && !empty($post['pickup_mileage']))
			{
				$actual_mileage = $post['dropoff_mileage'] - $post['pickup_mileage'];
			}
			if($actual_mileage > 0)
			{
				$_em_charge = $actual_mileage - ($rental_days * $daily_mileage_limit);
				if($_em_charge > 0)
				{
					$extra_mileage_charge = $_em_charge * $price_for_extra_mileage;
				}
			}
			$original_extra_mileage_charge = $extra_mileage_charge;
			$_em_charge = $_em_charge . $this->option_arr['o_unit'];
			$extra_mileage_charge = $extra_mileage_charge > 0 ? $_em_charge . ' x ' . pjCurrency::formatPrice($price_for_extra_mileage) . ' = ' .pjCurrency::formatPrice($extra_mileage_charge) : __('booking_no', true, false);
			
			pjAppController::jsonResponse(compact('extra_mileage_charge', 'actual_mileage', 'rental_days', 'daily_mileage_limit', 'price_for_extra_mileage', '_em_charge', 'original_extra_mileage_charge'));
		}
	}
	
	public function pjActionCheckAvailability(){
		$this->checkLogin();
		$this->setAjax(true);
		
		if ($this->isXHR())
		{
			pjAppController::jsonResponse($this->pjActionGetAvailability($this->_post->raw()));
		}
		exit;
	}
	
	public function pjActionGetAvailability($data, $format=true)
	{
		$response = array('code' => 100);
		
		if (isset($data['date_from']) && isset($data['date_to']) && !empty($data['date_from']) && !empty($data['date_to']))
		{
			$from_arr = pjUtil::convertDateTime($data['date_from'], $this->option_arr['o_date_format'], $this->option_arr['o_time_format']);
			$to_arr = pjUtil::convertDateTime($data['date_to'], $this->option_arr['o_date_format'], $this->option_arr['o_time_format']);
			
			$date_from = $from_arr['iso_date_time'];
			$date_to = $to_arr['iso_date_time'];
			
			$date_from_ts = strtotime($date_from);
			$date_to_ts = strtotime($date_to);
			
		
			if($date_to_ts <= $date_from_ts){
				$response = array('code' => 100);
			}else{
				if (isset($data['type_id']) && (int) $data['type_id'] > 0 && isset($data['car_id']) && (int) $data['car_id'] > 0 )
				{
					$type_arr = pjTypeModel::factory()->find($data['type_id'])->getData();
					
					$min_hour = $this->option_arr['o_min_hour'];
					if($this->option_arr['o_booking_periods'] == 'perday'){
						$min_hour = $this->option_arr['o_min_hour'] * 24;
					}
					if( round($date_to_ts - $date_from_ts)/3600 < $min_hour){
						$response['code'] = 100;
						return $response;
					}
					
					$current_datetime = date('Y-m-d H:i:s', time() - ($this->option_arr['o_booking_pending'] * 3600));
					$pjBookingModel = pjBookingModel::factory()
						->where('t1.type_id', $data['type_id'])
						->where('t1.car_id', $data['car_id'])
						->where("(`status` = 'confirmed' OR `status` = 'collected' OR (`status` = 'pending' AND `created` >= '$current_datetime'))")
						->where(sprintf("(((`from` BETWEEN '%1\$s' AND '%2\$s') OR (`to` BETWEEN '%1\$s' AND '%2\$s')) OR (`from` < '%1\$s' AND `to` > '%2\$s') OR (`from` > '%1\$s' AND `to` < '%2\$s'))",$date_from, $date_to))
					;
					if (isset($data['id']) && (int) $data['id'])
					{
						$pjBookingModel->where('t1.id !=', $data['id']);
					}
					
					$booking_cnt = $pjBookingModel->findCount()->getData();
					
					if ($booking_cnt == 0)
					{
						$response['code'] = 200;
					}
				}else{
					$response['code'] = 300;
				}
			}
		}
		return $response;
	}
	
	public function pjActionGetCarMileage(){
		$this->checkLogin();
		$this->setAjax(true);
	
		if ($this->isXHR())
		{
			$mileage = 0;;
			if ($this->_get->check('car_id') && (int) $this->_get->toInt('car_id') > 0) {
				$arr = pjCarModel::factory()->find($this->_get->toInt('car_id'))->getData();
				$mileage = $arr['mileage'];
			}
			echo $mileage;
			exit;
		}
	}
	
	public function pjActionGetCarMileageMsg(){
		$this->checkLogin();
		$this->setAjax(true);
	
		if ($this->isXHR())
		{
			$arr = array();
			if ($this->_get->check('car_id') && (int) $this->_get->toInt('car_id') > 0) {
				$arr = pjCarModel::factory()
					->select('t1.*, t2.content AS make, t3.content AS model')
					->join('pjMultiLang', "t2.model='pjCar' AND t2.foreign_id=t1.id AND t2.field='make' AND t2.locale='".$this->getLocaleId()."'", 'left')
					->join('pjMultiLang', "t3.model='pjCar' AND t3.foreign_id=t1.id AND t3.field='model' AND t3.locale='".$this->getLocaleId()."'", 'left')
					->find($this->_get->toInt('car_id'))->getData();			
				$arr = pjSanitize::clean($arr);
			}
			$this->set('arr', $arr);
		}
	}
	
	public function pjActionUpdateCarMileague(){
		$this->checkLogin();
		$this->setAjax(true);
	
		if ($this->isXHR())
		{
			if ($this->_post->check('car_id') && (int) $this->_post->toInt('car_id') > 0) {
				pjCarModel::factory()->where('id', $this->_post->toInt('car_id'))->limit(1)->modifyAll($this->_post->raw());
			}
		}
		pjAppController::jsonResponse(array('status' => 'OK'));
	}
	
	public function pjActionFormatBalance(){
		$this->checkLogin();
		$this->setAjax(true);
	
		if ($this->isXHR())
		{
			$balance = 0;
			if ($this->_get->check('balance')) {
				$balance = (float)$this->_post->toString('balance');
			}
			echo pjCurrency::formatPrice($balance);
			exit;
		}
	}
	
	public function pjActionDeletePayment(){
		$this->checkLogin();
		$this->setAjax(true);
			
		if ($this->isXHR())
		{
			if ($this->_post->check('id') && (int) $this->_post->toInt('id') > 0) 
			{
				pjBookingPaymentModel::factory()->reset()->setAttributes(array('id' => $this->_post->toInt('id')))->erase();
			}
			pjAppController::jsonResponse(array('status' => 'OK'));
		}
	}
}
?>