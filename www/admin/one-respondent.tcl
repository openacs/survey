ad_page_contract {

    Display the filled-out survey for a single user.

    @param  user_id    user whose response we're viewing
    @param  section_id  survey we're viewing
    @author jsc@arsdigita.com
    @author nstrug@arsdigita.com
    @date   February 11, 2000
    @cvs-id $Id$
} {

    user_id:integer
    survey_id:integer

} 

ad_require_permission $survey_id survey_admin_survey

get_survey_info -survey_id $survey_id
set survey_name $survey_info(name)
set description $survey_info(description)
set type $survey_info(type)

# survey_name and description are now set 

set user_exists_p [db_0or1row user_name_from_id "select first_names, last_name from persons where person_id = :user_id" ]

if { !$user_exists_p } {
    ad_return_error "[_ survey.Not_Found]" "[_ survey.Could_not_find_user] #$user_id"
    return
}

set context_bar [ad_context_bar "[_ survey.One_Respondent]"]
 

db_multirow -extend {response_display} responses get_responses {} {
set response_display [survey_answer_summary_display $response_id 1 ]
}

ad_return_template
