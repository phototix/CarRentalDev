<?php
if (!defined("ROOT_PATH"))
{
	header("HTTP/1.1 403 Forbidden");
	exit;
}
class pjAdminLocations extends pjAdmin
{
	public function pjActionCreate()
	{
		$this->checkLogin();
		
		if (!pjAuth::factory()->hasAccess())
		{
			$this->sendForbidden();
			return;
		}
		
		$post_max_size = pjUtil::getPostMaxSize();
		if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_SERVER['CONTENT_LENGTH']) && (int) $_SERVER['CONTENT_LENGTH'] > $post_max_size)
		{
			pjUtil::redirect($_SERVER['PHP_SELF'] . "?controller=pjAdminLocations&action=pjActionIndex&err=AL12");
		}
		
		if (self::isPost() && $this->_post->toInt('action_create'))
		{
			$err = 'AL03';

			$data = array();
			$post = $this->_post->raw();
			$data['status'] = $this->_post->check('status') ? 'T' : 'F';
			$data['notify_email'] = $this->_post->check('notify_email') ? 'T' : 'F';
			$data['address_1'] = $post['address_content'];
			$id = pjLocationModel::factory(array_merge($data, $post))->insert()->getInsertId();
			if ($id !== false && (int) $id > 0)
			{
				pjWorkingTimeModel::factory()->init($id);
				
				$i18n_arr = $this->_post->toI18n('i18n');
				if (!empty($i18n_arr))
				{
					pjMultiLangModel::factory()->saveMultiLang($i18n_arr, $id, 'pjLocation');
				}
				
				if (isset($_FILES['thumb']))
				{
					if($_FILES['thumb']['error'] == 0)
					{
						$size = getimagesize($_FILES['thumb']['tmp_name']);
						if($size == true)
						{
							$pjImage = new pjImage();
							$pjImage->setAllowedExt($this->extensions)->setAllowedTypes($this->mimeTypes);
							if ($pjImage->load($_FILES['thumb']))
							{
								$dst = PJ_UPLOAD_PATH . 'locations/' . md5($id . PJ_SALT) . ".jpg";
								$pjImage
								->loadImage()
								->resizeSmart(130, 98)
								->saveImage($dst);
				
								pjLocationModel::factory()->reset()->set('id', $id)->modify(array('thumb' => $dst));
							}
						}else{
							$err = 'AL14';
						}
					}else if($_FILES['thumb']['error'] != 4){
						$err = 'AL13';
					}
				}
			} else {
				$err = 'AL04';
			}
			pjUtil::redirect($_SERVER['PHP_SELF'] . "?controller=pjAdminLocations&action=pjActionIndex&err=$err");
		} 
		
		if (self::isGet())
		{
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
			
			$country_arr = pjBaseCountryModel::factory()->select('t1.*, t2.content AS name')
				->join('pjMultiLang', "t2.model='pjBaseCountry' AND t2.foreign_id=t1.id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left outer')
				->where('status', 'T')->orderBy('name ASC')->findAll()->getData();
			$this->set('country_arr', pjSanitize::clean($country_arr));
			
			$api_key_str = isset($this->option_arr['o_google_maps_api_key']) && !empty($this->option_arr['o_google_maps_api_key']) ? 'key=' . $this->option_arr['o_google_maps_api_key'] . '&' : '';
			$this->appendJs('', 'https://maps.google.com/maps/api/js?'.$api_key_str.'libraries=places&region=uk&language=en', true);
			
			$this->appendCss('jasny-bootstrap.min.css', PJ_THIRD_PARTY_PATH . 'jasny/');
			$this->appendJs('jasny-bootstrap.min.js', PJ_THIRD_PARTY_PATH . 'jasny/');
			
			$this->appendCss('css/select2.min.css', PJ_THIRD_PARTY_PATH . 'select2/');
			$this->appendJs('js/select2.full.min.js', PJ_THIRD_PARTY_PATH . 'select2/');
			
			$this->appendJs('jquery.multilang.js', PJ_FRAMEWORK_LIBS_PATH . 'pj/js/');
			$this->appendJs('jquery.validate.min.js', PJ_THIRD_PARTY_PATH . 'validate/');
			$this->appendJs('additional-methods.js', PJ_THIRD_PARTY_PATH . 'validate/');
			$this->appendJs('pjAdminLocations.js');
		}
	}
	
	public function pjActionDeleteImage()
	{
		$this->setAjax(true);
	
		if (!$this->isXHR())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
		}
	
		if (!self::isPost())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'HTTP method not allowed.'));
		}
	
		if ($this->_post->check('id') && $this->_post->toInt('id'))
		{
			$pjLocationModel = pjLocationModel::factory();
			$arr = $pjLocationModel->find($this->_post->toInt('id'))->getData();
			if (!empty($arr))
			{
				$pjLocationModel->reset()->set('id', $arr['id'])->modify(array('thumb' => ':NULL'));
	
				@clearstatcache();
				if (!empty($arr['thumb']) && is_file($arr['thumb']))
				{
					@unlink($arr['thumb']);
				}
	
				self::jsonResponse(array('status' => 'OK', 'code' => 200, 'text' => ''));
			}
		}
		self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => ''));
	}
	
	public function pjActionDelete()
	{
		$this->setAjax(true);
	
		if (!$this->isXHR())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
		}
		
		if (!self::isPost())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'HTTP method not allowed.'));
		}

		if ($this->_get->check('id') && $this->_get->toInt('id') > 0)
		{
			$pjLocationModel = pjLocationModel::factory();
			$arr = $pjLocationModel->find($this->_get->toInt('id'))->getData();
			if (!empty($arr) && $pjLocationModel->setAttributes(array('id' => $arr['id']))->erase()->getAffectedRows() == 1)
			{
				pjMultiLangModel::factory()->where('model', 'pjLocation')->where('foreign_id', $arr['id'])->eraseAll();
				pjWorkingTimeModel::factory()->where('location_id',  $arr['id'])->eraseAll();
				pjDateModel::factory()->where('location_id',  $arr['id'])->eraseAll();
				if (!empty($arr['thumb']) && is_file($arr['thumb']))
				{
					@unlink($arr['thumb']);
				}
				
				self::jsonResponse(array('status' => 'OK', 'code' => 200, 'text' => 'Service has been deleted.'));
			} else {
				self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Service has not been deleted.'));
			}
		}
		
		self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing, empty or invalid parameters.'));
	}
	
	public function pjActionDeleteBulk()
	{
		$this->setAjax(true);
	
		if (!$this->isXHR())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
		}
		
		if (!self::isPost())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'HTTP method not allowed.'));
		}
		
		$record = $this->_post->toArray('record');
		if (count($record))
		{
			$pjLocationModel = pjLocationModel::factory();
			$arr = $pjLocationModel->whereIn('id', $record)->findAll()->getData();
			
			$pjLocationModel->reset()->whereIn('id', $record)->eraseAll();
			pjMultiLangModel::factory()->where('model', 'pjLocation')->whereIn('foreign_id', $record)->eraseAll();
			pjWorkingTimeModel::factory()->whereIn('location_id',  $record)->eraseAll();
			pjDateModel::factory()->whereIn('location_id',  $record)->eraseAll();
			foreach ($arr as $location)
			{
				if (!empty($location['thumb']) && is_file($location['thumb']))
				{
					@unlink($location['thumb']);
				}
			}
			
			self::jsonResponse(array('status' => 'OK', 'code' => 200, 'text' => 'Service(s) has been deleted.'));
		}
		exit;
	}
	
	public function pjActionGet()
	{
		$this->setAjax(true);
	
		if (!$this->isXHR())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
		}
		$pjCarModel = pjCarModel::factory();
		$pjLocationModel = pjLocationModel::factory()
			->join('pjMultiLang', "t2.foreign_id = t1.id AND t2.model = 'pjLocation' AND t2.locale = '".$this->getLocaleId()."' AND t2.field = 'name'", 'left');
		
		$get = $this->_get->raw();
		if ($q = $this->_get->toString('q'))
		{
			$pjLocationModel->where('t2.content LIKE', "%$q%");
		}

		if ($this->_get->check('status') && $get['status'] != '' && in_array($this->_get->toString('status'), array('T','F'))) {
			$pjLocationModel->where('t1.status', $this->_get->toString('status'));
		}

		$column = 'name';
		$direction = 'ASC';
		if ($this->_get->check('column') && in_array(strtoupper($this->_get->toString('direction')), array('ASC', 'DESC')))
		{
			$column = $this->_get->toString('column');
			$direction = strtoupper($this->_get->toString('direction'));
		}

		$total = $pjLocationModel->findCount()->getData();
		$rowCount = $this->_get->toInt('rowCount') ? $this->_get->toInt('rowCount') : 10;
		$pages = ceil($total / $rowCount);
		$page = $this->_get->toInt('page') ? $this->_get->toInt('page') : 1;
		$offset = ((int) $page - 1) * $rowCount;
		if ($page > $pages)
		{
			$page = $pages;
		}

		$data = $pjLocationModel->select(sprintf('t1.*, t2.content as name, 
			(SELECT COUNT(*) FROM `%s` WHERE `location_id` = `t1`.`id` LIMIT 1) AS `cnt`', $pjCarModel->getTable()))
			->orderBy("$column $direction")->limit($rowCount, $offset)->findAll()->getData();
			
		foreach ($data as $k => $v)
		{
			$data[$k]['name'] = pjSanitize::clean($v['name']);
			$data[$k]['address_1'] = pjSanitize::clean($v['address_1']);
			$data[$k]['city'] = pjSanitize::clean($v['city']);
			$data[$k]['zip'] = pjSanitize::clean($v['zip']);
		}
			
		self::jsonResponse(compact('data', 'total', 'pages', 'page', 'rowCount', 'column', 'direction'));
	}
	
	public function pjActionIndex()
	{
		$this->appendJs('jquery.datagrid.js', PJ_FRAMEWORK_LIBS_PATH . 'pj/js/');
		$this->appendJs('pjAdminLocations.js');
		
		$this->set('has_update', pjAuth::factory('pjAdminLocations', 'pjActionUpdate')->hasAccess());
		$this->set('has_create', pjAuth::factory('pjAdminLocations', 'pjActionCreate')->hasAccess());
		$this->set('has_delete', pjAuth::factory('pjAdminLocations', 'pjActionDelete')->hasAccess());
		$this->set('has_delete_bulk', pjAuth::factory('pjAdminLocations', 'pjActionDeleteBulk')->hasAccess());
		$this->set('has_wt', pjAuth::factory('pjAdminTime', 'pjActionIndex')->hasAccess());
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
			self::jsonResponse(array('status' => 'ERR', 'code' => 101, 'text' => 'HTTP method not allowed.'));
		}
		if (!pjAuth::factory('pjAdminLocations', 'pjActionUpdate')->hasAccess())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 103, 'text' => 'Access denied.'));
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
		
		$pjLocationModel = pjLocationModel::factory();
		if (!in_array($params['column'], $pjLocationModel->getI18n()))
		{
			$pjLocationModel->set('id', $params['id'])->modify(array($params['column'] => $params['value']));
		} else {
			pjMultiLangModel::factory()->updateMultiLang(array($this->getLocaleId() => array($params['column'] => $params['value'])), $params['id'], 'pjLocation', 'data');
		}
		
		self::jsonResponse(array('status' => 'OK', 'code' => 200));
	}
	
	public function pjActionUpdate()
	{
		if (!pjAuth::factory()->hasAccess())
		{
			$this->sendForbidden();
			return;
		}
		
		$post_max_size = pjUtil::getPostMaxSize();
		if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_SERVER['CONTENT_LENGTH']) && (int) $_SERVER['CONTENT_LENGTH'] > $post_max_size)
		{
			pjUtil::redirect($_SERVER['PHP_SELF'] . "?controller=pjAdminLocations&action=pjActionIndex&err=AL15");
		}
		
		if (self::isPost() && $this->_post->toInt('action_update'))
		{
		    
			$err = 'AL01';
			
			$data = array();
			$post = $this->_post->raw();
			$data['status'] = $this->_post->check('status') ? 'T' : 'F';
			$data['notify_email'] = $this->_post->check('notify_email') ? 'T' : 'F';
			$data['address_1'] = $post['address_content'];
			if (isset($_FILES['thumb']))
			{
				if($_FILES['thumb']['error'] == 0)
				{
					$size = getimagesize($_FILES['thumb']['tmp_name']);
						
					if($size == true)
					{
						$pjLocationModel = pjLocationModel::factory();
						$arr = $pjLocationModel->find($this->_post->toInt('id'))->getData();
						if (!empty($arr))
						{
							@clearstatcache();
							if (!empty($arr['thumb']) && is_file($arr['thumb']))
							{
								@unlink($arr['thumb']);
							}
						}
							
						$pjImage = new pjImage();
						$pjImage->setAllowedExt($this->extensions)->setAllowedTypes($this->mimeTypes);
						if ($pjImage->load($_FILES['thumb']))
						{
							$data['thumb'] = PJ_UPLOAD_PATH . 'locations/' . md5($this->_post->toInt('id') . PJ_SALT) . ".jpg";
							$pjImage
							->loadImage()
							->resizeSmart(130, 98)
							->saveImage($data['thumb']);
						}
					}else{
						$err = 'AL17';
					}
				}else if($_FILES['thumb']['error'] != 4){
					$err = 'AL16';
				}
			}
			
			pjLocationModel::factory()->set('id', $this->_post->toString('id'))->modify(array_merge($post, $data));
			
			$i18n_arr = $this->_post->toI18n('i18n');
			if (!empty($i18n_arr))
			{
				pjMultiLangModel::factory()->updateMultiLang($i18n_arr, $this->_post->toInt('id'), 'pjLocation');
			}
			
			if($err == 'AL01')
			{
				pjUtil::redirect(PJ_INSTALL_URL . "index.php?controller=pjAdminLocations&action=pjActionIndex&err=AL01");
			}else{
				pjUtil::redirect($_SERVER['PHP_SELF'] . "?controller=pjAdminLocations&action=pjActionUpdate&id=".$this->_post->toString('id')."&err=$err");
			}
		} 
		
		if (self::isGet())
		{
			$arr = pjLocationModel::factory()->find($this->_get->toInt('id'))->getData();
			if (empty($arr))
			{
				pjUtil::redirect(PJ_INSTALL_URL. "index.php?controller=pjAdminLocations&action=pjActionIndex&err=AL08");
			}
			$arr['i18n'] = pjMultiLangModel::factory()->getMultiLang($arr['id'], 'pjLocation');
			$this->set('arr', $arr);
			
			$price_arr = pjPriceModel::factory()
				->where('t1.type_id', $arr['id'])
				->orderBy('t1.date_from ASC, t1.date_to ASC, t1.from ASC, t1.to ASC')
				->findAll()
				->getData();
			$this->set('price_arr', $price_arr);
			
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
			
			$country_arr = pjBaseCountryModel::factory()->select('t1.*, t2.content AS name')
				->join('pjMultiLang', "t2.model='pjBaseCountry' AND t2.foreign_id=t1.id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left outer')
				->where('status', 'T')->orderBy('name ASC')->findAll()->getData();
			$this->set('country_arr', pjSanitize::clean($country_arr));
			
			$api_key_str = isset($this->option_arr['o_google_maps_api_key']) && !empty($this->option_arr['o_google_maps_api_key']) ? 'key=' . $this->option_arr['o_google_maps_api_key'] . '&' : '';
			$this->appendJs('', 'https://maps.google.com/maps/api/js?'.$api_key_str.'libraries=places&region=uk&language=en', true);
				
			$this->appendCss('jasny-bootstrap.min.css', PJ_THIRD_PARTY_PATH . 'jasny/');
			$this->appendJs('jasny-bootstrap.min.js', PJ_THIRD_PARTY_PATH . 'jasny/');
			
			$this->appendCss('css/select2.min.css', PJ_THIRD_PARTY_PATH . 'select2/');
			$this->appendJs('js/select2.full.min.js', PJ_THIRD_PARTY_PATH . 'select2/');
				
			$this->appendJs('jquery.multilang.js', PJ_FRAMEWORK_LIBS_PATH . 'pj/js/');
			$this->appendJs('jquery.validate.min.js', PJ_THIRD_PARTY_PATH . 'validate/');
			$this->appendJs('additional-methods.js', PJ_THIRD_PARTY_PATH . 'validate/');
			$this->appendJs('pjAdminLocations.js');
		}
	}
	
	public function pjActionGetGeocode()
	{
		$this->setAjax(true);
	
		if ($this->isXHR())
		{
			$geo = pjAdminLocations::pjActionGeocode($this->_post->raw(), $this->option_arr);
			$response = array('code' => 100);
			if (isset($geo['lat']) && !is_array($geo['lat']))
			{
				$response = $geo;
				$response['code'] = 200;
			}
			pjAppController::jsonResponse($response);
		}
		exit;
	}
	
	private static function pjActionGeocode($post, $option_arr)
	{
		$address = array();
		$address[] = $post['zip'];
		$address[] = $post['address_content'];
		$address[] = $post['city'];
		$address[] = $post['state'];
		foreach ($address as $key => $value)
		{
			$tmp = preg_replace('/\s+/', '+', $value);
			$address[$key] = $tmp;
		}
		$_address = join(",+", $address);
		$key = NULL;
		if(!empty($option_arr['o_google_geocoding_api_key']))
		{
		    $key = $option_arr['o_google_geocoding_api_key'];
		}else if(!empty($option_arr['o_google_maps_api_key'])){
		    $key = $option_arr['o_google_maps_api_key'];
		}
		$gfile = "https://maps.googleapis.com/maps/api/geocode/json?key=".$key."&address=$_address";
		$Http = new pjHttp();
		$response = $Http->request($gfile)->getResponse();
		$geoObj = pjAppController::jsonDecode($response);
		
		$data = array();
		$geoArr = (array) $geoObj;
		if ($geoArr['status'] == 'OK')
		{
			$geoArr['results'][0] = (array) $geoArr['results'][0];
			$geoArr['results'][0]['geometry'] = (array) $geoArr['results'][0]['geometry'];
			$geoArr['results'][0]['geometry']['location'] = (array) $geoArr['results'][0]['geometry']['location'];
			
			$data['lat'] = $geoArr['results'][0]['geometry']['location']['lat'];
			$data['lng'] = $geoArr['results'][0]['geometry']['location']['lng'];
		} else {
			$data['lat'] = NULL;
			$data['lng'] = NULL;
		}
		return $data;
	}
	
	public function pjActionGetCountry() {
		$this->setAjax(true);
		if ($this->isXHR()) {
			$post = $this->_post->raw();
			if (isset($post['country']) && !empty($post['country'])) {
				$pjBaseCountryModel = pjBaseCountryModel::factory();
				$q = $pjBaseCountryModel->escapeStr($post['country']);
				$q = str_replace(array('%', '_'), array('\%', '\_'), trim($q));
				$pjBaseCountryModel->where('t1.alpha_2', $q);
				$country_arr = $pjBaseCountryModel->limit(1)->findAll()->getDataIndex(0);
				if ($country_arr) {
					pjAppController::jsonResponse(array('status' => 'OK', 'id' => $country_arr['id']));
				} else {
					pjAppController::jsonResponse(array('status' => 'ERR'));
				}
			} else {
				pjAppController::jsonResponse(array('status' => 'ERR'));
			}
		}
	}
}
?>