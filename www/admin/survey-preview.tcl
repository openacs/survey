ad_page_contract {

    Display a questionnaire for one survey.

    @param  section_id   id of displayed survey

    @author philg@mit.edu
    @author nstrug@arsdigita.com
    @date   28th September 2000
    @cvs-id $Id$

} {
    
    survey_id:integer,notnull
    {section_id:integer ""}
    return_url:optional

} -validate {
    survey_exists -requires {survey_id} {
	if ![db_0or1row survey_exists {}] {
	    ad_complain "Survey $survey_id does not exist"
	}
    }
} -properties {

    name:onerow
    section_id:onerow
    button_label:onerow
    questions:onerow
    description:onerow
    modification_allowed_p:onerow
    return_url:onerow
}

ad_require_permission $survey_id survey_take_survey

    get_survey_info -survey_id $survey_id
    set name $survey_info(name)
    set description $survey_info(description)
    set single_response_p $survey_info(single_response_p)
    set editable_p $survey_info(editable_p)
    set display_type $survey_info(display_type)

set context_bar [ad_context_bar "Preview $name"]

# build a list containing the HTML (generated with survey_question_display) for each question
set rownum 0
    
set questions [list]

db_foreach survey_sections {} {

    db_foreach question_ids_select {} {
	lappend questions [survey_question_display $question_id]
    }


    }

set return_url "one?[export_vars survey_id]"
set form_vars [export_form_vars section_id survey_id]
ad_return_template
