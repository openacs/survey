# /www/survsimp/admin/survey-create.tcl
ad_page_contract {

  Form for creating a survey.

  @param  name         title for new survey
  @param  description  description for new survey

  @author raj@alum.mit.edu
  @author nstrug@arsdigita.com
  @date   February 9, 2000
  @cvs-id $Id$

} {
    survey_id:optional
    {name ""}
    {description:html ""}
    {variable_names ""}
    {type "general"}
}

set package_id [ad_conn package_id]

# bounce the user if they don't have permission to admin surveys
ad_require_permission $package_id survey_create_survey
set user_id [ad_conn user_id]

# use ad_form --DaveB
set display_type "list"

ad_form -name create_survey -confirm_template survey-create-confirm -form {
    survey_id:key
    {display_type:text(hidden)  {value $display_type}}
    {name:text(text)            {label "Survey Name"} {html {size 55}}}
    {description:text(textarea) {label "Description"} {html {rows 10 cols 40}}}
    {desc_html:text(radio)      {label "The Above Description is"}
	{options {{"Preformatted Text" "pre"}
		  {"HTML" "html"} {"Plain Text" "plain"}}}
		{value "plain"}
    }
    
} -validate { 
    {name {[string length $name] <= 4000}
    "Survey Name must be 4000 characters or less"
}     {description {[string length $description] <= 4000}
    "Survey Name must be 4000 characters or less"
}
    
} -new_data {
        
    if {[string compare $desc_html "plain"] == 0} {
	set description_html_p "f"
    } else {
	set description_html_p "t"
    }

    if {[parameter::get -package_id $package_id -parameter survey_enabled_default_p -default 0]} {
	set enabled_p "t"
    } else {
	set enabled_p "f"
    }
    db_transaction {
	db_exec_plsql create_survey ""

	# survey type-specific inserts

	if { $type == "scored" } {

	    foreach variable_name [split $variable_names ","] {
	    
		set variable_id [db_nextval "survey_variable_id_sequence"]

		db_dml add_variable_name ""

		db_dml map_variable_name ""
	    }

	    set logic_id [db_nextval "survey_logic_id_sequence"]
	
	    ### since survey_logic contains a clob on oracle and a text column
            ### on postgresql, the sql statement is different for each database
	    db_dml add_logic "" -clobs [list $logic]

	    db_dml map_logic ""
	}

	# create new section here. the questions go in the section
	# section_id is null to create a new section
	# we might want to specify a section_id later for
	# multiple section surveys
	set section_id ""
	set section_id [db_exec_plsql create_section ""]
    }
    ad_returnredirect "question-add.tcl?section_id=$section_id"
}




# function to insert survey type-specific form html

if {$type=="scored"} {
	    upvar variable_names local_variable_names
    ad_form -extend -name create_survey -form {
	{variable_names:text(text)     {label "Survey variable names<br />(comma-seperated list)"} {value $local_variable_names}
	    {html {size 65}} }
    }
}

set context_bar [ad_context_bar "Create Survey"]

ad_return_template

