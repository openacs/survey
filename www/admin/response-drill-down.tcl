ad_page_contract {

  Display the list of users who gave a particular answer to a
  particular question.

  @param   question_id  question for which we're drilling down responses
  @param   choice_id    we're seeking respondents who selected this choice
                        as an answer to question

  @author  philg@mit.edu
  @author  jsc@arsdigita.com
  @author  nstrug@arsdigita.com
  @date    February 16, 2000
  @cvs-id  $Id$

} {

  question_id:integer,notnull
  choice_id:integer,notnull
  
}

ad_require_permission $question_id survey_admin_survey

# get the prompt text for the question and the ID for survey of 
# which it is part

set question_exists_p [db_0or1row get_question_text ""]
get_survey_info -section_id $section_id
set survey_name $survey_info(name)
set survey_id $survey_info(survey_id)

if { !$question_exists_p }  {
    db_release_unused_handles
    ad_return_error "Survey Question Not Found" "Could not find a survey question #$question_id"
    return
}

set response_exists_p [db_0or1row get_response_text ""]

if { !$response_exists_p } {
    db_release_unused_handles
    ad_return_error "Response Not Found" "Could not find the response #$choice_id"
    return
}

# Get information of users who responded in particular manner to
# choice question.

db_multirow user_responses all_users_for_response {}

set context_bar [ad_context_bar \
     [list "one?[export_url_vars survey_id]" $survey_info(name)] \
     [list "responses?[export_url_vars survey_id]" "Responses"] \
     "One Response"]

ad_return_template