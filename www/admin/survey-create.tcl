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
    {survey_id {[db_string count_surveys "select count(survey_id) from surveys where survey_id=:survey_id"] < 1} "oops"
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


	# create new section here. the questions go in the section
	# section_id is null to create a new section
	# we might want to specify a section_id later for
	# multiple section surveys
	set section_id ""
	set section_id [db_exec_plsql create_section ""]
    }
    ad_returnredirect "question-add?section_id=$section_id"
    ad_script_abort
}




# function to insert survey type-specific form html

set context_bar [ad_context_bar "Create Survey"]

ad_return_template

