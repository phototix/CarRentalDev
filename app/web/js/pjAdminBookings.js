var jQuery = jQuery || $.noConflict();
(function ($, undefined) {
	$(function () {
		"use strict";
		var validator,
			$frmCreate = $("#frmCreate"),
			$frmUpdate = $("#frmUpdate"),
			select2 = ($.fn.select2 !== undefined),
			validate = ($.fn.validate !== undefined),
			datepicker = ($.fn.datepicker !== undefined),
			datagrid = ($.fn.datagrid !== undefined),
			datetimeOptions = null,
			keyPressTimeout;
			
		if (select2 && $(".select-item").length) {
            $(".select-item").select2({
            	placeholder: myLabel.choose ,
                allowClear: true
            });
        };
        
        if($(".touchspin3").length > 0)
		{
			$(".touchspin3").TouchSpin({
				verticalbuttons: true,
	            buttondown_class: 'btn btn-white',
	            buttonup_class: 'btn btn-white',
	            max: 4294967295
	        });
		}
        
        if($(".extra-touchspin3").length > 0)
        {
	        $(".extra-touchspin3").TouchSpin({
				verticalbuttons: true,
	            buttondown_class: 'btn btn-white',
	            buttonup_class: 'btn btn-white',
	            min: 1,
	            max: 10
	        });
        }
        
        if ($('[data-toggle="tooltip"]').length > 0) {
        	$('[data-toggle="tooltip"]').tooltip();
        }
        
        if ($('.datepick').length > 0) {
        	if ($('#datePickerOptions').length) {
            	$.fn.datepicker.dates['en'] = {
            		days: ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"],
        		    daysMin: $('#datePickerOptions').data('days').split("_"),
        		    daysShort: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"],
        		    months: $('#datePickerOptions').data('months').split("_"),
        		    monthsShort: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
        		    format: $('#datePickerOptions').data('format'),
                	weekStart: parseInt($('#datePickerOptions').data('wstart'), 10),
                	stepMinute: 5
        		};
            };
        	$('.datepick').datepicker({autoclose: true}).on('changeDate', function (selected) {
        		if($(this).attr('name') == 'date_from')
        		{
        			if($('input[name="date_to"]').length > 0)
        			{
        				var $minDate = new Date(selected.date.valueOf());
        				$('input[name="date_to"]').datepicker('setStartDate', $minDate);
        				var $to = $('input[name="date_to"]'),
        					$date_to_value = $to.datepicker("getUTCDate");
        				if($date_to_value < selected.date)
    					{
        					$to.val($('input[name="date_from"]').val());
    					}
        			}
        		}
        		
        		if($(this).attr('name') == 'date_to')
        		{
        			if($('input[name="date_from"]').length > 0)
        			{
        				var $maxDate = new Date(selected.date.valueOf());
        				$('input[name="date_from"]').datepicker('setEndDate', $maxDate);
        				var $from = $('input[name="date_from"]'),
        					$date_from_value = $from.datepicker("getUTCDate");
        				if($date_from_value > selected.date)
    					{
        					$from.val($('input[name="date_to"]').val());
    					}
        			}
        		}
            });
        }
        
        if ($('#dateTimePickerOptions').length) {
        	var currentDate = new Date(),
        		$optionsEle = $('#dateTimePickerOptions');
        	
	        moment.updateLocale('en', {
				week: { dow: parseInt($optionsEle.data('wstart'), 10) },
				months : $optionsEle.data('months').split("_"),
		        weekdaysMin : $optionsEle.data('days').split("_")
			});
	        datetimeOptions = {
					format: $optionsEle.data('format'),
					locale: moment.locale('en'),
					allowInputToggle: true,
					ignoreReadonly: true,
					useCurrent: false
				};
	        $('.datetimepick').datetimepicker(datetimeOptions);
	        
	        var $dt_from =$('#date_from'),
				$dt_to =$('#date_to'),
				$actual_dropoff_datetime =$('#actual_dropoff_datetime');
			$dt_from.datetimepicker(datetimeOptions).on('dp.change', function (e) {
				var $frm = $(this).closest("form"),
					$from = e.date.valueOf();
				if ($dt_to.val() != '') {
					var $to = $dt_to.data("DateTimePicker").date().valueOf();
					if ($to < $from) {
						$dt_to.val($dt_from.val());
					}
				}
				$dt_to.data("DateTimePicker").minDate(e.date);
				var $from = $frm.find('input[name="date_from"]').val(),
        			$to = $frm.find('input[name="date_to"]').val();
				if ($from != '' && $to != '') {
	        		checkAvailability($frm);
	        		getPrices($frm);
	        	}
				if (parseInt($('#pickup_id').val(), 10) > 0) {
					$('#pickup_id').valid();
				}
			});
			$dt_to.datetimepicker(datetimeOptions).on('dp.change', function (e) {
				var $frm = $(this).closest("form"),
					$from = $frm.find('input[name="date_from"]').val(),
	        		$to = $frm.find('input[name="date_to"]').val();
				$dt_from.data("DateTimePicker").maxDate(e.date);
				if ($from != '' && $to != '') {
	        		checkAvailability($frm);
	        		getPrices($frm);
	        		$('#dropoff_datetime').val($to);
	        	}
				if (parseInt($('#return_id').val(), 10) > 0) {
					$('#return_id').valid();
				}
			});
			$actual_dropoff_datetime.datetimepicker(datetimeOptions).on('dp.change', function (e) {
				var $frm = $(this).closest("form");
				getExtraHoursUsage($frm);
			});
        }
        
        if (validate) {
			$.validator.addMethod("validDates", function (value, element) {
				return parseInt(value, 10) === 1;
			}, myLabel.dateRangeValidation);
		}
        if ($frmCreate.length > 0 || $frmUpdate.length > 0) 
		{
        	$('#pickup_id, #return_id').on('change', function() { 
        	    $(this).valid();
        	});
        	$("#setStartValue").bind("click", function (e) {
				$('#start').val($("#setStartValue").attr("rel"));
			})
        	if ($frmCreate.length > 0 && validate) {
				$frmCreate.validate({
					rules: {
						"dates": "validDates",
						"date_from": {
							remote: {
								url: "index.php?controller=pjAdminBookings&action=pjActionCheckPickup",
								data:{
									pickup_id: function(){
										return $frmCreate.find('select[name="pickup_id"]').val();
									}
								}
							}
						},
						"date_to": {
							remote: {
								url: "index.php?controller=pjAdminBookings&action=pjActionCheckReturn",
								data:{
									return_id: function(){
										return $frmCreate.find('select[name="return_id"]').val();
									}
								}
							}
						},
						"pickup_id": {
							remote: {
								url: "index.php?controller=pjAdminBookings&action=pjActionCheckPickup",
								data:{
									date_from: function(){
										return $frmCreate.find('input[name="date_from"]').val();
									}
								}
							}
						},
						"return_id": {
							remote: {
								url: "index.php?controller=pjAdminBookings&action=pjActionCheckReturn",
								data:{
									date_to: function(){
										return $frmCreate.find('input[name="date_to"]').val();
									}
								}
							}
						}
					},
					onkeyup: false,
					ignore: "",
					invalidHandler: function (event, validator) {
					    if (validator.numberOfInvalids()) {
					    	var $_id = $(validator.errorList[0].element, this).closest("div.tab-pane").attr("id");
					    	$('.tab-'+$_id).trigger("click");
					    };
					},
					submitHandler: function (form) {
						if($(form).find(":submit").get(0))
						{
							var l = Ladda.create( $(form).find(":submit").get(0) );
							l.start();
						}		
						if($(form).find(":submit").get(1))
						{
							var l = Ladda.create( $(form).find(":submit").get(1) );
							l.start();
						}	
						return true;
					}
				});
			}
        	
	        if ($frmUpdate.length > 0 && validate) {
				$frmUpdate.validate({
					rules: {
						"dates": "validDates",
						"date_from": {
							remote: {
								url: "index.php?controller=pjAdminBookings&action=pjActionCheckPickup",
								data:{
									pickup_id: function(){
										return $frmUpdate.find('select[name="pickup_id"]').val();
									}
								}
							}
						},
						"date_to": {
							remote: {
								url: "index.php?controller=pjAdminBookings&action=pjActionCheckReturn",
								data:{
									return_id: function(){
										return $frmUpdate.find('select[name="return_id"]').val();
									}
								}
							}
						},
						"pickup_id": {
							remote: {
								url: "index.php?controller=pjAdminBookings&action=pjActionCheckPickup",
								data:{
									date_from: function(){
										return $frmUpdate.find('input[name="date_from"]').val();
									}
								}
							}
						},
						"return_id": {
							remote: {
								url: "index.php?controller=pjAdminBookings&action=pjActionCheckReturn",
								data:{
									date_to: function(){
										return $frmUpdate.find('input[name="date_to"]').val();
									}
								}
							}
						}
					},
					onkeyup: false,
					ignore: "",
					invalidHandler: function (event, validator) {
					    if (validator.numberOfInvalids()) {
					    	var $_id = $(validator.errorList[0].element, this).closest("div.tab-pane").attr("id");
					    	$('.tab-'+$_id).trigger("click");
					    };
					},
					submitHandler: function (form) {
						for (var i=0; i<5; i++) {
							if($(form).find(":submit").get(i))
							{
								var l = Ladda.create( $(form).find(":submit").get(i) );
								l.start();
							}
						}
						var $car_id = parseInt($('#car_id').val(), 0),
							$collect_car_id = parseInt($('#collect_car_id').val(), 0);
						if ($car_id != $collect_car_id) {
							$('#car_id').val($collect_car_id);
						}
						return true;
					}
				});
				
				if ($('#tblExtras > tbody > tr').length > 0) {
					$('#tblExtras > tbody > tr').each(function() {
						var $tr = $(this),
							$type = $('option:selected', $tr.find('.pj-extra-item')).attr('data-type');
						if ($type == 'single') {
							$tr.find('.extra-touchspin3').trigger("touchspin.updatesettings", {min: 1, max: 1});
						} else {
							$tr.find('.extra-touchspin3').trigger("touchspin.updatesettings", {min: 1, max: 10});
						}
					});
				}
			}
		}
		
        function formatCarType(val, obj) {
			if (myLabel.has_update_type) {
				return ['<a href="index.php?controller=pjAdminTypes&action=pjActionUpdate&id=', obj.type_id ,'">'+ val + '</a>'].join(""); 
			}else{
				return val;
			}
		}

		function formatCar(val, obj) {
			if (myLabel.has_update_car) {
				return ['<a href="index.php?controller=pjAdminCars&action=pjActionIndex&id=', obj.car_id ,'">'+ val + '</a>'].join("");
			}else{
				return val;
			}
		}
		
		function formatStatus(val, obj) {
			if(val == 'confirmed')
			{
				return '<div class="btn bg-confirmed btn-xs no-margin"><i class="fa fa-check"></i> ' + myLabel.confirmed + '</div>';
			}else if(val == 'cancelled'){
				return '<div class="btn bg-cancelled btn-xs no-margin"><i class="fa fa-times"></i> ' + myLabel.cancelled + '</div>';
			}else if(val == 'pending'){
				return '<div class="btn bg-pending btn-xs no-margin"><i class="fa fa-exclamation-triangle"></i> ' + myLabel.pending + '</div>';
			}else if(val == 'collected'){
				return '<div class="btn bg-collected btn-xs no-margin"><i class="fa fa-check"></i> ' + myLabel.collected + '</div>';
			}else if(val == 'completed'){
				return '<div class="btn bg-completed btn-xs no-margin"><i class="fa fa-check"></i> ' + myLabel.completed + '</div>';
			}
		}
		if ($("#grid").length > 0 && datagrid) {
			var buttons = [];
			if (myLabel.has_update) {
				buttons.push({type: "edit", url: "index.php?controller=pjAdminBookings&action=pjActionUpdate&id={:id}"});
			}
			if (myLabel.has_delete) {
				buttons.push({type: "delete", url: "index.php?controller=pjAdminBookings&action=pjActionDeleteBooking&id={:id}"});
			}
		
			var actions = [];
			if (myLabel.has_delete_bulk) {
				actions.push({text: myLabel.delete_selected, url: "index.php?controller=pjAdminBookings&action=pjActionDeleteBookingBulk", render: true, confirmation: myLabel.delete_confirmation});
			}
			
			var $grid = $("#grid").datagrid({
				buttons: buttons,
				columns: [
		          		  {text: myLabel.pick_drop, type: "text", sortable: false, editable: false,},
				          {text: myLabel.booking_type, type: "text", sortable: true, editable: false , renderer: formatCarType},
				          {text: myLabel.booking_car, type: "text", sortable: false, editable: false, renderer: formatCar},
				          {text: myLabel.booking_client, type: "text", sortable: false, editable: false},
				          {text: myLabel.booking_total, type: "text", sortable: true, editable: false},
				          {text: myLabel.status, type: "text", sortable: true, editable: false, renderer: formatStatus}],
				dataUrl: "index.php?controller=pjAdminBookings&action=pjActionGetBooking" + pjGrid.queryString,
				dataType: "json",
				fields: ['pick_drop','type','car_info', 'client', 'total_price','status'],
				paginator: {
					actions: actions,
					gotoPage: true,
					paginate: true,
					total: true,
					rowCount: true
				},
				saveUrl: "index.php?controller=pjAdminBookings&action=pjActionSaveBooking&id={:id}",
				select: {
					field: "id",
					name: "record[]",
					cellClass: 'cell-width-2'
				}
			});
		}	
		
		$(document).on("click", ".btn-all", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			$(this).addClass("btn-primary active").removeClass("btn-default")
				.siblings(".btn").removeClass("btn-primary active").addClass("btn-default");
			var content = $grid.datagrid("option", "content"),
				cache = $grid.datagrid("option", "cache");
			$.extend(cache, {
				status: "",
				filter: "",
				q: "",
				type_id: "",
				booking_id: "",
				pickup_from: "",
				pickup_to: "",
				return_from: "",
				return_to: "",
				pickup_id: "",
				return_id: ""
			});
			$grid.datagrid("option", "cache", cache);
			$grid.datagrid("load", "index.php?controller=pjAdminBookings&action=pjActionGetBooking", "created", "DESC", content.page, content.rowCount);
			
		}).on("click", ".btn-filter", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			var $this = $(this),
				content = $grid.datagrid("option", "content"),
				cache = $grid.datagrid("option", "cache"),
				obj = {};
			$this.addClass("btn-primary active").removeClass("btn-default")
				.siblings(".btn").removeClass("btn-primary active").addClass("btn-default");
			obj.status = "";
			obj[$this.data("column")] = $this.data("value");
			$.extend(cache, obj);
			$grid.datagrid("option", "cache", cache);
			$grid.datagrid("load", "index.php?controller=pjAdminBookings&action=pjActionGetBooking", "created", "DESC", content.page, content.rowCount);
			
		}).on("submit", ".frm-filter", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			var $this = $(this),
				content = $grid.datagrid("option", "content"),
				cache = $grid.datagrid("option", "cache");
			$.extend(cache, {
				q: $this.find("input[name='q']").val()
			});
			$grid.datagrid("option", "cache", cache);
			$grid.datagrid("load", "index.php?controller=pjAdminBookings&action=pjActionGetBooking" + pjGrid.queryString, "created", "DESC", content.page, content.rowCount);
			return false;
		}).on("reset", ".frm-filter-advanced", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			var $frm = $('.frm-filter-advanced');
			$frm.find("input[name='booking_id']").val('');
			$frm.find("select[name='type_id']").val('');
			$frm.find("select[name='pickup_id']").val('');
			$frm.find("select[name='return_id']").val('');
			$frm.find("select[name='status']").val('');
			$frm.find("input[name='pickup_from']").val('');
			$frm.find("input[name='pickup_to']").val('');
			$frm.find("input[name='return_from']").val('');
			$frm.find("input[name='return_to']").val('');
			$(".btn-advance-search").trigger("click");
			return false;
		}).on("submit", ".frm-filter-advanced", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			var obj = {},
				$this = $(this),
				arr = $this.serializeArray(),
				content = $grid.datagrid("option", "content"),
				cache = $grid.datagrid("option", "cache");
			for (var i = 0, iCnt = arr.length; i < iCnt; i++) {
				obj[arr[i].name] = arr[i].value;
			}
			$.extend(cache, obj);
			$grid.datagrid("option", "cache", cache);
			$grid.datagrid("load", "index.php?controller=pjAdminBookings&action=pjActionGetBooking" + pjGrid.queryString, "created", "DESC", content.page, content.rowCount);
			return false;
		}).on("change", "#payment_method", function (e) {
			switch ($("option:selected", this).val()) {
				case 'creditcard':
					$(".boxCC").show();
					break;
				default:
					$(".boxCC").hide();
			}
		}).on("click", "#btnEmailConfirm", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			var booking_id = $(this).attr('data-id');
			var document_id = 0;
			var $emailContentWrapper = $('#emailContentWrapper');
			
			$('#btnSendEmailConfirm').attr('data-booking_id', booking_id);
			
			$emailContentWrapper.html("");
			$.get("index.php?controller=pjAdminBookings&action=pjActionConfirmation", {
				"booking_id": booking_id
			}).done(function (data) {
				$emailContentWrapper.html(data);
				if(data.indexOf("pjResendAlert") == -1)
				{
					myTinyMceInit.call(null, 'textarea#mceEditor', 'mceEditor');
					validator = $emailContentWrapper.find("form").validate({});
					$('#btnSendEmailConfirm').show();
				}else{
					$('#btnSendEmailConfirm').hide();
				}	
				$('#confirmEmailModal').modal('show');
			});
			return false;
		}).on("click", "#btnSendEmailConfirm", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			var $this = $(this);
			var $emailContentWrapper = $('#emailContentWrapper');
			if (validator.form()) {
				$('#mceEditor').html( tinymce.get('mceEditor').getContent() );
				$(this).attr("disabled", true);
				var l = Ladda.create(this);
			 	l.start();
				$.post("index.php?controller=pjAdminBookings&action=pjActionConfirmation", $emailContentWrapper.find("form").serialize()).done(function (data) {
					if (data.status == "OK") {
						$('#confirmEmailModal').modal('hide');
					} else {
						$('#confirmEmailModal').modal('hide');
					}
					$this.attr("disabled", false);
					l.stop();
				});
			}
			return false;
		}).on("click", "#btnSmsConfirm", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			var booking_id = $(this).attr('data-id');
			var document_id = 0;
			var $smsContentWrapper = $('#smsContentWrapper');
			
			$('#btnSendSmsConfirm').attr('data-booking_id', booking_id);
			
			$smsContentWrapper.html("");
			$.get("index.php?controller=pjAdminBookings&action=pjActionSms", {
				"booking_id": booking_id
			}).done(function (data) {
				$smsContentWrapper.html(data);				
				if(data.indexOf("pjResendSmsAlert") == -1)
				{
					validator = $smsContentWrapper.find("form").validate({});
					$('#btnSendSmsConfirm').show();
				}else{
					$('#btnSendSmsConfirm').hide();
				}	
				$('#confirmSmsModal').modal('show');
			});
			return false;
		}).on("click", "#btnSendSmsConfirm", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			var $this = $(this);
			var $smsContentWrapper = $('#smsContentWrapper');
			if (validator.form()) {
				$(this).attr("disabled", true);
				var l = Ladda.create(this);
			 	l.start();
				$.post("index.php?controller=pjAdminBookings&action=pjActionSms", $smsContentWrapper.find("form").serialize()).done(function (data) {
					if (data.status == "OK") {
						$('#confirmSmsModal').modal('hide');
					} else {
						$('#confirmSmsModal').modal('hide');
					}
					$this.attr("disabled", false);
					l.stop();
				});
			}
			return false;
		}).on("change", "#booking_status", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			$(".bg-status").hide();
			$(".bg-" + $(this).val()).show();
		}).on("click", ".crAddExtra", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			var $this = $(this);
			$.get("index.php?controller=pjAdminBookings&action=pjActionGetExtras", {
				type_id: $("#type_id").val()
			}).done(function (data) {
				var $tr,
				$tbody = $("#tblExtras tbody");
				$tbody.append(data);
				$(".extra-touchspin3").TouchSpin({
					verticalbuttons: true,
		            buttondown_class: 'btn btn-white',
		            buttonup_class: 'btn btn-white',
		            min: 1,
		            max: 10
		        });
			});
			return false;
		}).on("click", ".crRemoveExtra", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			var $form = $(this).closest("form"),
				$tr = $(this).closest("tr");
			$tr.css("backgroundColor", "#FFB4B4").fadeOut("slow", function () {
				$tr.remove();
				getPrices($form);
			});	
			return false;
		}).on("change", "#type_id", function (e) {			
			var $form = $(this).closest('form'),
				select_type_id = $(this).find("option:selected").val();			
			$.get("index.php?controller=pjAdminBookings&action=pjActionGetCars", {type_id: select_type_id}, function (data) {
				$("#boxCars").html(data);
				
		        $("#boxCollectCars").html(data);
				$("#boxCollectCars").find("select[name=car_id]").attr("id", "collect_car_id").attr("name", "collect_car_id");
				
				if (select2 && $(".select-item").length) {
		            $(".select-item").select2({
		            	placeholder: myLabel.choose ,
		                allowClear: true
		            });
		        };
			});
			
			$.get("index.php?controller=pjAdminBookings&action=pjActionGetExtras", {type_id: select_type_id}, function (data) {
				$("#tblExtras tbody").html(data);
				$(".extra-touchspin3").TouchSpin({
					verticalbuttons: true,
		            buttondown_class: 'btn btn-white',
		            buttonup_class: 'btn btn-white',
		            max: 10
		        });
			});
			getPrices($form);
		}).on("change", "#car_id", function (e) {
			var $this = $(this),
				car_id = $this.find("option:selected").val(),
				car_label = $this.find("option:selected").text();
			if(car_id){
				$.get("index.php?controller=pjAdminBookings&action=pjActionGetCarMileage", {car_id: car_id}, function (data) {
					if ($frmUpdate.length > 0) {
						$("#collect_car_id").val(car_id).trigger('change');						
						$('#collect_current_mileage').html(data + ' ' + myLabel.mileage_unit);
						$('#cr_set_as_current').attr('rev', data);
						checkAvailability($frmUpdate);
					}
					if ($frmCreate.length > 0) {
						checkAvailability($frmCreate);
					}
				});
			}else{
				$('#collect_current_mileage').html('');
				$('#collect_car_id').val('').trigger('change');
			}
			$('#start').val(0);
			
		}).on("change", ".pj-extra-item", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			var $form = $(this).closest('form'),
				$tr = $(this).closest('tr'),
				$idx = $tr.attr('data-idx'),
				$original_price = $('option:selected', this).attr('data-original_price'),
				$price = $('option:selected', this).attr('data-price'),
				$type = $('option:selected', this).attr('data-type');
			$tr.find('.pj-extra-price').html($price);
			$('#extra_price_' + $idx).val($original_price);
			if ($type == 'single') {
				$tr.find('.extra-touchspin3').trigger("touchspin.updatesettings", {min: 1, max: 1});
			} else {
				$tr.find('.extra-touchspin3').trigger("touchspin.updatesettings", {min: 1, max: 10});
			}
			getPrices($form);
		}).on("change", ".pj-extra-qty", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			var $form = $(this).closest('form');
			getPrices($form);
		}).on("click", "#cr_set_as_current", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			$('#pickup_mileage').val($(this).attr('rev'));
		}).on("change", "#dropoff_mileage", function (e) {
			getExtraMileageCharge($frmUpdate);
		}).on("click", ".btnAddPayment", function (e) {
			var $tr,
				$tbody = $("#tblPayment tbody"),
				index = Math.ceil(Math.random() * 999999),
				h = $tbody.find("tr:last").find("td:first").html(),
				i = (h === null) ? 0 : parseInt(h, 10);
			
			i = !isNaN(i) ? i : 0;				
			$tr = $("#tblPaymentsClone").find("tbody").clone();
			$tbody.find(".notFound").remove();
			var tr_html = $tr.html().replace(/\{INDEX\}/g, 'x_' + index);
			tr_html = tr_html.replace(/\{PTCLASS\}/g, 'pj-payment-type');
			tr_html = tr_html.replace(/\{ACLASS\}/g, 'pj-payment-amount');
			tr_html = tr_html.replace(/\{SCLASS\}/g, 'pj-payment-status');
			$tbody.append(tr_html);
		}).on("click", ".btnRemovePayment", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			var $tr = $(this).closest("tr");
			$tr.css("backgroundColor", "#FFB4B4").fadeOut("slow", function () {
				$tr.remove();
				calPayment();
			});
			return false;
		}).on("click", ".btnDeletePayment", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			var $this = $(this),
				$id = $this.attr('data-id'),
				$tr = $this.closest('tr');
			swal({
				title: myLabel.alert_del_payment_title,
				text: myLabel.alert_del_payment_text,
				type: "warning",
				showCancelButton: true,
				confirmButtonColor: "#DD6B55",
				confirmButtonText: myLabel.btn_delete,
				cancelButtonText: myLabel.btn_cancel,
				closeOnConfirm: false,
				showLoaderOnConfirm: true
			}, function () {
				$.post($this.attr("href"), {id: $id}).done(function (data) {
					if (!(data && data.status)) {
						
					}
					switch (data.status) {
					case "OK":
						swal.close();
						$tr.css("backgroundColor", "#FFB4B4").fadeOut("slow", function () {
							$tr.remove();
							calPayment();
							$this.dialog("close");
						});
						break;
					}
				});
			});
			return false;
		}).on("change", ".pj-payment-type", function (e) {			
			var index = $(this).attr('data-index'),
				val = $(this).val(),
				extra_mileage_charge = $('#extra_mileage_charge').val(),
				required_deposit = $('#required_deposit').val();
			if(val == 'online'){
				var online = parseFloat(required_deposit);
				$('#amount_' + index).val(online.toFixed(2));
			}else if(val == 'extra' && extra_mileage_charge != ''){
				var extra_mileage_charge = parseFloat(extra_mileage_charge);
				$('#amount_' + index).val(extra_mileage_charge.toFixed(2));
			}else if(val == 'securitypaid' || val == 'securityreturned'){
				var security = parseFloat(myLabel.security_deposit);
				$('#amount_' + index).val(security.toFixed(2));
			}else{
				$('#amount_' + index).val('');
			}
			calPayment();
		}).on("keydown", ".pj-payment-amount", function (e) {
			clearTimeout(keyPressTimeout);
			keyPressTimeout = setTimeout( function() {
				calPayment();
	        },300);
		}).on("change", ".pj-payment-status", function (e) {
			calPayment();
		}).on("click", ".reminder-email", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			if ($dialogReminderEmail.length > 0 && dialog) {
				$dialogReminderEmail.data("id", $(this).data("id")).dialog("open");
			}
			return false;
		}).on("change", "#collect_car_id", function (e) {
			var car_id = $("option:selected", this).val();
			if(car_id){
				$.get("index.php?controller=pjAdminBookings&action=pjActionGetCarMileage", {car_id: car_id}, function (data) {
					if ($frmUpdate.length > 0) {
						$('#collect_current_mileage').html(data + ' ' + myLabel.mileage_unit);
						$('#cr_set_as_current').attr('rev', data);
					}
				});
			}else{
				$('#collect_current_mileage').html('');		
			}
		}).on("click", ".booking-tabs li a", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			var $tab_id = $(this).attr('data-tab');
			$('#tab_id').val($tab_id);
			return false;
		});

		function getExtraHoursUsage($form){
			$.post("index.php?controller=pjAdminBookings&action=pjActionExtraHoursUsage", $form.serialize()).done(function (data) {
				$('#cr_extra_hours_usage').html(data.extra_hours_usage);
			});
		}
		function getExtraMileageCharge($form){
			$.post("index.php?controller=pjAdminBookings&action=pjActionExtraMileageCharge", $form.serialize()).done(function (data) {
				$('#cr_extra_mileage_charge').html(data.extra_mileage_charge);
				$('#extra_mileage_charge').val(data.original_extra_mileage_charge);
			});
		}
		
		function getPrices($form){
			$.post("index.php?controller=pjAdminBookings&action=pjActionGetPrices", $form.serialize()).done(function (data) {
					$("input#rental_days").val(data.rental_days);
					$("input#rental_hours").val(data.hours);
					$("input#car_rental_fee").val(data.car_rental_fee);
					$("input#price_per_day").val(data.price_per_day);
					$("input#price_per_hour").val(data.price_per_hour);
					$("input#price_per_day_detail").val(data.price_per_day_detail);
					$("input#price_per_hour_detail").val(data.price_per_hour_detail);
					$("input#extra_price").val(data.extra_price);
					$("input#insurance").val(data.insurance);
					$("input#sub_total").val(data.sub_total);
					$("input#tax").val(data.tax);
					$("input#total_price").val(data.total_price);
					$("input#required_deposit").val(data.required_deposit);
					$("input#security_deposit").val(data.security_deposit);
					
					$(".cr-due-payment").html(data.total_amount_due_label);
					
					$("#cr_rental_fee").html(data.car_rental_fee_label);
					$("#cr_rental_fee_detail").html(data.car_rental_fee_detail);
					$("#cr_price_per_day").html(data.price_per_day_label);
					$("#cr_price_per_hour").html(data.price_per_hour_label);
					$("#cr_price_per_day_detail").html(data.price_per_day_detail);
					$("#cr_price_per_hour_detail").html(data.price_per_hour_detail);
					$("#cr_extra_price").html(data.extra_price_label);
					$("#cr_insurance").html(data.insurance_label);
					$("#cr_insurance_detail").html(data.insurance_detail);
					$("#cr_sub_total").html(data.sub_total_label);
					$("#cr_tax").html(data.tax_label);
					$("#cr_tax_detail").html(data.tax_detail);
					$("#cr_total_price").html(data.total_price_label);
					$("#cr_required_deposit").html(data.required_deposit_label);
					$("#cr_required_deposit_detail").html(data.required_deposit_detail);
					
					$("#cr_rental_time").html(data.rental_time);
					$("#cr_rental_time").parent().css('display', 'block');
			});
		}
		
		function checkAvailability($form){
			$.post("index.php?controller=pjAdminBookings&action=pjActionCheckAvailability", $form.serialize()).done(function (data) {
				
				if (data.code === undefined) {
					return;
				}
				switch (data.code) {
				case 300:
					if($('#date_from').val() != '' && $('#date_to').val() != '')
					{
						$("input#dates").val('1');
					}
					break;
				case 200:
					if($('#date_from').val() != '' && $('#date_to').val() != '')
					{
						$("input#dates").val('1');
					}
					break;
				case 100:
					if($('#date_from').val() != '' && $('#date_to').val() != '')
					{
						$("input#dates").val('0');
					}
					break;
				}
			});
		}
		
		function formatCurrency(price)
		{
			var format = '---', currency = myLabel.currency;
			switch (currency)
			{
				case 'USD':
					format = "$" + price.toFixed(2);
					break;
				case 'GBP':
					format = "&pound;" + price.toFixed(2);
					break;
				case 'EUR':
					format = "&euro;" + price.toFixed(2);
					break;
				case 'JPY':
					format = "&yen;" + price.toFixed(2);
					break;
				case 'AUD':
				case 'CAD':
				case 'NZD':
				case 'CHF':
				case 'HKD':
				case 'SGD':
				case 'SEK':
				case 'DKK':
				case 'PLN':
					format = price.toFixed(2) + currency;
					break;
				case 'NOK':
				case 'HUF':
				case 'CZK':
				case 'ILS':
				case 'MXN':
					format = currency + price.toFixed(2);
					break;
				default:
					format = price.toFixed(2) + currency;
					break;
			}
			return format;
		}
		
		function calPayment()
		{
			var collected = 0, security_returned = 0, due_payment = 0,
				total_price = parseFloat($('#total_price').val());
			
			$( ".pj-payment-amount" ).each(function( e ) {
				var index = $(this).attr('data-index'),
					value = $(this).val(), 
					status = $('#payment_status_' + index ).val(),
					payment_type = $( '#payment_type_' + index ).val();
				
				if(value != '' && isNaN(value) == false)
				{
					if(payment_type != 'securityreturned' && status == 'paid')
					{
						collected += parseFloat(value);
					}
					if(payment_type == 'securityreturned' && status == 'paid'){
						security_returned += parseFloat(value);
					}
				}
			});
			collected = collected - security_returned;
			due_payment = total_price - collected;
			if(due_payment < 0)
			{
				due_payment = 0;
			}
			collected = formatCurrency(collected);
			due_payment = formatCurrency(due_payment);
			$('#pj_collected').html(collected);
			$('#pj_due_payment').html(due_payment);
		}
		
		function myTinyMceInit(pSelector, pValue) {
			tinymce.init({
				relative_urls : false,
				remove_script_host : false,
				convert_urls : true,
				browser_spellcheck : true,
			    contextmenu: false,
			    selector: pSelector,
			    theme: "modern",
			    height: 300,
			    plugins: [
			         "advlist autolink link image lists charmap print preview hr anchor pagebreak",
			         "searchreplace wordcount visualblocks visualchars code fullscreen insertdatetime media nonbreaking",
			         "save table contextmenu directionality emoticons template paste textcolor"
			    ],
			    toolbar: "insertfile undo redo | styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link image | print preview media fullpage | forecolor backcolor emoticons",
			    image_advtab: true,
			    menubar: "file edit insert view table tools",
			    setup: function (editor) {
			    	editor.on('change', function (e) {
			    		editor.editorManager.triggerSave();
			    	});
			    }
			});
			if (tinymce.editors.length) {							
				tinymce.execCommand('mceAddEditor', true, pValue);
			}
		}
		$("#confirmEmailModal").on("hidden.bs.modal", function () {
        	if (tinymce.editors.length > 0) 
			{
		        tinymce.execCommand('mceRemoveEditor',true, "mceEditor");
		    }
        });
		
		$(document).on('focusin', function(e) {
			if ($(e.target).closest(".mce-window").length) {
				e.stopImmediatePropagation();
			}
		});
	});
})(jQuery);