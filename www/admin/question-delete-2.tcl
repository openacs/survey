# /www/survsimp/admin/question-delete.tcl
ad_page_contract {

  Delete a question from a survey, along with all responses.

  @param  question_id     question we're deleting
  @author jsc@arsdigita.com
  @date   March 13, 2000
  @cvs-id question-delete-2.tcl,v 1.6.2.4 2000/07/21 20:22:35 seb Exp
} {

    question_id:integer

}

ad_require_permission $question_id survey_delete_question

set user_id [ad_get_user_id]

db_1row section_id_from_question_id ""

db_transaction {
    db_dml survey_question_responses_delete "delete from survey_question_responses where question_id = :question_id" 

db_dml survey_question_choices_score_delete "delete from survey_choice_scores where choice_id in (select choice_id from survey_question_choices
          where question_id = :question_id)"

    db_dml survey_question_choices_delete "delete from survey_question_choices where question_id = :question_id" 

    db_dml survey_questions_delete "delete from survey_questions where question_id = :question_id" 

} on_error {
    ad_return_error "Database Error" "There was an error while trying to delete the question:
        <pre>
        $errmsg
        </pre>
        <p> Please go back to the <a href=\"one?section_id=$section_id\">survey</a>.
        "
   ad_script_abort
}

db_release_unused_handles
ad_returnredirect "one?[export_url_vars survey_id]" 

