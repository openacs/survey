ad_page_contract {

    Display a questionnaire for one survey.

    @param  section_id   id of displayed survey

    @author philg@mit.edu
    @author nstrug@arsdigita.com
    @date   28th September 2000
    @cvs-id $Id$

} {
    
    survey_id:integer,notnull
    {section_id:integer 0}
    {response_id:integer 0}
    return_url:optional

} -validate {
    survey_exists -requires {survey_id} {
	if ![db_0or1row survey_exists {}] {
	    ad_complain "Survey $survey_id does not exist"
	}
    set user_id [ad_maybe_redirect_for_registration]
    set number_of_responses [db_string count_responses {}]
    get_survey_info -survey_id $survey_id
    set name $survey_info(name)
    set description $survey_info(description)
    set single_response_p $survey_info(single_response_p)
    set editable_p $survey_info(editable_p)
    set display_type $survey_info(display_type)
	if {($single_response_p=="t" && $editable_p=="f" && $number_of_responses>0) || ($single_response_p=="t" && $editable_p=="t" && $number_of_responses>0 && $response_id==0)} {
	    ad_complain "You have already completed this survey"
	} elseif {$response_id>0 && $editable_p=="f"} {
	    ad_complain "This survey is not editable"
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

set context_bar [ad_context_bar "$name"]
set button_label "Submit response"
if {$editable_p == "t"} {
    if {$response_id > 0} {
	set button_label "Modify previous response"
	db_1row get_initial_response ""
    }
}

# build a list containing the HTML (generated with survey_question_display) for each question
set rownum 0
    
set questions [list]

db_foreach survey_sections {} {

    db_foreach question_ids_select {} {
	lappend questions [survey_question_display $question_id $response_id]
    }

    # return_url is used for infoshare - if it is set
    # the survey will return to it rather than
    # executing the survey associated with the logic
    # after the survey is completed
    #
    if ![info exists return_url] {
	set return_url {}
    }
}
set form_vars [export_form_vars section_id survey_id]
ad_return_template
