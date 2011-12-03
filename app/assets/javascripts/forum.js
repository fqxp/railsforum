/* create nice-looking buttons */
$(document).ready(function () {
	$('button,input[type="submit"]').button();
});

$.fn.extend({
	stylize_file_input: function(text) {
		var $this = this;
		$this.parent().css('position', 'relative');
		$this.css({opacity: 0, position: 'relative', 'z-index': 998});
		
		// add an overlay to get a pointer cursor
		var choose_button = $('<span>' + text + '</span>')
			.css({position: 'absolute', opacity: 1, 
				  top: $this.position().top, left: $this.position().left, 
				  cursor: 'pointer', 
				  zIndex: 999})
		    .button()
			.click(function(ev) {
				$this.click();
			});
		$this.after(choose_button);

		var filename_label = $('<span class="avatar_filename"/>');
		choose_button.after(filename_label);

		$this.change(function(ev) {
			filename_label.text($this.val());
		});
		$this.css('width', choose_button.width());
		
		return $this;
	},
	
	/* Call this on a form to only enable submit button if requirements are met.
	 * required_els is a selector of text fields that need to be non-empty.
	 * 
	 * Example:
	 * Suppose you have a form with id 'my_form', with two text fields 'field1' and
	 * 'field2', then 
	 *   $('#my_form').enable_submit_if_possible('#field1, #field2');
	 * will make enable the submit only if field1 and field2 are not empty.
	 */
	enable_submit_if_possible: function(required_els) {
		var $this = this;
		var _check_required = function() {
			var reqs_satisfied = true;
			$(required_els).each(function(index) {
				reqs_satisfied = reqs_satisfied && $(this)[0].value.length > 0;
			});
			return reqs_satisfied;
		}
		var _enable_submit_if_possible = function() {
			$this.find('input[type="submit"]')
		  		.button('option', 'disabled', !_check_required());
		}
		
		$('input[type="submit"]', $this).button({disabled: true});
		_enable_submit_if_possible();
		$(required_els, $this)
			.keyup(_enable_submit_if_possible)
			.change(_enable_submit_if_possible);
	}
});