ad_page_contract {

    Display the user's previous responses.

    @param   section_id   id of survey for which responses are displayed
    @param   return_url  if provided, generate a 'return' link to that URL
    @param   group_id    if specified, display all the responses for all
                         users of that group

    @author  philg@mit.edu
    @author  nstrug@arsdigita.com
    @date    28th September 2000
    @cvs-id  $Id$
} {

    survey_id:integer
    {return_url ""}

} -validate {
        survey_exists -requires {survey_id} {
	    if ![db_0or1row survey_exists {}] {
		ad_complain "Survey $section_id does not exist"
	    }
	}
} -properties {
    survey_name:onerow
    description:onerow
    responses:multirow
}

# If group_id is specified, we return all the responses for that group by any user

set user_id [ad_verify_and_get_user_id]

get_survey_info -survey_id $survey_id

set survey_name $survey_info(name)
set description $survey_info(description)
set editable_p $survey_info(editable_p)
set context_bar [ad_context_bar "Responses"]
db_multirow -extend {answer_summary} responses responses_select {} {
    set answer_summary [survey_answer_summary_display $response_id 1] 
}

ad_return_template
