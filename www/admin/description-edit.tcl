ad_page_contract {

    Form to allow user to the description of a survey.

    @param  section_id  integer denoting survey whose description we're changing

    @author Jin Choi (jsc@arsdigita.com) 
    @author nstrug@arsdigita.com
    @date   February 16, 2000
    @cvs-id $Id$
} {

    survey_id:integer

}

ad_require_permission $survey_id survey_modify_survey
ad_form -name edit-survey -form {
    survey_id:key
    {description:text(textarea) {label "Survey Description"} {html {rows 10 cols 65}}}
    {desc_html:text(radio)      {label "The Above Description is"}
	                        {options {{"Preformatted Text" "pre"}    
				    {"HTML" "html"} {"Plain Text" "plain"}}}}
} -edit_request {
    get_survey_info -survey_id $survey_id
    set survey_name $survey_info(name)
    set description $survey_info(description)
    set description_html_p $survey_info(description_html_p)
    set desc_html ""
    if {$description_html_p=="t"} {
	set desc_html "html"
    } else {
	set desc_html "plain"
    }
    ad_set_form_values desc_html description
    
} -validate {
    {description {[string length $description] <= 4000}
    "Description must be less than 4000 characters"
    }
}
} -edit_data { 
    if {$desc_html=="pre" || $desc_html=="html"} {
	set description_html_p t
    } else {
	set description_html_p f
    }
        db_dml survey_update_description ""

    ad_returnredirect "one?[export_url_vars survey_id]"
}

set context_bar [ad_context_bar [list "one.tcl?[export_url_vars survey_id]" $survey_info(name)] "Edit Description"]

ad_return_template
