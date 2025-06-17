var jQuery = jQuery || $.noConflict();
(function ($, undefined) {
	$(function () {
		"use strict";
		var $frmCreate = $("#frmCreate"),
			$frmAvailability = $("#frmAvailability"),
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
        
		if ($frmCreate.length > 0 && validate) {
			$frmCreate.validate({
				rules:{
					"registration_number": {
						required: true,
						remote: "index.php?controller=pjAdminCars&action=pjActionCheckRegistrationNumber"
					}
				},
				messages: {
					"registration_number": {
						remote: myLabel.car_same_reg
					}
				},
				onkeyup: false,
				submitHandler: function (form) {
					var l = Ladda.create( $(form).find(":submit").get(0) );
					l.start();
					
					$.ajaxSetup({async:false});
					var formData = new FormData(form);
					$.ajax({
			            url: "index.php?controller=pjAdminCars&action=pjActionAddCar",
			            type: 'post',
			            data: formData,
			            dataType: 'html',
			            async: true,
			            processData: false,
			            contentType: false,
			            success : function(data) {
			            	var content = $grid.datagrid("option", "content");
							$grid.datagrid("load", "index.php?controller=pjAdminCars&action=pjActionGet", content.column, content.direction, content.page, content.rowCount);
							$(form)[0].reset();
							l.stop();
							$(".select-item").val('').trigger('change');
							if (multilang && myLabel.isFlagReady == 1) {
					        	$('.pj-form-langbar-item').first().trigger('click');
							}
			            },
			            error : function(request) {
			            	l.stop();
			            }
			        });
					return false;
				}
			});
			$('[data-toggle="tooltip"]').tooltip(); 
		}
		function formatCarType(str, obj) {
			var tmp,
				arr = [];
			if(str == null)
			{
				return '';
			}
			tmp = str.split("~::~");
			for (var i = 0, iCnt = tmp.length; i < iCnt; i++) {
				arr.push(tmp[i]);
			}
			return arr.join("<br>");
		}
		if ($("#grid").length > 0 && datagrid) {
			var buttons = [];
			if (pjGrid.hasAccessUpdate) {
				buttons.push({type: "edit", url: "index.php?controller=pjAdminCars&action=pjActionUpdate&id={:id}"});
			}
			if (pjGrid.hasAccessDeleteSingle) {
				buttons.push({type: "delete", url: "index.php?controller=pjAdminCars&action=pjActionDelete&id={:id}"});
			}
			var actions = [];
			if (pjGrid.hasAccessDeleteMulti) {
				actions.push({text: myLabel.delete_selected, url: "index.php?controller=pjAdminCars&action=pjActionDeleteBulk", render: true, confirmation: myLabel.delete_confirmation});
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
		          columns: [
							{text: myLabel.car_reg, type: "text", sortable: true, editable: pjGrid.hasAccessUpdate},
							{text: myLabel.car_make, type: "text", sortable: true, editable: pjGrid.hasAccessUpdate},
							{text: myLabel.car_model, type: "text", sortable: true, editable: pjGrid.hasAccessUpdate},
							{text: myLabel.car_location, type: "text", sortable: true, editable: false},
							{text: myLabel.car_type, type: "text", sortable: true, editable: false, renderer: formatCarType}
				          ],
				dataUrl: "index.php?controller=pjAdminCars&action=pjActionGet" + pjGrid.queryString,
				dataType: "json",
				fields: ['registration_number', 'make', 'model', 'location_name', 'car_types'],
				paginator: {
					actions: actions,
					gotoPage: true,
					paginate: true,
					total: true,
					rowCount: true
				},
				saveUrl: "index.php?controller=pjAdminCars&action=pjActionSave&id={:id}",
				select: select,
				onRender: function(){
					$grid.find('.pj-table-icon-edit').each(function() {
						var $this = $(this),
							$tr = $(this).closest('tr'),
							$data_id = $tr.attr('data-id'),
							$arr = $data_id.split('_');
						if ($arr[1] == parseInt(myLabel.selected_car_id, 10)) {
							$this.trigger('click');
							return;
						}
					});
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
				q: ""
			});
			$grid.datagrid("option", "cache", cache);
			$grid.datagrid("load", "index.php?controller=pjAdminCars&action=pjActionGet", content.column, content.direction, content.page, content.rowCount);
			return false;
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
			$grid.datagrid("load", "index.php?controller=pjAdminCars&action=pjActionGet", content.column, content.direction, content.page, content.rowCount);
			return false;
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
			$grid.datagrid("load", "index.php?controller=pjAdminCars&action=pjActionGet", content.column, content.direction, content.page, content.rowCount);
			return false;
		}).on("click", ".pj-table-icon-edit", function (e) {
			var $url = $(this).attr("href");
			$.get($url).done(function (data) {
				$(".boxFormCar").html(data);
				$('[data-toggle="tooltip"]').tooltip(); 
				if ($(".select-item").length) {
		            $(".select-item").select2({
		                placeholder: myLabel.choose ,
		                allowClear: true
		            });
		        };
		        
		        if (multilang && myLabel.isFlagReady == 1) {
		        	$('.pj-form-langbar-item').first().trigger('click');
				}
		        
				$("#frmUpdate").validate({
					rules:{
						"registration_number": {
							required: true,
							remote: "index.php?controller=pjAdminCars&action=pjActionCheckRegistrationNumber&id=" + $("#frmUpdate").find("input[name='id']").val()
						}
					},
					messages: {
						"registration_number": {
							remote: myLabel.car_same_reg
						}
					},
    				onkeyup: false,
    				submitHandler: function (form) {
    					var l = Ladda.create( $(form).find(":submit").get(0) );
    					l.start();
    					
    					$.ajaxSetup({async:false});
						var formData = new FormData(form);
						$.ajax({
				            url: "index.php?controller=pjAdminCars&action=pjActionUpdate",
				            type: 'post',
				            data: formData,
				            dataType: 'html',
				            async: true,
				            processData: false,
				            contentType: false,
				            success : function(data) {
				            	var content = $grid.datagrid("option", "content");
	    						$grid.datagrid("load", "index.php?controller=pjAdminCars&action=pjActionGet", content.column, content.direction, content.page, content.rowCount);
	    						if(pjGrid.hasAccessCreate == true)
	    						{
	    							$(".pjBtnCancelUpdateCar").trigger("click");
	    						}else{
	    							$(".boxFormCar").html("");
	    						}
	    						l.stop();
				            },
				            error : function(request) {
				            	l.stop();
				            }
				        });
    					return false;
    				}
    			});
			});
			return false;
		}).on("click", ".pjBtnCancelUpdateCar", function (e) {
			if(pjGrid.hasAccessCreate == true)
			{
				var $url = 'index.php?controller=pjAdminCars&action=pjActionCreate';
				$.get($url).done(function (data) {
					$(".boxFormCar").html(data);
					$('[data-toggle="tooltip"]').tooltip(); 
					if ($(".select-item").length) {
			            $(".select-item").select2({
			                placeholder: myLabel.choose ,
			                allowClear: true
			            });
			        };
			        
			        if (multilang && myLabel.isFlagReady == 1) {
			        	$('.pj-form-langbar-item').first().trigger('click');
					}
			        
					$("#frmCreate").validate({
						rules:{
							"registration_number": {
								required: true,
								remote: "index.php?controller=pjAdminCars&action=pjActionCheckRegistrationNumber"
							}
						},
						messages: {
							"registration_number": {
								remote: myLabel.car_same_reg
							}
						},
						onkeyup: false,
						submitHandler: function (form) {
							var l = Ladda.create( $(form).find(":submit").get(0) );
							l.start();
							
							$.ajaxSetup({async:false});
							var formData = new FormData(form);
							$.ajax({
					            url: "index.php?controller=pjAdminCars&action=pjActionAddCar",
					            type: 'post',
					            data: formData,
					            dataType: 'html',
					            async: true,
					            processData: false,
					            contentType: false,
					            success : function(data) {
					            	var content = $grid.datagrid("option", "content");
									$grid.datagrid("load", "index.php?controller=pjAdminCars&action=pjActionGet", content.column, content.direction, content.page, content.rowCount);
									$(form)[0].reset();
									l.stop();
									$(".select-item").val('').trigger('change');
									if (multilang && myLabel.isFlagReady == 1) {
							        	$('.pj-form-langbar-item').first().trigger('click');
									}
					            },
					            error : function(request) {
					            	l.stop();
					            }
					        });
							return false;
						}
					});
				});
			}else{
				$(".boxFormCar").html("");
			}
			return false;
		}).on("change", "#car_type", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			loadAvailability();
			$.get("index.php?controller=pjAdminCars&action=pjActionGetFilterCars&type_id=" + $(this).val()).done(function (data) {
				$('#pjCrCarSelection').html(data);
				$('#pjCrCarSelection').find(".select-item").select2({
	                placeholder: myLabel.choose,
	                allowClear: true
	            });
			})
		}).on("change", "#car_id", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			loadAvailability();
		});
		
		function loadAvailability(){
			$('.pj-availability-loader').show();
			$.post("index.php?controller=pjAdminCars&action=pjActionLoadAvailability", $frmAvailability.serialize()).done(function (data) {
				$('#pj_availability_content').html(data);
				$('.pj-availability-loader').hide();
				if($(".pj-availability-content").length > 0)
				{
					$('.pj-booking-middle').each(function(index) {
					    var status = $(this).attr('data-status');
					    $(this).parent().addClass('pj-td-' + status);
					});
				}
				$('#tblAvailability').tableHeadFixer({"left" : 1});
			})
		}
		if($frmAvailability.length > 0){
			if ($datepick.length > 0) {
				$datepick.datepicker({autoclose: true}).on('changeDate', function (selected) {
					loadAvailability();
		        });
	        }
			loadAvailability();
		}
	});
})(jQuery);