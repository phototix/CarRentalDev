<?php
if (!defined("ROOT_PATH"))
{
	header("HTTP/1.1 403 Forbidden");
	exit;
}
class pjAdminCars extends pjAdmin
{
	public function pjActionCheckRegistrationNumber()
	{
		$this->setAjax(true);
		
		if ($this->isXHR() && $this->isLoged())
		{
			if (!$this->_get->check('registration_number') || $this->_get->toString('registration_number') == '')
			{
				echo 'false';
				exit;
			}
			$pjCarModel = pjCarModel::factory();
			if ($this->_get->check('id') && $this->_get->toInt('id') > 0)
			{
				$pjCarModel->where('t1.id !=', $this->_get->toInt('id'));
			}
			echo $pjCarModel->where('t1.registration_number', $this->_get->toString('registration_number'))->findCount()->getData() == 0 ? 'true' : 'false';
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
		
		$this->set('location_arr', pjLocationModel::factory()
			->select('t1.*, t2.content AS `name`')
			->join('pjMultiLang', "t2.model='pjLocation' AND t2.foreign_id=t1.id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left outer')
			->where('t1.status', 'T')
			->orderBy('t2.content ASC')
			->findAll()
			->getData()
		);
		
		$this->set('type_arr', pjTypeModel::factory()
			->select('t1.*, t2.content AS `name`')
			->join('pjMultiLang', "t2.model='pjType' AND t2.foreign_id=t1.id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left outer')
			->where('t1.status', 'T')
			->orderBy('t2.content ASC')
			->findAll()
			->getData()
		);
		
		$locale_arr = pjLocaleModel::factory()->select('t1.*, t2.file')
			->join('pjLocaleLanguage', 't2.iso=t1.language_iso', 'left')
			->where('t2.file IS NOT NULL')
			->orderBy('t1.sort ASC')->findAll()->getData();
		
		$lp_arr = array();
		foreach ($locale_arr as $item)
		{
			$lp_arr[$item['id']."_"] = $item['file'];
		}
		$this->set('lp_arr', $locale_arr);
		$this->set('locale_str', pjAppController::jsonEncode($lp_arr));

		$this->set('is_flag_ready', $this->requestAction(array('controller' => 'pjLocale', 'action' => 'pjActionIsFlagReady'), array('return')));
		
		$this->appendCss('jasny-bootstrap.min.css', PJ_THIRD_PARTY_PATH . 'jasny/');
		$this->appendJs('jasny-bootstrap.min.js', PJ_THIRD_PARTY_PATH . 'jasny/');
		$this->appendCss('css/select2.min.css', PJ_THIRD_PARTY_PATH . 'select2/');
		$this->appendJs('js/select2.full.min.js', PJ_THIRD_PARTY_PATH . 'select2/');
		$this->appendJs('jquery.multilang.js', PJ_FRAMEWORK_LIBS_PATH . 'pj/js/');
		$this->appendJs('jquery.datagrid.js', PJ_FRAMEWORK_LIBS_PATH . 'pj/js/');
		$this->appendJs('pjAdminCars.js');
	}
	
	public function pjActionGet()
	{
		$this->setAjax(true);
	
		if (!$this->isXHR())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
		}
		
		$pjCarModel = pjCarModel::factory()
			->join('pjMultiLang', "t2.model='pjCar' AND t2.foreign_id=t1.id AND t2.field='make' AND t2.locale='".$this->getLocaleId()."'", 'left outer')
			->join('pjMultiLang', "t3.model='pjCar' AND t3.foreign_id=t1.id AND t3.field='model' AND t3.locale='".$this->getLocaleId()."'", 'left outer')
			->join('pjMultiLang', "t4.foreign_id = t1.location_id AND t4.model = 'pjLocation' AND t4.locale = '".$this->getLocaleId()."' AND t4.field = 'name'", 'left');
			
		if ($q = $this->_get->toString('q'))
		{
			$q = str_replace(array('_', '%'), array('\_', '\%'), $pjCarModel->escapeStr($q));
			$pjCarModel->where('(t2.content LIKE "%'.$q.'%" OR t3.content LIKE "%'.$q.'%" OR t4.content LIKE "%'.$q.'%" OR t1.registration_number LIKE "%'.$q.'%")');
		}
		if ($this->_get->toString('status') && in_array($this->_get->toString('status'), array('T', 'F')))
		{
			$pjCarModel->where('t1.status', $this->_get->toString('status'));
		}
		if ($this->_get->check('type_id') && $this->_get->toInt('type_id') > 0)
		{
			$pjCarModel->where(sprintf(" t1.id IN (SELECT `car_id` FROM `%s` WHERE `type_id` = '%u')", pjCarTypeModel::factory()->getTable(), $this->_get->toInt('type_id')));
		}
		$column = 'make';
		$direction = 'ASC';
		if ($this->_get->toString('column') && in_array(strtoupper($this->_get->toString('direction')), array('ASC', 'DESC')))
		{
			$column = $this->_get->toString('column');
			$direction = strtoupper($this->_get->toString('direction'));
		}

		$total = $pjCarModel->findCount()->getData();
		$rowCount = $this->_get->toInt('rowCount') ? $this->_get->toInt('rowCount') : 10;
		$pages = ceil($total / $rowCount);
		$page = $this->_get->toInt('page') ? $this->_get->toInt('page') : 1;
		$offset = ((int) $page - 1) * $rowCount;
		if ($page > $pages)
		{
			$page = $pages;
		}
		$sub_query = "(SELECT GROUP_CONCAT(TML.content SEPARATOR '~::~') FROM " . pjCarTypeModel::factory()->getTable() . " AS TCT
							LEFT OUTER JOIN " . pjMultiLangModel::factory()->getTable() . " AS TML ON TML.model='pjType' AND TML.foreign_id=TCT.type_id AND TML.field='name' AND TML.locale='".$this->getLocaleId()."'
							WHERE TCT.car_id=t1.id) as car_types";
		$data = $pjCarModel
		->select('t1.*, t2.content AS make, t3.content AS model, t4.content AS location_name, '.$sub_query)
		->orderBy("$column $direction")
		->limit($rowCount, $offset)
		->findAll()
		->getData();
		$data = pjSanitize::clean($data);
		self::jsonResponse(compact('data', 'total', 'pages', 'page', 'rowCount', 'column', 'direction'));
	}
	
	public function pjActionAddCar()
	{
		$this->setAjax(true);
		if (!$this->isXHR())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
		}
		if (!self::isPost())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 101, 'text' => 'HTTP method not allowed.'));
		}
		
		if ($this->_post->check('add_car'))
		{
			$post = $this->_post->raw();
			$data = array();
			$car_id = pjCarModel::factory(array_merge($post, $data))->insert()->getInsertId();
			if ($car_id !== false && (int) $car_id > 0)
			{
				if ($this->_post->toArray('type_id') && $this->_post->toArray('type_id') != '')
				{
					$pjCarTypeModel = pjCarTypeModel::factory()->setBatchFields(array('car_id', 'type_id'));
					foreach ($this->_post->toArray('type_id') as $type_id)
					{
						$pjCarTypeModel->addBatchRow(array($car_id, $type_id));
					}
					$pjCarTypeModel->insertBatch();
				}
				
				$i18n_arr = $this->_post->toI18n('i18n');
				if (!empty($i18n_arr))
				{
					pjMultiLangModel::factory()->saveMultiLang($i18n_arr, $car_id, 'pjCar');
				}
				self::jsonResponse(array('status' => 'OK', 'code' => 200, 'text' => ''));
			}
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => ''));
		}
	}
	
	public function pjActionDelete()
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
		if (pjCarModel::factory()->set('id', $this->_get->toInt('id'))->erase()->getAffectedRows() == 1)
		{
			pjMultiLangModel::factory()->where('model', 'pjCar')->where('foreign_id', $this->_get->toInt('id'))->eraseAll();
			pjCarTypeModel::factory()->where('car_id', $this->_get->toInt('id'))->eraseAll();
			$response = array('status' => 'OK');
		} else {
			$response = array('status' => 'ERR');
		}
		
		self::jsonResponse($response);
	}
	
	public function pjActionDeleteBulk()
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

		if (!$this->_post->has('record') || !($record = $this->_post->toArray('record')))
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 102, 'text' => 'Missing, empty or invalid data.'));
		}
		if (pjCarModel::factory()->whereIn('id', $record)->eraseAll()->getAffectedRows() > 0)
		{
			pjMultiLangModel::factory()->where('model', 'pjCar')->whereIn('foreign_id', $record)->eraseAll();
			pjCarTypeModel::factory()->whereIn('car_id', $record)->eraseAll();
			self::jsonResponse(array('status' => 'OK'));
		}
		
		self::jsonResponse(array('status' => 'ERR'));
	}
	
	public function pjActionCreate()
	{
		$this->setAjax(true);
	
		if (!$this->isXHR())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
		}
		
		if (self::isGet())
		{
			$this->set('location_arr', pjLocationModel::factory()
				->select('t1.*, t2.content AS `name`')
				->join('pjMultiLang', "t2.model='pjLocation' AND t2.foreign_id=t1.id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left outer')
				->where('t1.status', 'T')
				->orderBy('t2.content ASC')
				->findAll()
				->getData()
			);
			
			$this->set('type_arr', pjTypeModel::factory()
				->select('t1.*, t2.content AS `name`')
				->join('pjMultiLang', "t2.model='pjType' AND t2.foreign_id=t1.id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left outer')
				->where('t1.status', 'T')
				->orderBy('t2.content ASC')
				->findAll()
				->getData()
			);
			
			$locale_arr = pjLocaleModel::factory()->select('t1.*, t2.file')
			->join('pjLocaleLanguage', 't2.iso=t1.language_iso', 'left')
			->where('t2.file IS NOT NULL')
			->orderBy('t1.sort ASC')->findAll()->getData();
				
			$lp_arr = array();
			foreach ($locale_arr as $item)
			{
				$lp_arr[$item['id']."_"] = $item['file'];
			}
			$this->set('lp_arr', $locale_arr);
			$this->set('locale_str', self::jsonEncode($lp_arr));
	
			$this->set('is_flag_ready', $this->requestAction(array('controller' => 'pjLocale', 'action' => 'pjActionIsFlagReady'), array('return')));
		}
	}
	
	public function pjActionUpdate()
	{
		$this->setAjax(true);
	
		if (!$this->isXHR())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
		}

		if (self::isPost() && $this->_post->check('update_car'))
		{
			$pjCarModel = pjCarModel::factory();
			$arr = $pjCarModel->find($this->_post->toInt('id'))->getData();
			$data = array();
			if ($arr) {
				$car_id = $this->_post->toInt('id');
				$pjCarModel->reset()->set('id', $car_id)->modify(array_merge($this->_post->raw(), $data));
				$i18n_arr = $this->_post->toI18n('i18n');
				if (!empty($i18n_arr))
				{
					pjMultiLangModel::factory()->updateMultiLang($i18n_arr, $car_id, 'pjCar');
				}
			} else {
				$car_id = $pjCarModel->reset()->setAttributes(array_merge($this->_post->raw(), $data))->insert()->getInsertId();
				$i18n_arr = $this->_post->toI18n('i18n');
				if (!empty($i18n_arr))
				{
					pjMultiLangModel::factory()->saveMultiLang($i18n_arr, $car_id, 'pjCar');
				}
			}
			if ($car_id !== false && (int)$car_id > 0) {
				$pjCarTypeModel = pjCarTypeModel::factory();
				$pjCarTypeModel->where('car_id', $car_id)->eraseAll();
				if ($this->_post->toArray('type_id') && $this->_post->toArray('type_id') != '')
				{
					$pjCarTypeModel->reset()->setBatchFields(array('car_id', 'type_id'));
					foreach ($this->_post->toArray('type_id') as $type_id)
					{
						$pjCarTypeModel->addBatchRow(array($car_id, $type_id));
					}
					$pjCarTypeModel->insertBatch();
				}
			}
			
			self::jsonResponse(array('status' => 'OK'));
		}
		
		if (self::isGet())
		{
			$arr = pjCarModel::factory()->find($this->_get->toInt('id'))->getData();
			$arr['i18n'] = pjMultiLangModel::factory()->getMultiLang($arr['id'], 'pjCar');
			$this->set('arr', $arr);
			$this->set('car_type_id_arr', pjCarTypeModel::factory()->where('t1.car_id', $arr['id'])->findAll()->getDataPair(null, 'type_id'));
			
			$this->set('location_arr', pjLocationModel::factory()
				->select('t1.*, t2.content AS `name`')
				->join('pjMultiLang', "t2.model='pjLocation' AND t2.foreign_id=t1.id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left outer')
				->where('t1.status', 'T')
				->orderBy('t2.content ASC')
				->findAll()
				->getData()
			);
			
			$this->set('type_arr', pjTypeModel::factory()
				->select('t1.*, t2.content AS `name`')
				->join('pjMultiLang', "t2.model='pjType' AND t2.foreign_id=t1.id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left outer')
				->where('t1.status', 'T')
				->orderBy('t2.content ASC')
				->findAll()
				->getData()
			);
			
			$locale_arr = pjLocaleModel::factory()->select('t1.*, t2.file')
				->join('pjLocaleLanguage', 't2.iso=t1.language_iso', 'left')
				->where('t2.file IS NOT NULL')
				->orderBy('t1.sort ASC')->findAll()->getData();
			
			$lp_arr = array();
			foreach ($locale_arr as $item)
			{
				$lp_arr[$item['id']."_"] = $item['file'];
			}
			$this->set('lp_arr', $locale_arr);
			$this->set('locale_str', self::jsonEncode($lp_arr));
	
			$this->set('is_flag_ready', $this->requestAction(array('controller' => 'pjLocale', 'action' => 'pjActionIsFlagReady'), array('return')));
		}
	}
	
	public function pjActionSave()
	{
		$this->setAjax(true);
	
		if (!$this->isXHR())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
		}
		
		if (!self::isPost())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 102, 'text' => 'HTTP method not allowed.'));
		}
		
		$params = array(
				'id' => $this->_get->toInt('id'),
				'column' => $this->_post->toString('column'),
				'value' => $this->_post->toString('value'),
		);
		if (!(isset($params['id'], $params['column'], $params['value'])
				&& pjValidation::pjActionNumeric($params['id'])
				&& pjValidation::pjActionNotEmpty($params['column'])))
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 102, 'text' => 'Missing, empty or invalid parameters.'));
		}
		
		$pjCarModel = pjCarModel::factory();
		if (!in_array($params['column'], $pjCarModel->getI18n()))
		{
			$pjCarModel->where('id', $params['id'])->limit(1)->modifyAll(array($params['column'] => $params['value']));
		} else {
			pjMultiLangModel::factory()->updateMultiLang(array($this->getLocaleId() => array($params['column'] => $params['value'])), $params['id'], 'pjCar');
		}
		
		self::jsonResponse(array('status' => 'OK', 'code' => 200));
	}
	
	public function pjActionAvailability()
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
		
		$pjCarModel = pjCarModel::factory()
		->join('pjMultiLang', "t2.foreign_id = t1.id AND t2.model = 'pjCar' AND t2.locale = '".$this->getLocaleId()."' AND t2.field = 'model'", 'left')
		->join('pjMultiLang', "t3.foreign_id = t1.id AND t3.model = 'pjCar' AND t3.locale = '".$this->getLocaleId()."' AND t3.field = 'make'", 'left');
		
		$sub_query = sprintf("(SELECT GROUP_CONCAT(TML.content SEPARATOR '~::~') FROM `%s` AS TCT
							LEFT OUTER JOIN `%s` AS TML ON TML.model='pjType' AND TML.foreign_id=TCT.type_id AND TML.field='name' AND TML.locale='%s'
							WHERE TCT.car_id=t1.id) as car_types", pjCarTypeModel::factory()->getTable(), pjMultiLangModel::factory()->getTable(), $this->getLocaleId());
						
		$car_arr = $pjCarModel	->select("t1.*, CONCAT(t3.content, ' ', t2.content)  as car_name, $sub_query")
								->orderBy("car_name ASC")->findAll()->getData();
		$this->set('car_arr', $car_arr);
		
		$this->appendCss('datepicker3.css', PJ_THIRD_PARTY_PATH . 'bootstrap_datepicker/');
		$this->appendJs('bootstrap-datepicker.js', PJ_THIRD_PARTY_PATH . 'bootstrap_datepicker/');
			
		$this->appendCss('css/select2.min.css', PJ_THIRD_PARTY_PATH . 'select2/');
		$this->appendJs('js/select2.full.min.js', PJ_THIRD_PARTY_PATH . 'select2/');
		$this->appendJs('pjAdminCars.js');
		$this->appendJs('tableHeadFixer.js');
	}
	public function pjActionGetFilterCars()
	{
	    $this->setAjax(true);
	    
	    if ($this->isXHR())
	    {
	        $pjCarModel = pjCarModel::factory()
	        ->join('pjMultiLang', "t2.foreign_id = t1.id AND t2.model = 'pjCar' AND t2.locale = '".$this->getLocaleId()."' AND t2.field = 'model'", 'left')
	        ->join('pjMultiLang', "t3.foreign_id = t1.id AND t3.model = 'pjCar' AND t3.locale = '".$this->getLocaleId()."' AND t3.field = 'make'", 'left');
	        
	        $sub_query = sprintf("(SELECT GROUP_CONCAT(TML.content SEPARATOR '~::~') FROM `%s` AS TCT
							LEFT OUTER JOIN `%s` AS TML ON TML.model='pjType' AND TML.foreign_id=TCT.type_id AND TML.field='name' AND TML.locale='%s'
							WHERE TCT.car_id=t1.id) as car_types", pjCarTypeModel::factory()->getTable(), pjMultiLangModel::factory()->getTable(), $this->getLocaleId());
	        if ($this->_get->toInt('type_id') > 0)
	        {
	            $sub_query = sprintf("(SELECT GROUP_CONCAT(TML.content SEPARATOR '~::~') FROM `%s` AS TCT
                        			LEFT OUTER JOIN `%s` AS TML ON TML.model='pjType' AND TML.foreign_id=TCT.type_id AND TML.field='name' AND TML.locale='%s'
                        			WHERE TCT.car_id=t1.id AND TCT.type_id=%u) as car_types", pjCarTypeModel::factory()->getTable(), pjMultiLangModel::factory()->getTable(), $this->getLocaleId(), $this->_get->toInt('type_id'));
	            
	            $pjCarModel->where("(t1.id IN(SELECT TCT.car_id FROM `".pjCarTypeModel::factory()->getTable()."` AS TCT WHERE TCT.type_id = '".$this->_get->toInt('type_id')."'))");
	        }
	        $car_arr = $pjCarModel	->select("t1.*, CONCAT(t3.content, ' ', t2.content)  as car_name, $sub_query")
	        ->orderBy("car_name ASC")->findAll()->getData();
	        $this->set('car_arr', $car_arr);
	    
	    }
	}
	public function pjActionLoadAvailability()
	{
		$this->setAjax(true);
		
		if ($this->isXHR())
		{
			$pjBookingModel = pjBookingModel::factory();
			
			$post = $this->_post->raw();
			$date_from = isset($post['date_from']) ? pjDateTime::formatDate($post['date_from'], $this->option_arr['o_date_format']) . ' 00:00:00' : date('Y-m-d') . ' 00:00:00';
			$date_to = isset($post['date_to']) ? pjDateTime::formatDate($post['date_to'], $this->option_arr['o_date_format']) . ' 23:59:59' : date('Y-m-d', strtotime(date('Y-m-d') . ' +7 days')) . ' 23:59:59' ;
			
			$min_date = isset($post['date_from']) ? pjDateTime::formatDate($post['date_from'], $this->option_arr['o_date_format']) : date('Y-m-d');
			$max_date = isset($post['date_to']) ? pjDateTime::formatDate($post['date_to'], $this->option_arr['o_date_format']) : date('Y-m-d', strtotime(date('Y-m-d') . ' +7 days'));
			
			$pjBookingModel->where('`from` <=', $date_to);
			$pjBookingModel->where('`to` >=', $date_from);
			
			if (isset($post['car_type']) && (int) $post['car_type'] > 0)
			{
				$pjBookingModel->where('t1.type_id', $post['car_type']);
			}
			if (isset($post['car_id']) && is_array($post['car_id']))
			{
				$pjBookingModel->whereIn('t1.car_id', $post['car_id']);
			}
			$data = $pjBookingModel->join('pjCar', 't2.id=t1.car_id')
							->join('pjMultiLang', "t3.foreign_id = t2.id AND t3.model = 'pjCar' AND t3.locale = '".$this->getLocaleId()."' AND t3.field = 'model'", 'left')
							->join('pjType', "t4.id = t1.type_id", 'left')
							->join('pjMultiLang', "t5.foreign_id = t4.id AND t5.model = 'pjType' AND t5.locale = '".$this->getLocaleId()."' AND t5.field = 'name'", 'left')
							->join('pjMultiLang', "t6.foreign_id = t1.pickup_id AND t6.model = 'pjLocation' AND t6.locale = '".$this->getLocaleId()."' AND t6.field = 'name'", 'left')
							->join('pjMultiLang', "t7.foreign_id = t1.return_id AND t7.model = 'pjLocation' AND t7.locale = '".$this->getLocaleId()."' AND t7.field = 'name'", 'left')
							->join('pjMultiLang', "t8.model='pjCar' AND t8.foreign_id=t1.car_id AND t8.field='make' AND t8.locale='".$this->getLocaleId()."'", 'left')
							->where('t1.status', 'confirmed')->orWhere('t1.status', 'pending')->orWhere('t1.status', 'collected')
							->select("t1.id, t1.type_id, t1.car_id,t1.from, t1.to, t1.status, t1.c_name, t1.created, t3.content as model , t2.registration_number,
										t5.content as type, t6.content as pickup_location, t7.content as return_location, t8.content as make")
							->orderBy("`from` ASC")->findAll()->getData();
							
			$booking_arr = array();
			foreach ($data as $key => $val){
				$val['pick_drop'] = date($this->option_arr['o_date_format'], strtotime($val['from'])).', '.date($this->option_arr['o_time_format'], strtotime($val['from'])) . ' ' . __('booking_at', true, false) . ' ' . $val['pickup_location'] . "<br/>";
				$val['pick_drop'] .= date($this->option_arr['o_date_format'], strtotime($val['to'])) .', '. date($this->option_arr['o_time_format'], strtotime($val['to'])) . ' ' . __('booking_at', true, false) . ' ' . $val['return_location'];
				$val['car_info'] = $val['registration_number'] . ',<br/>' . $val['make'] . " " . $val['model'];
				$booking_arr[$val['car_id']][] = $val;
			}
				
			$pjCarModel = pjCarModel::factory()
			->join('pjMultiLang', "t2.foreign_id = t1.id AND t2.model = 'pjCar' AND t2.locale = '".$this->getLocaleId()."' AND t2.field = 'model'", 'left')
			->join('pjMultiLang', "t3.foreign_id = t1.id AND t3.model = 'pjCar' AND t3.locale = '".$this->getLocaleId()."' AND t3.field = 'make'", 'left');
			$sub_query = sprintf("(SELECT GROUP_CONCAT(TML.content SEPARATOR '~::~') FROM `%s` AS TCT
                        			LEFT OUTER JOIN `%s` AS TML ON TML.model='pjType' AND TML.foreign_id=TCT.type_id AND TML.field='name' AND TML.locale='%s'
                        			WHERE TCT.car_id=t1.id) as car_types", pjCarTypeModel::factory()->getTable(), pjMultiLangModel::factory()->getTable(), $this->getLocaleId());
			if (isset($post['car_id']) && is_array($post['car_id']))
			{
				$pjCarModel->whereIn('t1.id', $post['car_id']);
			}
			if (isset($post['car_type']) && (int) $post['car_type'] > 0)
			{
			    $sub_query = sprintf("(SELECT GROUP_CONCAT(TML.content SEPARATOR '~::~') FROM `%s` AS TCT
                        			LEFT OUTER JOIN `%s` AS TML ON TML.model='pjType' AND TML.foreign_id=TCT.type_id AND TML.field='name' AND TML.locale='%s'
                        			WHERE TCT.car_id=t1.id AND TCT.type_id=%u) as car_types", pjCarTypeModel::factory()->getTable(), pjMultiLangModel::factory()->getTable(), $this->getLocaleId(), $post['car_type']);
			    
				$pjCarModel->where("(t1.id IN(SELECT TCT.car_id FROM `".pjCarTypeModel::factory()->getTable()."` AS TCT WHERE TCT.type_id = '".$post['car_type']."'))");
			}
			$car_arr = $pjCarModel	
			->select("t1.*, CONCAT(t3.content, ' ', t2.content)  as car_name, $sub_query")
			->orderBy("car_name ASC")->findAll()->getData();
							
			$this->set('car_arr', $car_arr);
			$allow_update_booking = pjAuth::factory('pjAdminBookings', 'pjActionUpdate')->hasAccess();
			$avail_arr = array();
			foreach($car_arr as $v)
			{
				$run_date = $min_date;
				$car_booking_arr = array();
				if(isset($booking_arr[$v['id']]))
				{
					$car_booking_arr = $booking_arr[$v['id']];
				}
				while(strtotime($run_date) <= strtotime($max_date))
				{
					$cell_content = array();
					if(!empty($car_booking_arr))
					{
						foreach($car_booking_arr as $booking)
						{
							$_from = date('Y-m-d', strtotime($booking['from']));
							$_to = date('Y-m-d', strtotime($booking['to']));
							
							if($booking['status'] == 'pending')
							{
								if( (strtotime($booking['created']) + ($this->option_arr['o_booking_pending'] * 3600)) < time() )
								{
									$booking['status'] = 'pending-over';
								}
							}else if($booking['status'] == 'collected'){
								$booking['status'] = 'confirmed';
							}
							$url = 'javascript:void(0)';
							if ($allow_update_booking) {
								$url = $_SERVER['PHP_SELF'].'?controller=pjAdminBookings&action=pjActionUpdate&id='.$booking['id'];
							}
							if($run_date == $_from && $run_date == $_to)
							{
								$cell_content[] = '<div class="pj-booking-block pj-booking-'.$booking['status'].'"><a href="'. $url.'">'.pjSanitize::html($booking['c_name']).'</a><label>'.__('lblPickupAt', true, false).': <span>'.date('H:i', strtotime($booking['from'])).'</span></label><label class="pj-from">'.strtolower(__('lblFrom', true, false)).': <span>'.$booking['pickup_location'].'</span></label><label class="pj-dropoff">'.__('lblReturnAt', true, false).': <span>'.date('H:i', strtotime($booking['to'])).'</span></label><label class="pj-from">'.strtolower(__('lblAt', true, false)).': <span>'.$booking['return_location'].'</span></label></div>';
							}else if($run_date == $_from){
								$cell_content[] = '<div class="pj-booking-block pj-booking-'.$booking['status'].'"><a href="'. $url.'">'.pjSanitize::html($booking['c_name']).'</a><label>'.__('lblPickupAt', true, false).': <span>'.date('H:i', strtotime($booking['from'])).'</span></label class="pj-from"><label class="pj-from">'.strtolower(__('lblFrom', true, false)).': <span>'.$booking['pickup_location'].'</span></label></div>';
							}else if($run_date == $_to){
								$cell_content[] = '<div class="pj-booking-block pj-booking-'.$booking['status'].'"><label class="pj-dropoff">'.__('lblReturnAt', true, false).': <span>'.date('H:i', strtotime($booking['to'])).'</span></label><label class="pj-from">'.strtolower(__('lblAt', true, false)).': <span>'.$booking['return_location'].'</span></label></div>';
							}else if(strtotime($run_date) > strtotime($_from) && strtotime($run_date) < strtotime($_to)){
								$cell_content[] = '<div class="pj-booking-block pj-booking-middle pj-booking-'.$booking['status'].'" data-status="'.$booking['status'].'">&nbsp;</div>';
							}
						}
					}
					
					$avail_arr[$v['id']][$run_date] = $cell_content;
					$run_date = date('Y-m-d', strtotime($run_date . ' +1 day'));
				}
			}
			
			$this->set('min_date', $min_date);
			$this->set('max_date', $max_date);
			$this->set('avail_arr', $avail_arr);
		}
	}
}
?>