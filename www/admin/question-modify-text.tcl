ad_page_contract {

    Allow the user to modify the text of a question.

    @param   section_id   survey this question belongs to
    @param   question_id question which text we're changing

    @author  cmceniry@arsdigita.com
    @author  nstrug@arsdigita.com
    @date    Jun 16, 2000
    @cvs-id  $Id$
} {

    question_id:integer
    section_id:integer

}

ad_require_permission $section_id survey_modify_question

get_survey_info -section_id $section_id
set survey_name $survey_info(name)
set survey_id $survey_info(survey_id)

ad_form -name modify_question -form {
    question_id:key
    {question_text:text(textarea) {label Question} {html {rows 5 cols 70}}}
    {section_id:text(hidden) {value $section_id}}
    {survey_id:text(hidden) {value $survey_id}}
} -select_query_name {survey_question_text_from_id} -edit_data {
    
db_dml survey_question_text_update "update survey_questions set question_text=:question_text where question_id=:question_id" 
ad_returnredirect "one.tcl?survey_id=$survey_id"

}

set context_bar [ad_context_bar [list "one?[export_url_vars survey_id]" $survey_info(name)] "Modify a Question's Text"]

ad_return_template
