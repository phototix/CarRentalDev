var jQuery_1_8_2 = jQuery_1_8_2 || $.noConflict();
(function ($, undefined) {
	$(function () {
		var $frmCreate = $("#frmCreate"),
			$frmUpdate = $("#frmUpdate"),
			validate = ($.fn.validate !== undefined),
			multilang = ($.fn.multilang !== undefined),
			datagrid = ($.fn.datagrid !== undefined),
			$datepick = $(".datepick"),
			datepicker = ($.fn.datepicker !== undefined);
		
		if (multilang && myLabel.isFlagReady == 1) {
			$(".multilang").multilang({
				langs: pjLocale.langs,
				flagPath: pjLocale.flagPath,
				tooltip: "",
				select: function (event, ui) {
					$("input[name='locale_id']").val(ui.index);					
				}
			});
		}
		
		if ($(".select-item").length) {
            $(".select-item").select2({
                placeholder: myLabel.choose ,
                allowClear: true
            });
        };
        
        if($(".touchspin3").length > 0)
		{
			$(".touchspin3").TouchSpin({
				min: 0,
				max: 4294967295,
				step: 1,
				verticalbuttons: true,
	            buttondown_class: 'btn btn-white',
	            buttonup_class: 'btn btn-white'
	        });
		}
        
        if ($('#datePickerOptions').length) {
        	$.fn.datepicker.dates['en'] = {
        		days: ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"],
    		    daysMin: $('#datePickerOptions').data('days').split("_"),
    		    daysShort: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"],
    		    months: $('#datePickerOptions').data('months').split("_"),
    		    monthsShort: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
    		    format: $('#datePickerOptions').data('format'),
            	weekStart: parseInt($('#datePickerOptions').data('wstart'), 10),
    		};
        };
        
        function myDatepickInit() {
        	$datepick.datepicker({autoclose: true}).on('changeDate', function (selected) {
        		var idx = $(this).closest('tr').attr('data-idx'),
        			element_id = $(this).attr('id');        		
        		if (parseInt(element_id.indexOf("date_from_"), 10) >= 0) {
	        		var $toElement = $("#date_to_" + idx);
        			if($toElement.length > 0)
        			{
        				var $minDate = new Date(selected.date.valueOf());
        				$toElement.datepicker('setStartDate', $minDate);
        				if ($toElement.val() != '') {
	        				var date_to_value = $toElement.datepicker("getUTCDate");
	        				if(date_to_value < selected.date)
	    					{
	        					$toElement.val($(this).val());
	    					}
        				} else {
        					$toElement.val($(this).val());
        				}
        			}
        		}

        		if (parseInt(element_id.indexOf("date_to_"), 10) >= 0) {
        			var $fromElement = $("#date_from_" + idx),
        				$toElement = $("#date_to_" + idx);
        			if($fromElement.length > 0 && $toElement.length > 0)
        			{
        				var $maxDate = new Date(selected.date.valueOf());
        				$fromElement.datepicker('setEndDate', $maxDate);
        				if ($fromElement.val() != '') {
	        				var date_from_value = $fromElement.datepicker("getUTCDate");
	        				if(date_from_value > selected.date)
	    					{
	        					$fromElement.val($toElement.val());
	    					}
        				}
        			}
        		}
            });
        }
        
		if ($frmCreate.length > 0 && validate) {
			$frmCreate.validate({
				errorPlacement: function (error, element) {
					var name = element.attr('name');
					error.insertAfter(element.parent());
				},
				onkeyup: false
			});
			$('[data-toggle="tooltip"]').tooltip(); 
		}
		
		if ($frmUpdate.length > 0 && validate) {
			$frmUpdate.validate({
				errorPlacement: function (error, element) {
					var name = element.attr('name');
					error.insertAfter(element.parent());
				},
				onkeyup: false,
				ignore: "",
				submitHandler: function(form){
					var duplidated = false,
						empty = false,
						$duplicated_tr = null,
						$duplicated_next_tr = null;
					if($('#tblRates > tbody > tr').length > 0){
						$('#tblRates > tbody > tr').each(function(index){
							var $tr = $(this),
								$idx = $tr.attr('data-idx'),
								$date_from = $('input[name="date_from['+$idx+']"]').val(),
								$date_to = $('input[name="date_from['+$idx+']"]').val(),
								$from = $('input[name="from['+$idx+']"]').val(),
								$to = $('input[name="to['+$idx+']"]').val()
								$price_per = $('select[name="price_per['+$idx+']"]').val();
							
							$('#tblRates > tbody > tr').each(function(idx){
								if(idx > index)
								{
									var $next_tr = $(this),
										$next_idx = $next_tr.attr('data-idx'),										
										$next_date_from = $('input[name="date_from['+$next_idx+']"]').val(),
										$next_date_to = $('input[name="date_from['+$next_idx+']"]').val(),
										$next_from = $('input[name="from['+$next_idx+']"]').val(),
										$next_to = $('input[name="to['+$next_idx+']"]').val()
										$next_price_per = $('select[name="price_per['+$next_idx+']"]').val();
								}
								
								if($date_from == $next_date_from && $date_to == $next_date_to && $from == $next_from && $to == $next_to && $price_per == $next_price_per)
								{
									duplidated = true;
									$duplicated_tr = $tr;
									$duplicated_next_tr = $next_tr;										
									return false;
								}
							});
						});
					}else{
						/*empty = true;*/
					}
					if(duplidated == true)
					{
						$('#duplicateRatesModal').data('tr', $duplicated_tr).data('next_tr', $duplicated_next_tr).modal('show');
					}else{
						if(empty == true)
						{
							$('#emptyRatesModal').modal('show');
						}else{
							var l = Ladda.create( $(form).find(":submit").get(0)),
								l2 = Ladda.create( $(form).find(".btnSaveRates").get(0));
							l.start();
							l2.start();
							return true;
						}
					}
					return false;
				}
			});
			$('[data-toggle="tooltip"]').tooltip(); 
		}
				
		if ($("#grid").length > 0 && datagrid) {
			function formatImage(val, obj) {
				var src = val ? val : 'app/web/img/backend/no_img.png';
				return ['<a href="index.php?controller=pjAdminTypes&action=pjActionUpdate&id=', obj.id ,'"><img src="', src, '" style="width: 100px" /></a>'].join("");
			}
			
			function formatModel(val, obj) {
				str = '<span class="attribute">' + obj.passengers + ' <i class="fa fa-user"></i></span>';
				str += '<span class="attribute">' + obj.luggages + ' <i class="fa fa-suitcase"></i></span>';
				str += '<span class="attribute">' + obj.doors + ' <i class="fa fa-taxi"></i></span>';
				str += '<span class="attribute">' + obj.transmission + ' <i class="fa fa-cog"></i></span>';
				
				return str;
			}
			function formatCount(val, obj) {
				
				return ['<a href="index.php?controller=pjAdminCars&action=pjActionIndex&type_id=', obj.id ,'">'+ val + '</a>'].join(""); 
			}
			
			var editable = false;
			var buttons = [];
			if (myLabel.has_update) {
				editable = true;
				buttons.push({type: "edit", url: "index.php?controller=pjAdminTypes&action=pjActionUpdate&id={:id}"});
			}
			if (myLabel.has_delete) {
				buttons.push({type: "delete", url: "index.php?controller=pjAdminTypes&action=pjActionDelete&id={:id}"});
			}
			var actions = [];
			if (myLabel.has_delete_bulk) {
				actions.push({text: myLabel.delete_selected, url: "index.php?controller=pjAdminTypes&action=pjActionDeleteBulk", render: true, confirmation: myLabel.delete_confirmation});
			}
			
			var select = false;
			if (actions.length) {
				select = {
					field: "id",
					name: "record[]"
				};
			}
			
			var $grid = $("#grid").datagrid({
				buttons: buttons,
				columns: [{text: myLabel.type_image, type: "text", sortable: false, editable: false, renderer: formatImage},
						  {text: myLabel.type, type: "text", sortable: true, editable: false},
						  {text: myLabel.type_car_models, type: "text", sortable: false, editable: false, renderer: formatModel},
						  {text: myLabel.type_num_cars, type: "text", sortable: true, editable: false, renderer: formatCount},
				          {text: myLabel.status, type: "toggle", sortable: true, editable: editable, positiveLabel: myLabel.active, positiveValue: "T", negativeLabel: myLabel.inactive, negativeValue: "F"}],
				dataUrl: "index.php?controller=pjAdminTypes&action=pjActionGet",
				dataType: "json",
				fields: ['thumb_path',  'type' , 'model' ,'cnt' ,'status'],
				paginator: {
					actions: actions,
					gotoPage: true,
					paginate: true,
					total: true,
					rowCount: true
				},
				saveUrl: "index.php?controller=pjAdminTypes&action=pjActionSave&id={:id}",
				select: select
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
				q: ""
			});
			$grid.datagrid("option", "cache", cache);
			$grid.datagrid("load", "index.php?controller=pjAdminTypes&action=pjActionGet", "type", "ASC", content.page, content.rowCount);
			
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
			$grid.datagrid("load", "index.php?controller=pjAdminTypes&action=pjActionGet", "type", "ASC", content.page, content.rowCount);
			
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
			$grid.datagrid("load", "index.php?controller=pjAdminTypes&action=pjActionGet", "id", "ASC", content.page, content.rowCount);
			return false;
		}).on("click", ".pj-delete-image", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			
			var id = $(this).attr('rev');
			var $this = $(this);
			swal({
				title: myLabel.alert_title,
				text: myLabel.alert_text,
				type: "warning",
				showCancelButton: true,
				confirmButtonColor: "#DD6B55",
				confirmButtonText: myLabel.btn_delete,
				cancelButtonText: myLabel.btn_cancel,
				closeOnConfirm: false,
				showLoaderOnConfirm: true
			}, function () {
				$.post($this.attr("href"), {id: id}).done(function (data) {
					if (!(data && data.status)) {
						
					}
					switch (data.status) {
					case "OK":
						swal.close();
						$('.pj-type-image').remove();
						break;
					}
				});
			});
		}).on("change", ".number", function (e) {
			var v = parseFloat(this.value);
		    if (isNaN(v)) {
		        this.value = '';
		    } else {
		        this.value = v.toFixed(2);
		    }
		    if (parseFloat(this.value) > 99999999999999.99) {
		    	this.value = '99999999999999.99';
		    }
		}).on("click", ".crAddRate", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			var $tbody = $("#tblRates tbody"),
				$index = 'cr_' + Math.ceil(Math.random() * 999999);
			
			var clone_text = $("#tblRatesClone").find("tbody").html();
			clone_text = clone_text.replace(/\{INDEX\}/g, $index);
			$tbody.append(clone_text);
			
			if($(".from-touchspin3-" + $index).length > 0)
			{
				$(".from-touchspin3-" + $index).TouchSpin({
					verticalbuttons: true,
		            buttondown_class: 'btn btn-white',
		            buttonup_class: 'btn btn-white',
		            min: 0,
					step: 1,
		            max: 4294967295
		        });
			}
			if($(".to-touchspin3-" + $index).length > 0)
			{
				$(".to-touchspin3-" + $index).TouchSpin({
					verticalbuttons: true,
		            buttondown_class: 'btn btn-white',
		            buttonup_class: 'btn btn-white',
		            min: 0,
					step: 1,
		            max: 4294967295
		        });
			}
			
			$datepick = $('.datepick');
			if ($datepick.length > 0) {
				myDatepickInit.call(null);
	        }
			return false;
		}).on("click", ".crRemoveRate", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			var $tr = $(this).closest("tr");
			$tr.css("backgroundColor", "#FFB4B4").fadeOut("slow", function () {
				$tr.remove();
			});	
			return false;
		}).on("change", "select.pPeriod", function () {
			var $this = $(this),
				$parent = $this.closest("tr");
			switch ($this.find("option:selected").val()) {
			case "hour":
				$parent.find(".pHour").show().end().find(".pDay").hide();				
				break;
			case "day":
				$parent.find(".pHour").hide().end().find(".pDay").show();
				break;
			}			
		}).on("click", "#btnShowDuplicateRate", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			var $tr = $('#duplicateRatesModal').data('tr'),
				$next_tr = $('#duplicateRatesModal').data('next_tr'),
				seconds = 2000,
				tr_background = $tr.css('backgroundColor'),
				next_tr_background = $next_tr.css('backgroundColor');
			$tr.css('backgroundColor', '#FFB4B4');
			$next_tr.css('backgroundColor', '#FFB4B4');
			setTimeout(function(){
				$tr.css("backgroundColor", tr_background);
				$next_tr.css("backgroundColor", next_tr_background);
			}, seconds);
			$('#duplicateRatesModal').modal('hide');
			return false;
		});
		
		if ($datepick.length > 0) {
			myDatepickInit.call(null);
        }
	});
})(jQuery_1_8_2);